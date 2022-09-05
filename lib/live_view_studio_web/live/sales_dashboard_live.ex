defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do

    # Check if we are connected, to avoid doing stuff before the process has spawned (since mount is called
    # the first time when the static page is sent, and then a second time once the socket has been opened
    # and the process spawned)
    if connected?(socket) do
      # set up an interval every 1s to send a "tick" event to the current PID (self)
      # these messages are handled in the handle_info() callback
      :timer.send_interval(1000, self(), :tick)
    end

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>
      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _event, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    socket = assign(socket, new_orders: Sales.new_orders(), sales_amount: Sales.sales_amount(), satisfaction: Sales.satisfaction())
    socket
  end

  # handle internal messages
  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

end
