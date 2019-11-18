defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :contents, :string

    belongs_to :user, Blog.Users.User

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:title, :contents])
    |> validate_required([:title, :contents])
    |> unique_constraint(:title, message: "This title has already been taken")
  end
end
