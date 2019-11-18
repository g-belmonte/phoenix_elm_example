defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string

    has_many :posts, Blog.Posts.Post

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
