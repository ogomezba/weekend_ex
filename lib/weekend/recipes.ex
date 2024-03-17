defmodule Weekend.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias Weekend.RecipeIngredients.RecipeIngredient
  alias Ecto.Repo
  alias Weekend.Repo

  alias Weekend.Recipes.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id) do
    Repo.get!(Recipe, id) |> Repo.preload(recipe_ingredients: [:ingredient, :recipe])
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs, ingredients \\ []) do
    recipe_ingredients =
      ingredients
      |> Enum.map(fn {ingredient_id, qty} ->
        %RecipeIngredient{}
        |> RecipeIngredient.changeset(%{ingredient_id: ingredient_id, qty: qty})
      end)

    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:recipe_ingredients, recipe_ingredients)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, ingredients, attrs) do
    recipe_ingredients =
      ingredients
      |> Enum.map(fn {ingredient_id, qty} ->
        %RecipeIngredient{}
        |> RecipeIngredient.changeset(%{ingredient_id: ingredient_id, qty: qty})
      end)

    recipe
    |> Recipe.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:recipe_ingredients, recipe_ingredients)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    recipe
    |> Recipe.changeset(attrs)
  end
end
