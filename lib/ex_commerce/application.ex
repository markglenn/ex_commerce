defmodule ExCommerce.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExCommerceWeb.Telemetry,
      # Start the Ecto repository
      ExCommerce.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExCommerce.PubSub},
      # Start Finch
      {Finch, name: ExCommerce.Finch},
      # Start the Endpoint (http/https)
      ExCommerceWeb.Endpoint,
      # Start caching server
      {Cachex, name: :ex_commerce_cache}
      # Start a worker by calling: ExCommerce.Worker.start_link(arg)
      # {ExCommerce.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExCommerce.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExCommerceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
