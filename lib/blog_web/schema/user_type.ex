defmodule BlogWeb.Schema.UserType do
  use Absinthe.Schema.Notation

  @desc "Blog user"
  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :username, non_null(:string)
  end
end
