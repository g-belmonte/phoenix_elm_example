defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string

    # Virtual fields
    field :password, :string, virtual: true

    # Associations
    has_many :posts, Blog.Posts.Post

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 8, message: "Password must be at least 8 characters long")
    |> unique_constraint(:username, message: "This username has already been taken")
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Base.encode16(:crypto.hash(:sha256, pass)))

      _ ->
        changeset
    end
  end
end
