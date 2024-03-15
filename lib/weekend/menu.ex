defmodule Weekend.Menu do
  require Integer
  alias Weekend.RecipeIngredients.RecipeIngredient
  alias Weekend.Repo
  alias Weekend.Recipes.Recipe

  import Ecto.Query

  @last_used_weight 0.4
  @score_weight 0.6
  @random_weight_range 50..100

  def generate_menu(options) do
    preferences = options[:preferences] || []
    diners = options[:diners] || 2
    starting_slot = options[:starting_slot] || "D"

    query_recipe_ingredients =
      from ri in RecipeIngredient,
        join: i in assoc(ri, :ingredient),
        select: [:qty, :ingredient_id, ingredient: [:name, :id]],
        preload: :ingredient

    query = from r in Recipe, preload: [recipe_ingredients: ^query_recipe_ingredients]

    recipes =
      Repo.all(query)

    recipes =
      recipes
      |> Enum.sort_by(&calculate_score(&1, preferences), :desc)
      |> Enum.group_by(& &1.slot)

    {menu, recipes} = build_menu({recipes, starting_slot, 0}, diners)

    try do
      {:ok, {menu |> Enum.take(14), recipes}}
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end

  defp build_menu({_, _, occupied_slots}, _) when occupied_slots >= 14,
    do: {[], []}

  defp build_menu({menu, slot, occupied_slots}, diners) do
    recipe_slot_to_use =
      if Map.get(menu, slot) |> Enum.empty?(), do: other(slot), else: slot

    case menu[recipe_slot_to_use] do
      [%Recipe{} = next_meal | rest] ->
        covered_slots = Integer.floor_div(next_meal.portions, diners)
        menu = Map.put(menu, recipe_slot_to_use, rest)
        slot = next_slot(next_meal, slot, diners)
        occupied_slots = occupied_slots + covered_slots

        {menu, recipes} = build_menu({menu, slot, occupied_slots}, diners)

        {List.duplicate(next_meal, covered_slots) ++ menu, [next_meal | recipes]}

      _ ->
        raise "There are not enough slots to fill a whole week"
    end
  end

  defp next_slot(%Recipe{portions: portions}, slot, diners) do
    if Integer.floor_div(portions, diners)
       |> Integer.is_odd() do
      other(slot)
    else
      slot
    end
  end

  defp calculate_score(%Recipe{id: id} = recipe, preferences) do
    if id in preferences, do: 1, else: random_weight() * recipe_score(recipe)
  end

  defp random_weight, do: Enum.random(@random_weight_range) / 100.0

  defp recipe_score(recipe) do
    last_used_score =
      if is_nil(recipe.last_used),
        do: 1,
        else: Date.diff(Date.utc_today(), recipe.last_used) |> sigmoid()

    liking_score = recipe.score / 10

    @last_used_weight * last_used_score + @score_weight * liking_score
  end

  defp sigmoid(x) do
    1.0 / (1.0 + :math.exp(-0.3 * (x - 14.0)))
  end

  defp other("L"), do: "D"
  defp other("D"), do: "L"
end
