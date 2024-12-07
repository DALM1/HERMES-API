defmodule AuthServiceWeb.Router do
  use AuthServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline,
      module: AuthService.Guardian,
      error_handler: AuthServiceWeb.ErrorHandler
  end

  pipeline :admin do
    plug :ensure_admin
  end

  defp ensure_admin(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user && current_user.role == "admin" do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Accès interdit. Vous devez être administrateur pour accéder à cette ressource."})
      |> halt()
    end
  end

  scope "/api/auth", AuthServiceWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
    get "/profile", AuthController, :profile
  end

  scope "/api/users", AuthServiceWeb do
    pipe_through [:api, :admin]

    get "/", UserController, :index
    get "/:id", UserController, :show
    post "/", UserController, :create
    put "/:id", UserController, :update
    delete "/:id", UserController, :delete
  end

  scope "/api/posts", AuthServiceWeb do
    pipe_through :api

    get "/", PostController, :index
    post "/", PostController, :create
    get "/:id", PostController, :show
    put "/:id", PostController, :update
    delete "/:id", PostController, :delete
  end
end
