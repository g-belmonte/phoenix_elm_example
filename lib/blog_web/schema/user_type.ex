defmodule BlogWeb.Schema.UserType do
  use Absinthe.Schema.Notation

  @desc "Blog user"
  object :user do
    field :username, non_null(:string)
  end
end
