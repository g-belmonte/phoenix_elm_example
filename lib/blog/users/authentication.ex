defmodule Blog.Users.Authentication do
  alias Blog.Users
  alias Ecto.UUID

  def authenticate(%{"username" => username, "password" => password}) do
    case Users.get(%{username: username}) do
      {:error, reason} ->
        {:error, reason}

      {:ok, user} ->
        if user.password_hash == Base.encode16(:crypto.hash(:sha256, password)) do
          {:ok, conn} = Redix.start_link()

          case Redix.command(conn, ["GET", "#{username}"]) do
            {:ok, token} ->
              Redix.stop(conn)
              {:ok, token}

            _ ->
              token = UUID.generate()

              case Redix.command(conn, ["SET", "#{username}", "#{token}"]) do
                {:ok, "OK"} ->
                  Redix.stop(conn)
                  {:ok, token}

                {:error, reason} ->
                  Redix.stop(conn)
                  {:error, reason}
              end
          end
        else
          {:error, "Password does not match"}
        end
    end
  end

  def authenticate(_), do: {:error, "Incorrect params"}

  def validate_token(%{username: username, token: token}) do
    {:ok, conn} = Redix.start_link()

    case Redix.command(conn, ["GET", "#{username}"]) do
      {:ok, tk} ->
        if tk == token do
          Redix.stop(conn)
          {:ok, token}
        else
          Redix.stop(conn)
          {:error, "Invalid token"}
        end

      _ ->
        Redix.stop(conn)
        {:error, "User has no tokens"}
    end
  end
end
