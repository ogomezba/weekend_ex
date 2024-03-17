defmodule Weekend.Recipes.Recipe do
  alias Weekend.RecipeIngredients.RecipeIngredient
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :name, :string
    field :slot, :string
    field :score, :float
    field :portions, :integer
    field :last_used, :date

    has_many :recipe_ingredients, RecipeIngredient, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :score, :slot, :portions, :last_used])
    |> validate_required([:name, :score, :slot, :portions], message: "The field is mandatory")
  end
end
