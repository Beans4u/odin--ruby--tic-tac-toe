# frozen_string_literal: true

# RunGame contains the loops and procedures to run the game
class RunGame
  attr_reader :game_moderator, :board_tiles, :game_host

  def initialize
    @game_moderator = GameModerator.new
    @board_tiles = BoardTiles.new
    @game_host = GameHost.new
  end

  # TODO: create PROMPT PLAYER loop from DEV_LOG.md
  def play_game
    @game_host.display_board_tiles(@board_tiles)
    @game_host.present_available_tiles(@board_tiles, @game_moderator)
  end
end
