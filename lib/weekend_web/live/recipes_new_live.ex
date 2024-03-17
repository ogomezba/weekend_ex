defmodule WeekendWeb.RecipesNewLive do
  alias Weekend.Recipes.Recipe
  alias Weekend.Ingredients
  alias Weekend.Recipes
  use WeekendWeb, :live_view

  @valid_slots ~w(L D)

  def slot_options(), do: @valid_slots

  def mount(_params, _session, socket) do
    ingredients =
      Ingredients.list_ingredients() |> Enum.map(&{&1.id, &1}) |> Enum.into(%{})

    form = Recipes.change_recipe(%Recipe{}) |> add_defaults() |> to_form()

    socket =
      socket
      |> assign(:form, form)
      |> assign(:ingredients, ingredients)
      |> assign(:results, [])
      |> assign(:selected, %{})
      |> assign(:search_term, nil)

    {:ok, socket}
  end

  def handle_event("validate", %{"recipe" => recipe}, socket) do
    form = %Recipe{} |> Recipes.change_recipe(recipe) |> Map.put(:action, :insert) |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"recipe" => recipe}, socket) do
    %{selected: selected} = socket.assigns

    case Recipes.create_recipe(recipe, selected) do
      {:ok, recipe} ->
        {:noreply,
         socket |> put_flash(:info, "Recipe created!") |> redirect(to: ~p"/recipes/#{recipe}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("search", %{"ingredient_search" => ""}, socket),
    do: {:noreply, assign(socket, :results, [])}

  def handle_event("search", %{"ingredient_search" => original_value}, socket) do
    %{ingredients: ingredients} = socket.assigns
    value = String.downcase(original_value)

    results =
      for {id, %{name: name}} <- ingredients,
          String.downcase(name) |> String.contains?(value) do
        {id, name}
      end

    results =
      if !(value in (results |> Enum.map(fn {_, name} -> String.downcase(name) end))) do
        [{"", original_value} | results]
      else
        results
      end

    {:noreply, assign(socket, results: results, search_term: original_value)}
  end

  def handle_event("select", %{"id" => ""} = params, socket) do
    case Ingredients.create_ingredient(params) do
      {:ok, %{id: id} = ingredient} ->
        socket =
          socket
          |> update(:ingredients, &Map.put(&1, id, ingredient))
          |> assign(search_term: nil)
          |> assign(results: [])
          |> update(:selected, &Map.put(&1, id, 1))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: changeset |> to_form())}
    end
  end

  def handle_event("select", %{"id" => id}, socket) do
    id = String.to_integer(id)

    socket =
      socket
      |> update(:selected, &Map.put(&1, id, 1))
      |> assign(:search_term, nil)
      |> assign(:results, [])

    {:noreply, socket}
  end

  def handle_event("unselect", %{"id" => id}, socket) do
    id = String.to_integer(id)
    {:noreply, update(socket, :selected, &Map.delete(&1, id))}
  end

  def handle_event("product_qty", input, socket) do
    {key, value} =
      for {key, value} <- input, key != "_target", reduce: {nil, nil} do
        {_, _} -> {key, value}
      end

    value = if value != "", do: String.to_integer(value), else: 0
    key = String.to_integer(key)

    {:noreply, update(socket, :selected, &Map.put(&1, key, value))}
  end

  defp add_defaults(changeset) do
    Ecto.Changeset.change(changeset,
      slot: "D",
      score: 5,
      portions: 4
    )
  end
end
