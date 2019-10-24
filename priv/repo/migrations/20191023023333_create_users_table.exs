defmodule Blog.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table("users", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: utc_datetime_usec)
    end

    create index(:users, [:username])
  end
end
