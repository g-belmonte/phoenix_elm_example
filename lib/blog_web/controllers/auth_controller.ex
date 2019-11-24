defmodule BlogWeb.AuthController do
  use BlogWeb, :controller
  alias Blog.Users.Authentication

  def login(conn, params) do
    case Authentication.authenticate(params) do
      {:ok, token, username} ->
        conn
        |> put_resp_cookie("token", token)
        |> json(%{"username" => username})

      {:error, error} ->
        conn
        |> json(%{"error" => error})
    end
  end
end
