# frozen_string_literal: true

# BoardTiles knows the tiles and updates them with the GameModerator player tokens based on player choices
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
    @tile1_option = 'tile1'
    @tile2_option = 'tile2'
    @tile3_option = 'tile3'
    @tile4_option = 'tile4'
    @tile5_option = 'tile5'
    @tile6_option = 'tile6'
    @tile7_option = 'tile7'
    @tile8_option = 'tile8'
    @tile9_option = 'tile9'

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
  def update_tile(host, game_moderator)
    @tiles_grid[host.player_choice] = game_moderator.current_player_token
  end

  # GameHost object will send the user's tile choice here, but is it valid?
  def validate_tile_chosen(host)
    # CHECK: will this spread allow any value from the array?
    # below is a true/false bool that RuboCop asked me to change,
    # TODO: use true/false val as message in method that will require
    # it when I build it out later.
    host.player_choice == @tile_options[0..8]
  end

  # After @tile_grid tile is updated with player's token
  # the tile options will update to remove that tile as an option
  # CHECK: no idea if this method will work
  def update_tile_options(host)
    tile_options.splice!(host.player_choice, 1)
  end
end
