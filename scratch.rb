# frozen_string_literal: true

# GameBoard knows the players, player tokens, turn state, win/stalemate logic
# and validates user responses
class Game
  attr_reader :player1_token, :player2_token, :current_player
  
  def initialize
    @player1_token = 'x'
    @player2_token = 'o'
    @PLAYER1 = 'Player 1'
    @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1 # default for new games
  end

  # GameHost object will ask the player whose turn it is based on this flag
  def update_player_turn
    @current_player == @PLAYER1 ? @current_player = @PLAYER2 : @current_player = @PLAYER1
    @current_player
  end

  # Checks if a winning condition has been met
  def check_winning_conditions
    p 'this is not developed yet'
  end
  # Checks if a stalemate condition has been met
  def check_stalemate_conditions
    p 'this is not developed yet'
  end

  # forbid more than one GameBoard object from existing in a single game
  def limit_one_GameBoard_object
    p 'this is not developed yet'
  end
end

# BoardTiles knows the tiles and updates them with the GameBoard player tokens based on player choices
class BoardTiles
  attr_reader :empty_tile, :tile_grid, :tile_options

  def initialize
    @empty_tile = ' '
    @tile1 = @empty_tile
    @tile2 = @empty_tile
    @tile3 = @empty_tile
    @tile4 = @empty_tile
    @tile5 = @empty_tile
    @tile6 = @empty_tile
    @tile7 = @empty_tile
    @tile8 = @empty_tile
    @tile9 = @empty_tile

    # @tile_grid will be displayed to user at beginning of each round
    @tile_grid = [
      @tile1,
      @tile2,
      @tile3,
      @tile4,
      @tile5,
      @tile6,
      @tile7,
      @tile8,
      @tile9
    ]

    # tile options to be removed from array after BoardTiles
    # updates with player's selection
    @tile1_option = "tile1"
    @tile2_option = "tile2"
    @tile3_option = "tile3"
    @tile4_option = "tile4"
    @tile5_option = "tile5"
    @tile6_option = "tile6"
    @tile7_option = "tile7"
    @tile8_option = "tile8"
    @tile9_option = "tile9"

    @tile_options = [
      @tile1_option,
      @tile2_option,
      @tile3_option,
      @tile4_option,
      @tile5_option,
      @tile6_option,
      @tile7_option,
      @tile8_option,
      @tile9_option
    ]
  end

  # on tile selection, updates the game board tiles 
  # with current player's player token
  # CHECK: untested way to access array index, current player not made yet
  def update_tile(host, game_board)
    @tiles_grid[host.player_choice] = game_board.current_player_token
  end

  # GameHost object will send the user's tile choice here, but is it valid?
  def validate_tile_chosen(host)
    # CHECK: will this spread allow any value from the array?
    host.player_choice == @tile_options[0..8] ? true : false
  end

  # After @tile_grid tile is updated with player's token
  # the tile options will update to remove that tile as an option
  # CHECK: no idea if this method will work
  def update_tile_options(host)
    tile_options.splice!(host.player_choice, 1)
  end


end

# GameHost talk to the user on behalf of the game
class GameHost
  attr_reader :player_choice

  def initialize
    @player_choice = ''
  end
  
  def display_board_tiles(board_tiles)
    puts "
      Game Board:
      #{board_tiles.tile_grid[0]}  #{board_tiles.tile_grid[1]}  #{board_tiles.tile_grid[2]} \n
      #{board_tiles.tile_grid[3]}  #{board_tiles.tile_grid[4]}  #{board_tiles.tile_grid[5]} \n
      #{board_tiles.tile_grid[6]}  #{board_tiles.tile_grid[7]}  #{board_tiles.tile_grid[8]} \n
    "
  end

  def present_available_tiles(board_tiles, game_board)
    puts "
    - - #{game_board.current_player} turn - - \n
    Which tile will you place your player token on?: \n
      #{board_tiles.tile_options[0]}  #{board_tiles.tile_options[1]}  #{board_tiles.tile_options[2]} \n
      #{board_tiles.tile_options[3]}  #{board_tiles.tile_options[4]}  #{board_tiles.tile_options[5]} \n
      #{board_tiles.tile_options[6]}  #{board_tiles.tile_options[7]}  #{board_tiles.tile_options[8]} \n
    "
  end

  def get_player_choice
    @player_choice = gets.chomp
    @player_choice
  end

  def display_tile_validation_error
    puts "#{current_player}, you entered #{@player_choice}, which is invalid. \n
    Please review the tile options and enter the tile exactly as presented."
  end

  # forbid more than one GameHost object from existing in a single game
  def limit_one_GameHost_object
    p 'this is not developed yet'
  end
end

class RunGame
  attr_reader :game_board, :board_tiles, :game_host

  def initialize
    @game_board = Game.new
    @board_tiles = BoardTiles.new
    @game_host = GameHost.new  
  end
  
  # todo: create PROMPT PLAYER loop from DEV_LOG.md
  def play_game
    @game_host.display_board_tiles(@board_tiles)
    @game_host.present_available_tiles(@board_tiles, @game_board)
  end

end

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +
run_game = RunGame.new
run_game.play_game