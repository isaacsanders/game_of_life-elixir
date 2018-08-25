use Mix.Config

config :game_of_life, GameOfLifeWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "stormy-sierra-51644.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :logger, level: :info
