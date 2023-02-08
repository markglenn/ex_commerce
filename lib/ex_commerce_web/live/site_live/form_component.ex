defmodule ExCommerceWeb.SiteLive.FormComponent do
  use ExCommerceWeb, :live_component

  alias ExCommerce.Hosting

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage site records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="site-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :subdomain}} type="text" label="Subdomain" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Site</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{site: site} = assigns, socket) do
    changeset = Hosting.change_site(site)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"site" => site_params}, socket) do
    changeset =
      socket.assigns.site
      |> Hosting.change_site(site_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"site" => site_params}, socket) do
    save_site(socket, socket.assigns.action, site_params)
  end

  defp save_site(socket, :edit, site_params) do
    case Hosting.update_site(socket.assigns.site, site_params) do
      {:ok, _site} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_site(socket, :new, site_params) do
    case Hosting.create_site(site_params) do
      {:ok, _site} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end