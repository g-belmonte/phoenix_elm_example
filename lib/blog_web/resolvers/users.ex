defmodule BlogWeb.Resolvers.Users do
  alias Blog.Users.User
  alias Blog.Repo

  # ===============================================================================
  #                                   Queries
  # ===============================================================================
  def get_by_username(_, %{username: username}, _) do
    User
    |> Repo.get_by(username: username)
    |> case do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  # ===============================================================================
  #                                  Mutations
  # ===============================================================================
  def create(_, args, _) do
    %User{}
    |> User.changeset(args)
    |> Repo.insert()
  end

  def delete(_, %{username: username}, _) do
    User
    |> Repo.get_by(username: username)
    |> case do
      nil -> {:error, "User not found"}
      user -> Repo.delete(user)
    end
  end
end
