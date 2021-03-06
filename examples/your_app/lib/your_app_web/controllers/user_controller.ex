defmodule YourAppWeb.UserController do
  use YourAppWeb, :controller

  def new(conn, _params) do
    conn |> render("new.html", changeset: Entrance.User.create_changeset())
  end

  def create(conn, %{"user" => user_params}) do
    case Entrance.User.create(user_params) do
      {:ok, _user} ->
        conn |> redirect(to: "/")

      {:error, changeset} ->
        conn |> render("new.html", changeset: changeset)
    end
  end
end
