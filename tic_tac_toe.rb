# frozen_string_literal: true

# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
require_relative 'lib/game_over_logic'
# require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

board_tiles = BoardTiles.new
game_host = GameHost.new
game_moderator = GameModerator.new(board_tiles, game_host)
game_over_logic = GameOverLogic.new(board_tiles, game_host, game_moderator)

# will be turn method
def play_turn(game_moderator, game_over_logic)
  game_moderator.ask_player_to_select_tile
  game_moderator.coordinate_tile_validation

  game_moderator.place_player_token_on_tile

  game_moderator.update_available_tiles

  game_moderator.update_current_player_token
  game_moderator.update_current_player

  game_over_logic.check_end_game_conditions
end

loop do

  play_turn(game_moderator, game_over_logic)

  break if game_over_logic.game_status == game_over_logic.game_over
end
