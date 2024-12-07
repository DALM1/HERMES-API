defmodule AuthServiceWeb.PostController do
  use AuthServiceWeb, :controller

  alias AuthService.Posts
  alias AuthService.Posts.Post
  alias Guardian.Plug

  action_fallback AuthServiceWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    json(conn, %{posts: posts})
  end

  def create(conn, %{"post" => post_params}) do
    current_user = Plug.current_resource(conn)

    IO.inspect(current_user, label: "Utilisateur courant") # Debug pour vérifier l'utilisateur

    if current_user do
      post_params = Map.put(post_params, "user_id", current_user.id)

      with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
        conn
        |> put_status(:created)
        |> json(%{post: post})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Non autorisé. Aucun utilisateur connecté."})
    end
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id_int, ""} ->
        case Posts.get_post(id_int) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Post introuvable."})

          post ->
            json(conn, %{post: post})
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "ID invalide."})
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    case Integer.parse(id) do
      {id_int, ""} ->
        case Posts.get_post(id_int) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Post introuvable."})

          post ->
            with {:ok, %Post{} = updated_post} <- Posts.update_post(post, post_params) do
              json(conn, %{post: updated_post})
            end
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "ID invalide."})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id_int, ""} ->
        case Posts.get_post(id_int) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Post introuvable."})

          post ->
            with {:ok, %Post{}} <- Posts.delete_post(post) do
              send_resp(conn, :no_content, "")
            end
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "ID invalide."})
    end
  end
end
