defmodule AuthServiceWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = %{error: "⚠️ Authentification échouée : #{type}"}
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, Jason.encode!(body))
  end
end
