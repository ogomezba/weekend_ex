defmodule WeekendWeb.Router do
  use WeekendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WeekendWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeekendWeb do
    pipe_through :browser

    get "/", HomeController, :home

    live "/menus", MenuLive
    get "/menus/new", MenuController, :new

    live "/recipes/new", RecipesNewLive
    live "/recipes/:id/edit", RecipesEditLive

    resources "/recipes", RecipeController, except: [:new, :edit, :create, :update]
  end

  if Application.compile_env(:weekend, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard"
    end
  end
end
