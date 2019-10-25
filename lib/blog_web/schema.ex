defmodule BlogWeb.Schema do
  use Absinthe.Schema

  alias BlogWeb.Resolvers
  import_types(BlogWeb.Schema.UserType)

  @desc "Root query"
  query do
    field :user, :user do
      arg :email, non_null(:string)
      resolve &Resolvers.User.get_by_email/3
    end
  end
end
