import AuthServiceWeb.ErrorHelpers

defmodule AuthServiceWeb.AuthController do
  use AuthServiceWeb, :controller

  alias AuthService.Accounts
  alias AuthService.Accounts.User
  alias AuthService.Guardian

  def register(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> json(%{message: "Utilisateur créé avec succès", token: token, user: user})
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &AuthServiceWeb.ErrorHelpers.translate_error/1)})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> json(%{message: "Connexion réussie", token: token, user: user})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Échec de la connexion : #{reason}"})
    end
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> json(%{user: user})
  end
end
