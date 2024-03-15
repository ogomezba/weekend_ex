defmodule WeekendWeb.MenuLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  alias Weekend.Recipes
  use WeekendWeb, :live_view

  def render(assigns) do
    ~H"""
    <.input
      type="text"
      phx-keyup="search_recipe"
      phx-debounce
      value={@search_term}
      name="preferences"
      label="Preferences?"
      autocomplete="off"
    />

    <.link href={
      ~p"/menus/new?#{%{"preferences" => @selected |> MapSet.to_list() |> Enum.join(",")}}"
    }>
      <.button class="mt-4 w-full">Generate Menu</.button>
    </.link>

    <div>
      <%= for id <- @selected do %>
        <span
          class="px-4 py-2 mr-2 mt-4 rounded-full bg-gray-100 cursor-pointer hover:bg-gray-50 text-xs inline-block"
          phx-click="unselect"
          phx-value-id={id}
        >
          <%= @recipes[id].name %>
          <button>x</button>
        </span>
      <% end %>
    </div>

    <ul class="mt-4 grid gap-y-2 grid-cols-1">
      <%= for id <- @results do %>
        <li
          class="pl-4 py-2 rounded-lg bg-gray-100 cursor-pointer hover:bg-gray-50"
          phx-click="select"
          phx-value-id={id}
        >
          <%= @recipes[id].name %>
        </li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    recipes = Recipes.list_recipes() |> Enum.map(&{&1.id, &1}) |> Enum.into(%{})
    results = recipes |> Map.keys() |> Enum.take(10)

    socket =
      socket
      |> assign(:recipes, recipes)
      |> assign(:results, results)
      |> assign(:selected, MapSet.new())
      |> assign(:search_term, nil)

    {:ok, socket}
  end

  def handle_event("search_recipe", %{"value" => ""}, %{recipes: recipes} = socket),
    do: {:noreply, assign(socket, :results, recipes |> Map.keys() |> Enum.take(10))}

  def handle_event("search_recipe", %{"value" => value}, socket) do
    %{recipes: recipes} = socket.assigns
    value = String.downcase(value)

    results =
      recipes
      |> Enum.filter(fn {_, %{name: name}} -> icontains(name, value) end)
      |> Enum.map(fn {key, _} -> key end)

    {:noreply, assign(socket, results: results, search_term: value)}
  end

  def handle_event("select", %{"id" => id}, socket) do
    %{recipes: recipes, selected: selected} = socket.assigns
    id = String.to_integer(id)
    results = recipes |> Map.keys() |> Enum.take(10)

    {:noreply,
     assign(socket, selected: MapSet.put(selected, id), results: results, search_term: nil)}
  end

  def handle_event("unselect", %{"id" => id}, socket) do
    %{recipes: recipes, selected: selected} = socket.assigns
    id = String.to_integer(id)
    results = recipes |> Map.keys() |> Enum.take(10)

    {:noreply,
     assign(socket, selected: MapSet.delete(selected, id), results: results, search_term: nil)}
  end

  defp icontains(container, containee) do
    String.downcase(container) |> String.contains?(containee)
  end
end
