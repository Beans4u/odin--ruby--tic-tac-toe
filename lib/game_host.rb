# frozen_string_literal: true

# GameHost talk to the user on behalf of the game
class GameHost
  attr_reader :present_board_tiles, :chosen_tile, :empty_tiles_list

  def initialize
    @empty_tiles_list = {
      empty_tile1: 'tile1',
      empty_tile2: 'tile2',
      empty_tile3: 'tile3',
      empty_tile4: 'tile4',
      empty_tile5: 'tile5',
      empty_tile6: 'tile6',
      empty_tile7: 'tile7',
      empty_tile8: 'tile8',
      empty_tile9: 'tile9'
    }
  end

  def display_board_tiles(game_board)
    @present_board_tiles = puts "
    + + + GAME BOARD + + + \n
    #{game_board[:tile1]}  #{game_board[:tile2]}  #{game_board[:tile3]} \n
    #{game_board[:tile4]}  #{game_board[:tile5]}  #{game_board[:tile6]} \n
    #{game_board[:tile7]}  #{game_board[:tile8]}  #{game_board[:tile9]} \n
    "
  end

  def ask_player_to_place_token
    puts "Where do you want to place your token? \n\nReview the empty tiles below and enter your choice exactly as displayed. \n
      #{@empty_tiles_list[:empty_tile1]}  #{@empty_tiles_list[:empty_tile2]}  #{@empty_tiles_list[:empty_tile3]} \n
      #{@empty_tiles_list[:empty_tile4]}  #{@empty_tiles_list[:empty_tile5]}  #{@empty_tiles_list[:empty_tile6]} \n
      #{@empty_tiles_list[:empty_tile7]}  #{@empty_tiles_list[:empty_tile8]}  #{@empty_tiles_list[:empty_tile9]} \n
    "
  end

  def collect_player_tile_choice
    @chosen_tile = gets.chomp
    @chosen_tile
  end
end
