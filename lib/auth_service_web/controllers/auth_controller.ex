defmodule AuthServiceWeb.AuthController do
  use AuthServiceWeb, :controller
  import AuthServiceWeb.ErrorHelpers

  alias AuthService.Accounts
  alias AuthService.Guardian

  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      IO.inspect(user.role, label: "User role") # Debug : rôle de l'utilisateur

      conn
      |> put_status(:created)
      |> json(%{
        message: "⚡️ Utilisateur créé avec succès ⚡️",
        token: token,
        user: %{
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          inserted_at: user.inserted_at,
          updated_at: user.updated_at
        }
      })
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> json(%{
          message: "⚡️ HERMES CONNECTION ESTABLISED. ⚡️",
          token: token,
          user: %{
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            inserted_at: user.inserted_at,
            updated_at: user.updated_at
          }
        })

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "⚠️ Échec de la connexion : #{reason}"})
    end
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    if user do
      conn
      |> put_status(:ok)
      |> json(%{
        user: %{
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          inserted_at: user.inserted_at,
          updated_at: user.updated_at
        }
      })
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "⚠️ Non autorisé. Aucun utilisateur connecté."})
    end
  end
end
