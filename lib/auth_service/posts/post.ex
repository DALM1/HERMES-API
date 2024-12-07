defmodule AuthService.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  La structure représentant un Post avec ses champs et validations.
  """

  schema "posts" do
    field :title, :string
    field :content, :string
    field :tags, {:array, :string}
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc """
  Génère un changeset pour les posts.
  """
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :tags, :user_id])
    |> validate_required([:title, :content, :user_id])
  end
end
