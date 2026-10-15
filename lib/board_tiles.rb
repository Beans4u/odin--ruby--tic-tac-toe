# frozen_string_literal: true

# BoardTiles knows the tiles and updates them with the GameModerator player tokens based on player choices
class BoardTiles
  attr_reader :game_board_tiles, :empty_tile

  def initialize
    @empty_tile = ''
    @game_board_tiles = {
      tile1: @empty_tile,
      tile2: @empty_tile,
      tile3: @empty_tile,
      tile4: @empty_tile,
      tile5: @empty_tile,
      tile6: @empty_tile,
      tile7: @empty_tile,
      tile8: @empty_tile,
      tile9: @empty_tile
    }
  end
end
