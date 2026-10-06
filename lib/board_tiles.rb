# frozen_string_literal: true

# BoardTiles knows the tiles and updates them with the GameModerator player tokens based on player choices
class BoardTiles
  attr_reader :game_board_tiles

  def initialize
    @game_board_tiles = {
      tile1: ' ',
      tile2: ' ',
      tile3: ' ',
      tile4: ' ',
      tile5: ' ',
      tile6: ' ',
      tile7: ' ',
      tile8: ' ',
      tile9: ' '
    }
  end
end
