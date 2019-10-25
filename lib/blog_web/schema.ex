defmodule BlogWeb.Schema do
  use Absinthe.Schema

  alias BlogWeb.Resolvers
  import_types(BlogWeb.Schema.UserType)

  @desc "Root query"
  query do
    @desc "Query a user by its username"
    field :user, :user do
      arg :username, non_null(:string)
      resolve &Resolvers.Users.get_by_username/3
    end
  end

  @desc "Root mutation"
  mutation do
    field :create_user, :user do
      arg :username, non_null(:string)
      arg :password_hash, non_null(:string)
      resolve &Resolvers.Users.create/3
    end
  end

end
