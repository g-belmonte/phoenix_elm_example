defmodule BlogWeb.ElmController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, "app.html")
  end
end
