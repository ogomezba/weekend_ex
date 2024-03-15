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

    live "/menus", MenuLive
    get "/menus/new", MenuController, :new

    live "/recipes/new", RecipesFormLive
    live "/recipes/:id/edit", RecipesFormLive

    resources "/recipes", RecipeController, except: [:new, :edit]
  end
end
