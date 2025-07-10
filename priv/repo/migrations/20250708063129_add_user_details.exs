defmodule MyApp.Repo.Migrations.AddUserDetails do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :address, :string
      add :gender, :string
      add :dob, :date
    end
  end
end
