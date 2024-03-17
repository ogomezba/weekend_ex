defmodule WeekendWeb.HomeController do
  use WeekendWeb, :controller

  def home(conn, _params) do
    conn |> put_layout(false) |> render(:home)
  end
end
