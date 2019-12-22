defmodule Blog.Users do
  alias Blog.Users.User
  alias Blog.Repo

  def get(%{username: username}) do
    case Repo.get_by(User, username: username) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def create(args) do
    changeset = User.changeset(%User{}, args)

    if changeset.valid? do
      Repo.insert(changeset)
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
