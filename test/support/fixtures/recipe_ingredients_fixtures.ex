defmodule Weekend.RecipeIngredientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Weekend.RecipeIngredients` context.
  """

  @doc """
  Generate a recipe_ingredient.
  """
  def recipe_ingredient_fixture(attrs \\ %{}) do
    {:ok, recipe_ingredient} =
      attrs
      |> Enum.into(%{})

    recipe_ingredient
  end
end
