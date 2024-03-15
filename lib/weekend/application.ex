defmodule Weekend.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Weekend.Repo,
      {DNSCluster, query: Application.get_env(:weekend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Weekend.PubSub},
      WeekendWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Weekend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    WeekendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
