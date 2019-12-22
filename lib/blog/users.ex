defmodule Blog.Users do
  alias Blog.Users.User
  alias Blog.Repo

  def get(%{username: username}) do
    user =
      User
      |> Repo.get_by(username: username)

    case user do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def get(_), do: {:error, "Cannot fetch user with these parameters"}

  def create(args) do
    changeset = User.changeset(%User{}, args)

    if changeset.valid? do
      changeset
      |> Repo.insert()
    else
      {:error, changeset}
    end
  end

  def delete(args) do
    case get(args) do
      {:error, error} -> {:error, error}
      {:ok, user} -> Repo.delete(user)
    end
  end
end
