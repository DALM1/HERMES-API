# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :auth_service,
  ecto_repos: [AuthService.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the Phoenix endpoint
config :auth_service, AuthServiceWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AuthServiceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AuthService.PubSub,
  live_view: [signing_salt: "gl7/9oT1"]

# Configures the mailer
# By default, it uses the "Local" adapter, which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production, it's recommended to configure a different adapter
# in `config/runtime.exs`.
config :auth_service, AuthService.Mailer, adapter: Swoosh.Adapters.Local

# Database configuration (Ecto + PostgreSQL)
config :auth_service, AuthService.Repo,
  database: System.get_env("POSTGRES_DB") || "auth_service_dev",
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool_size: 10

# Guardian configuration for JWT management
config :auth_service, AuthService.Guardian,
  issuer: "auth_service",
  secret_key: System.get_env("GUARDIAN_SECRET") || "super_secret_key"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Kafka configuration for event streaming
config :auth_service, :broadway_kafka,
  endpoints: [{"localhost", 9092}],
  topics: ["auth_events"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# CORS configuration
config :cors_plug,
  origin: ["http://localhost:3000"], # React or other frontend
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

# Import environment-specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
