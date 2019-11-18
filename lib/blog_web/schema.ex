defmodule BlogWeb.Schema do
  use Absinthe.Schema

  alias BlogWeb.Resolvers
  import_types(BlogWeb.Schema.UserType)

  @desc "Root query"
  query do
    @desc "Query a user by its username"
    field :user, :user do
      arg(:username, non_null(:string))
      resolve(&Resolvers.Users.get_by_username/2)
    end
  end

  @desc "Root mutation"
  mutation do
    @desc "Create a user"
    field :create_user, :user do
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Users.create/2)
    end

    @desc "Delete a user"
    field :delete_user, :user do
      arg(:username, non_null(:string))
      # TODO Add authorization middleware
      resolve(&Resolvers.Users.delete/2)
    end
  end

  def middleware(middleware, _field, _object) do
    middleware ++ [BlogWeb.Middlewares.HandleChangesetErrors]
  end
end
