defmodule WeekendWeb.MenuController do
  alias Weekend.Recipes
  alias Weekend.Menu
  use WeekendWeb, :controller

  def index(conn, _params) do
    recipes = Recipes.list_recipes()

    conn
    |> assign(:recipes, recipes)
    |> render(:index)
  end

  def new(conn, params) do
    preferences =
      params
      |> Map.get("preferences", "")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer(&1))

    case Menu.generate_menu(preferences: preferences) do
      {:ok, {menu, recipes}} ->
        [_ | rest] = menu
        lunches = [~c"-------" | Enum.take_every(rest, 2) |> Enum.map(& &1.name)]
        dinners = (Enum.take_every(menu, 2) |> Enum.map(& &1.name)) ++ [~c"-------"]

        menu =
          [lunches, dinners]
          |> Enum.map(fn list ->
            list
            |> Enum.with_index()
            |> Enum.map(fn {val, idx} -> {idx, val} end)
            |> Enum.into(%{})
          end)

        ingredients = calculate_ingredients(recipes)

        conn
        |> assign(:menu, menu)
        |> assign(:preferences, Enum.join(preferences, ","))
        |> assign(:ingredients, ingredients)
        |> render(:new)

      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: ~p"/menus")
    end
  end

  defp calculate_ingredients(recipes) do
    for r <- recipes,
        ri <- r.recipe_ingredients,
        reduce: %{} do
      current -> Map.update(current, ri.ingredient.name, ri.qty, &(&1 + ri.qty))
    end
  end
end
