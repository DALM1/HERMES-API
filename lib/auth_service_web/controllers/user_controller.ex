import AuthServiceWeb.ErrorHelpers

defmodule AuthServiceWeb.UserController do
  use AuthServiceWeb, :controller

  alias AuthService.Auth
  alias AuthService.Auth.User

  def index(conn, _params) do
    users = Auth.list_users()
    json(conn, %{users: users})
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    json(conn, %{user: user})
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully", user: user})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    {:ok, _user} = Auth.delete_user(user)

    conn
    |> put_status(:ok)
    |> json(%{message: "User deleted successfully"})
  end
end
