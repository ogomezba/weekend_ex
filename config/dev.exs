import Config

config :weekend, Weekend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "menus_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :weekend, WeekendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "1pCUWM0qqn00mbdFPOHvIZqzeAHjL5ORUb2BfsEflpfFsl1UaLjPcdLNNpcucBNe",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:weekend, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:weekend, ~w(--watch)]}
  ]

config :weekend, WeekendWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/weekend_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :weekend, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view, :debug_heex_annotations, true
