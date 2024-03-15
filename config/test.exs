import Config

config :weekend, Weekend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "menus_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :weekend, WeekendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "li0ADGyFBeQpa9akJVDbQmSPopZLsp+ULbiimVgvuST+qs/K7Ou8o11mN9dSUgEE",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
