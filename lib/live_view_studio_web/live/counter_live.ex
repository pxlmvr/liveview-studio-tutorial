defmodule LiveViewStudioWeb.CounterLive do

  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <main>

        <section>
          <div style="display:flex;justify-content:space-between;align-items:center;">
          <button phx-click="decrease" style="padding:28px;background:white">
            -
          </button>
            <h1>
            <%= @count %>
          </h1>
            <button phx-click="increase" style="padding:28px;background:white">
            +
          </button>
          </div>
        </section>
      </main>
    """
  end

  def handle_event("decrease", _, socket) do
    socket = update(socket, :count, fn(c) -> c - 1 end)
    {:noreply, socket}
  end

  def handle_event("increase", _, socket) do
    socket = update(socket, :count, fn(c) -> c + 1 end)
    {:noreply, socket}
  end

end
