defmodule AuthServiceWeb.UserController do
  use AuthServiceWeb, :controller
  import AuthServiceWeb.ErrorHelpers

  alias AuthService.Auth

  def index(conn, _params) do
    users = Auth.list_users()
    conn
    |> put_status(:ok)
    |> json(%{users: users})
  end

  def show(conn, %{"id" => id}) do
    case Auth.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Utilisateur introuvable"})

      user ->
        conn
        |> put_status(:ok)
        |> json(%{user: user})
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> json(%{
        message: "Utilisateur créé avec succès",
        user: user
      })
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Auth.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Utilisateur introuvable"})

      user ->
        case Auth.update_user(user, user_params) do
          {:ok, updated_user} ->
            conn
            |> put_status(:ok)
            |> json(%{
              message: "Utilisateur mis à jour avec succès",
              user: updated_user
            })

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Auth.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Utilisateur introuvable"})

      user ->
        case Auth.delete_user(user) do
          {:ok, _deleted_user} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Utilisateur supprimé avec succès"})

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Erreur lors de la suppression de l'utilisateur"})
        end
    end
  end
end
