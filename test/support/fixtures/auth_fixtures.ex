defmodule AuthService.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuthService.Auth` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        password: "some password"
      })
      |> AuthService.Auth.create_user()

    user
  end
end
