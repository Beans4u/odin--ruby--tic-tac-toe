# frozen_string_literal: true

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

  def present_available_tiles(board_tiles, game_moderator)
    puts "
    - - #{game_moderator.current_player} turn - - \n
    Which tile will you place your player token on?: \n
      #{board_tiles.tile_options[0]}  #{board_tiles.tile_options[1]}  #{board_tiles.tile_options[2]} \n
      #{board_tiles.tile_options[3]}  #{board_tiles.tile_options[4]}  #{board_tiles.tile_options[5]} \n
      #{board_tiles.tile_options[6]}  #{board_tiles.tile_options[7]}  #{board_tiles.tile_options[8]} \n
    "
  end

  def collect_player_choice
    @player_choice = gets.chomp
    @player_choice
  end

  def display_tile_validation_error
    puts "#{current_player}, you entered #{@player_choice}, which is invalid. \n
    Please review the tile options and enter the tile exactly as presented."
  end

  # forbid more than one GameHost object from existing in a single game
  def limit_one_game_host_object
    p 'this is not developed yet'
  end
end
