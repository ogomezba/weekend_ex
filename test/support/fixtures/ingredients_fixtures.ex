defmodule Weekend.IngredientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Weekend.Ingredients` context.
  """

  @doc """
  Generate a ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Weekend.Ingredients.create_ingredient()

    ingredient
  end
end
