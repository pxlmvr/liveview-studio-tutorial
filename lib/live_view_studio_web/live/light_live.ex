defmodule LiveViewStudioWeb.LightLive do

  # Pull in all the stuff needed to create a live view
  use LiveViewStudioWeb, :live_view

  # this callback is automatically called when the router request for this view comes in
  # params contains query and router parameters
  # session contains private session data
  def mount(_params, _session, socket) do
    #assign the initial state of the live view to the socket. The assign() function returns a socket
    # eg. we set the initial brightness to 10
    # (if we want to assign multiple args we use a key-value map)
    socket = assign(socket, :brightness, 10)

    # mount() must return a tuple with :ok and the socket
    {:ok, socket}
  end

  # this callback is mandatory as it defines what the view should render (in terms of static HTML)
  # assigns is the assigns map of the socket struct as set in mount(). It contains the state.
  def render(assigns) do
    # the sigil H is used to define template code
    ~H"""
      <h1>Light</h1>
      <div id="light">
        <div class="meter">
          <span style={"width: #{@brightness}%"}>
            <%= @brightness %>%
          </span>
        </div>

        <!-- phx-click is the binding to specify the name of the event to be handled. When it's clicked, an "off"
              event is sent via the socket to the process
        -->
        <button phx-click="off">
          <img src="images/light-off.svg" />
        </button>

        <button phx-click="down">
          <img src="images/down.svg" />
        </button>

        <button phx-click="up">
          <img src="images/up.svg" />
        </button>

        <button phx-click="on">
          <img src="images/light-on.svg" />
        </button>

        <section style="margin-top:24px">

          <button phx-click="random">
            Random
          </button>

        </section>

      </div>
    """
  end

  # callback to handle events (event_name, metadata, socket)
  def handle_event("on", _, socket) do
    #use the assign method to set the new state
    #when the state is changed, the render method is called again but it only sends to the client
    #the part of the view that actually changed, not the whole thing
    socket = assign(socket, :brightness, 100)

    # should return noreply and the socket
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)

    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    # the update() callback is used to update the state, it uses a callback to set the new value
    socket = update(socket, :brightness, fn(brightness) -> brightness + 10 end)

    {:noreply, socket}
  end

  def handle_event("down", _, socket) do

    # using the weird ass syntax where &1 is the first parameter (ᴗ_ ᴗ。)
    socket = update(socket, :brightness, &(&1 - 10))

    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    random_value = :rand.uniform(100)

    socket = update(socket, :brightness, fn(_brightness) -> random_value end)

    {:noreply, socket}
  end

end
