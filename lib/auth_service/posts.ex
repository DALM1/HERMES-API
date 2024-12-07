defmodule AuthService.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias AuthService.Repo
  alias AuthService.Posts.Post

  @doc """
  Retourne tous les posts.
  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Récupère un post par son ID ou renvoie `nil` s'il n'existe pas.
  """
  def get_post(id) do
    Repo.get(Post, id)
  end

  @doc """
  Récupère un post par son ID ou lève une erreur si le post n'existe pas.
  """
  def get_post!(id) do
    Repo.get!(Post, id)
  end

  @doc """
  Crée un post.
  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Met à jour un post existant.
  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Supprime un post existant.
  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Renvoie un `%Ecto.Changeset{}` pour suivre les modifications d'un post.
  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
