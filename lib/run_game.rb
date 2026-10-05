# frozen_string_literal: true

# RunGame contains the loops and procedures to run the game
class RunGame
  attr_reader :game_moderator, :board_tiles, :game_host

  def initialize
    @game_moderator = GameModerator.new
    @board_tiles = BoardTiles.new
    @game_host = GameHost.new
  end

  def play_turn
    @game_host.display_board_tiles(@board_tiles)
    @game_host.present_available_tiles(@board_tiles, @game_moderator)
    @game_host.collect_player_choice
    p "|| run >> board tiles.player_choice || #{@game_host.player_choice}" # TODO: remove after testing
    @board_tiles.handle_error(@game_host, @run_game, @game_moderator) if @board_tiles.validate_tile_chosen(@game_host) == false
  end
end
