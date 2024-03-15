defmodule Weekend.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string, null: false
      add :score, :float, null: false

      add :slot, :string,
        null: false,
        check: %{name: "only_lunch_dinner", expr: "slot IN ('D', 'L')"}

      add :portions, :integer, null: false
      add :last_used, :date

      timestamps(type: :utc_datetime)
    end
  end
end
