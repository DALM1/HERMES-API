defmodule AuthServiceWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :auth_service

  @session_options [
    store: :cookie,
    key: "_auth_service_key",
    signing_salt: "HgUhG+rz",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :auth_service,
    gzip: false,
    only: AuthServiceWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :auth_service
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug AuthServiceWeb.Router
end
