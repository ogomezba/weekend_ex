defmodule WeekendWeb.RecipeHTML do
  use WeekendWeb, :html

  @valid_slots ~w(L D)

  embed_templates "recipe_html/*"

  @doc """
  Renders a recipe form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def recipe_form(assigns)

  def slot_options(), do: @valid_slots
end
