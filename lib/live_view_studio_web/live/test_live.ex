defmodule LiveViewStudioWeb.TestLive do

  use LiveViewStudioWeb, :live_view

  def mount(params, _session, socket) do

    %{"name" => name} = params

    socket = assign(socket, [greeting: "Hello", name: name])

    {:ok, socket}
  end

  def render(assigns) do

    ~H"""
      <div><%= @greeting %> <%= @name %></div>
    """
  end

end
