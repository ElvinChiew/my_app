defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :age, :integer
    field :address, :string
    field :gender, :string
    field :dob, :date
    field :category, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :address, :gender, :dob])
    |> validate_required([:name, :age, :address, :gender, :dob])
    |> validate_inclusion(:gender, ["male", "female"])
  end
end
