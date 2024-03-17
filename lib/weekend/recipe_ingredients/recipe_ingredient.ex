defmodule Weekend.RecipeIngredients.RecipeIngredient do
  alias Weekend.Ingredients.Ingredient
  alias Weekend.Recipes.Recipe
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "recipe_ingredients" do
    belongs_to :recipe, Recipe, primary_key: true
    belongs_to :ingredient, Ingredient, primary_key: true

    field :qty, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:qty, :ingredient_id, :recipe_id])
    |> validate_required([:qty])
    |> validate_number(:qty, greater_than_or_equal_to: 1, less_than: 100)
  end
end
