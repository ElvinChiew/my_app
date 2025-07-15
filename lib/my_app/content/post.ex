defmodule MyApp.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyApp.Accounts.User

  schema "post" do
    field :title, :string
    field :body, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user_id, :title, :body])
    |> validate_required([:user_id, :title, :body])
  end
end
