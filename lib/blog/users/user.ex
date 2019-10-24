defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime_usec)
  end

  @fields [:username, :password_hash]
  @doc false
  def changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

end
