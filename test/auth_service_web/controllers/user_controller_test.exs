defmodule AuthServiceWeb.UserControllerTest do
  use AuthServiceWeb.ConnCase

  import AuthService.AuthFixtures

  @create_attrs %{
    name: "some name",
    password: "some_password",
    email: "some.email@example.com",
    role: "user"
  }
  @update_attrs %{
    name: "some updated name",
    password: "some_updated_password",
    email: "updated.email@example.com",
    role: "admin"
  }
  @invalid_attrs %{name: nil, password: nil, email: nil}

  describe "index" do
    test "lists all users (admin only)", %{conn: conn} do
      conn = conn |> authenticate_admin()
      conn = get(conn, "/api/users")
      assert json_response(conn, 200)["users"]
    end
  end

  describe "show user" do
    setup [:create_user]

    test "retrieves a specific user (admin only)", %{conn: conn, user: user} do
      conn = conn |> authenticate_admin()
      conn = get(conn, "/api/users/#{user.id}")
      assert %{"user" => %{"id" => ^user.id, "email" => user.email}} = json_response(conn, 200)
    end
  end

  describe "create user" do
    test "creates a user when data is valid (admin only)", %{conn: conn} do
      conn = conn |> authenticate_admin()
      conn = post(conn, "/api/users", user: @create_attrs)
      assert %{"user" => %{"id" => id}} = json_response(conn, 201)

      conn = get(conn, "/api/users/#{id}")
      assert %{"user" => %{"id" => ^id, "name" => "some name"}} = json_response(conn, 200)
    end

    test "returns errors when data is invalid", %{conn: conn} do
      conn = conn |> authenticate_admin()
      conn = post(conn, "/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "update user" do
    setup [:create_user]

    test "updates user when data is valid (admin only)", %{conn: conn, user: user} do
      conn = conn |> authenticate_admin()
      conn = put(conn, "/api/users/#{user.id}", user: @update_attrs)
      assert %{"user" => %{"id" => ^user.id, "name" => "some updated name"}} = json_response(conn, 200)

      conn = get(conn, "/api/users/#{user.id}")
      assert %{"user" => %{"id" => ^user.id, "name" => "some updated name"}} = json_response(conn, 200)
    end

    test "returns errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> authenticate_admin()
      conn = put(conn, "/api/users/#{user.id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"]
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user (admin only)", %{conn: conn, user: user} do
      conn = conn |> authenticate_admin()
      conn = delete(conn, "/api/users/#{user.id}")
      assert json_response(conn, 200)["message"] == "User deleted successfully"

      conn = get(conn, "/api/users/#{user.id}")
      assert json_response(conn, 404)["error"]
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp authenticate_admin(conn) do
    admin = admin_fixture() # Suppose que vous avez une fixture pour un utilisateur admin
    {:ok, token, _} = AuthService.Guardian.encode_and_sign(admin)
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
