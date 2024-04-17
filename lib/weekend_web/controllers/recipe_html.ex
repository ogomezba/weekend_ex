defmodule WeekendWeb.RecipeHTML do
  use WeekendWeb, :html

  @valid_slots ~w(L D)

  embed_templates "recipe_html/*"

  def slot_options, do: @valid_slots
end
