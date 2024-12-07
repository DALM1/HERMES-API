defmodule AuthServiceWeb.Router do
  use AuthServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/auth", AuthServiceWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
    get "/profile", AuthController, :profile
  end

  scope "/users", AuthServiceWeb do
    pipe_through :api

    get "/", UserController, :index
    get "/:id", UserController, :show
    post "/", UserController, :create
    put "/:id", UserController, :update
    delete "/:id", UserController, :delete
  end
end
