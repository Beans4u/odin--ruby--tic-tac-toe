# frozen_string_literal: true

# GameModerator knows the players, player tokens, turn state,
# win/stalemate logic, and validates user responses
class GameModerator
  attr_reader :player1_token, :player2_token, :current_player

  def initialize
    @player1_token = 'x'
    @player2_token = 'o'
    @PLAYER1 = 'Player 1'
    @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1 # default for new games
  end

  # GameHost object will ask the player whose turn it is based on this flag
  def update_player_turn
    @current_player == @PLAYER1 ? @current_player = @PLAYER2 : @current_player = @PLAYER1
    @current_player
  end

  # Checks if a winning condition has been met
  def check_winning_conditions
    p 'this is not developed yet'
  end

  # Checks if a stalemate condition has been met
  def check_stalemate_conditions
    p 'this is not developed yet'
  end

  def place_player_token
    player_token = @board_tiles.validate_tile_chosen(@game_host)
    @board_tiles.update_tile(player_token)
  end

  # forbid more than one GameModerator object from existing in a single game
  def limit_one_game_moderator_object
    p 'this is not developed yet'
  end
end
