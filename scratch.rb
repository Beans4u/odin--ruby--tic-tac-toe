# frozen_string_literal: true

# GameBoard knows the tiles, player tokens, turn state, win/stalemate logic, and validates user responses
class GameBoard
  attr_accessor :tiles
  attr_reader :player1_token, :player2_token, :empty_tile
  
  def initialize # I have no idea if I'm doing this right
    @player1_token = 'x'
    @player2_token = 'o'
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
  end

  def tiles
    @tiles = [
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
  end

end

# GameHost talk to the user on behalf of the game
class GameHost
  
  def display_game_board(board)
    puts "
      Game Board:
      #{board.tiles[0]}  #{board.tiles[1]}  #{board.tiles[2]} \n
      #{board.tiles[3]}  #{board.tiles[4]}  #{board.tiles[5]} \n
      #{board.tiles[6]}  #{board.tiles[7]}  #{board.tiles[8]} \n
    "
  end
end

game_board = GameBoard.new
game_host = GameHost.new

game_host.display_game_board(game_board)