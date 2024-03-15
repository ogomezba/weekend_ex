defmodule Weekend.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients, primary_key: false) do
      add :recipe_id, references(:recipes, on_delete: :delete_all)
      add :ingredient_id, references(:ingredients, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_ingredients, [:ingredient_id])
    create unique_index(:recipe_ingredients, [:recipe_id, :ingredient_id])
  end
end
