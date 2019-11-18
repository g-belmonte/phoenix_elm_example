defmodule BlogWeb.Resolvers.Users do
  alias Blog.Users

  # ===============================================================================
  #                                   Queries
  # ===============================================================================
  def get_by_username(username, _) do
    Users.get(username)
  end

  # ===============================================================================
  #                                  Mutations
  # ===============================================================================
  def create(args, _) do
    Users.create(args)
  end

  def delete(args, _) do
    Users.delete(args)
  end
end
