defmodule Weekend.Repo.Migrations.AddQtyToRecipeIngredients do
  use Ecto.Migration

  def change do
    alter table("recipe_ingredients") do
      add :qty, :float, null: false
    end
  end
end
