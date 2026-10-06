# frozen_string_literal: true

# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

board_tiles = BoardTiles.new
game_host = GameHost.new
game_moderator = GameModerator.new
game_host.display_board_tiles(board_tiles.game_board_tiles)
game_host.ask_player_to_place_token
game_host.collect_player_tile_choice
game_moderator.validate_player_choice(game_host.empty_tiles_list, game_host.chosen_tile)
