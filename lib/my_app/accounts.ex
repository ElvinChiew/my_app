defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def user_gender(%User{} = user) do
    case user.gender do
      "male" -> "male"
      "female" -> "female"
      _ -> "unknown"
    end
  end

  def user_age(%User{} = user) do
    case user.age do
      age when age < 18 -> "minor"
      age when age >= 18 and age <= 65 -> "adult"
      _ -> "senior"
    end
  end

  def ic_info(string) do
    {_, rest} = String.split_at(string, 6)

    {a, b} = String.split_at(rest, 2)

    # Determine if user is Sabahan
    state =
      case a do
        "12" -> "sabahan"
        _ -> "bukan sabahan"
      end

    # Determine gender based on b
    gender =
      case Integer.parse(b) do
        {num, ""} when rem(num, 2) == 0 -> "perempuan"
        {num, ""} -> "lelaki"
        _ -> "invalid input"
      end

    %{state: state, gender: gender}
  end

  # Optional fallback for bad input
  def ic_info(_), do: %{error: "invalid input"}
end
