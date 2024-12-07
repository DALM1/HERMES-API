defmodule AuthService.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuthService.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        tags: ["option1", "option2"],
        title: "some title"
      })
      |> AuthService.Posts.create_post()

    post
  end
end
