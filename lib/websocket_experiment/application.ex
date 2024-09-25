defmodule WebsocketExperiment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WebsocketExperimentWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:websocket_experiment, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WebsocketExperiment.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WebsocketExperiment.Finch},
      # Start a worker by calling: WebsocketExperiment.Worker.start_link(arg)
      # {WebsocketExperiment.Worker, arg},
      # Start to serve requests, typically the last entry
      WebsocketExperimentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebsocketExperiment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebsocketExperimentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
