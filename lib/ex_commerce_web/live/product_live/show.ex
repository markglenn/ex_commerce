defmodule ExCommerceWeb.ProductLive.Show do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Catalog
  alias ExCommerce.Hosting

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])
    {:ok, assign(socket, :site, site)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Catalog.get_product!(socket.assigns.site, id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
