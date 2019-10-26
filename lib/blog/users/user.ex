defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
    |> unique_constraint(:username, message: "This username has already been taken")
  end
end
