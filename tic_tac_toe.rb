# frozen_string_literal: true

# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
# require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

board_tiles = BoardTiles.new
game_host = GameHost.new
game_moderator = GameModerator.new(board_tiles, game_host)

# will be turn method
game_moderator.ask_player_to_select_tile
game_moderator.coordinate_tile_validation

game_moderator.place_player_token_on_tile

game_moderator.update_available_tiles
game_moderator.update_current_player

  # branch on val failure on above
  # will be try again method
#   game_host.display_player_choice_error_msg(game_moderator.current_player)

#   # turn method called, but for now it's three lines:
#   game_host.collect_player_tile_choice

#   # called again (not recursive, it's just here for testing)
#   game_moderator.validate_player_choice(game_host.empty_tiles_list, game_host.chosen_tile)

# # branch on success on validation: exit method/loop, then update tile?
