defmodule Entrance.Auth.Secret do
  @moduledoc """
  Provides functions for creating secure random strings to be used as session secret.

  This module assumes that you have a field `session_secret` in your db table.

  ## Usage

  ## Example

  ```
  defmodule YourAppWeb.UserController do
    use YourAppWeb, :controller
    alias YourApp.Repo

    alias Entrance.Auth.Secret
    alias YourApp.Accounts.User

    def create(conn, %{"user" => user_params}) do
      changeset =
        %User{}
        |> User.create_changeset(user_params)
        |> Secret.put_session_secret()

      case Repo.insert(changeset) do
        {:ok, _user} ->
          conn |> redirect(to: "/")
        {:error, changeset} ->
          conn |> render("new.html", changeset: changeset)
      end
    end
  end
  ```

  Setting the session key for an user is only needed on creation or if a user session did get compromised.
  """
  alias Ecto.Changeset

  @doc """
  Takes a changeset and adds a secure random string in the `session_secret` field.

  ```
  %User{}
  |> User.create_changeset(user_params)
  |> Secret.put_session_secret()
  ```
  """
  def put_session_secret(changeset, length \\ 64),
    do: Changeset.put_change(changeset, :session_secret, random_string(length))

  # Generate a secure random string
  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
