defmodule BlogWeb.Resolvers.Users do
  alias Blog.Users.User
  alias Blog.Repo

  def get_by_email(_, %{email: email}, _) do
    case Repo.get_by(User, email: email) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
