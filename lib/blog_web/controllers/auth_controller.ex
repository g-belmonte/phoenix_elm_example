defmodule BlogWeb.AuthController do
  use BlogWeb, :controller
  alias Blog.Users.Authentication

  def login(conn, params) do
    case Authentication.authenticate(params) do
      {:ok, token} ->
        conn
        |> put_resp_cookie("token", token)
        |> json(%{"success" => "true"})

      {:error, error} ->
        conn
        |> json(%{"error" => error})
    end
  end
end
