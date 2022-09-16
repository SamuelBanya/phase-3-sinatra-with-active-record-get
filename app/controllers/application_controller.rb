class ApplicationController < Sinatra::Base
  # Add this line to set the 'Content-Type' header for all responses:
  set :default_content_type, "application/json"

  get '/' do
    { message: "Hello world" }.to_json
  end

  get "/games" do
    # NOTE: This was commented out since they ended up using the 
    # 10 game limit for this API endpoint anyway:
    # Get all the games from the database
    # games = Game.all()
    games = Game.all.order(:title).limit(10)
    # Return a JSON response with an array of all the game data
    games.to_json()
  end

  # Example of using a 'Dynamic Route' so that the controller can handle
  # 'params' hash that contain values:
  # Use the ':id' syntax to create a dynamic route:

  # NOTE: Using a 'GET' request with '/games/10' would make the 'params' hash look
  # like the following:
  # { "id" => "10" }
  get "/games/:id" do 
    # Look up the game in the database using its ID
    game = Game.find(params[:id])
    # Send a JSON-formatted response of the game data
    # NOTE: Commented out as we later used a deeper nested relationship:
    # game.to_json(include: :reviews)
    # NOTE: Commented out as we were even MORE selective with the 'only' parameter:
    # game.to_json(include: { reviews: { include: :user } })
    # Using the 'only' parameter to be more selective:
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      }}
    })
  end

  # NOTE: The following two sections were provided as examples in the lab itself
  # so I included them as related API endpoints anyway:
  # Example pattern to sort by title:
  get "/games_sorted_by_title" do
    games = Game.all.order(:title)
    games.to_json()
  end

  # Example pattern to get the first 10 games
  get "/games_first_10" do 
    games = Game.all.order(:title).limit(10)
    games.to_json()
  end

end
