defmodule YourAppWeb.Plugs.RequireLogin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Entrance.logged_in?(conn) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/session/new")
      |> halt
    end
  end
end
