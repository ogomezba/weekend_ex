defmodule Weekend.Repo.Migrations.AddPrimaryKeyToRecipeIngredients do
  use Ecto.Migration

  def change do
    alter table("recipe_ingredients") do
      modify :recipe_id, :integer, primary_key: true
      modify :ingredient_id, :integer, primary_key: true
    end
  end
end
