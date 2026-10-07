# frozen_string_literal: true

# GameModerator knows the players, player tokens, turn state,
# win/stalemate logic, and validates user responses
class GameModerator
  attr_reader :current_player

  def initialize(board_tiles, game_host)
    @board_tiles = board_tiles
    @game_host = game_host
    @PLAYER1 = 'Player 1'
    @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1
    @player1_token = 'x'
  end

  def ask_player_to_select_tile
    @game_host.display_board_tiles(@board_tiles.game_board_tiles)
    @game_host.ask_player_to_place_token
    @game_host.collect_player_tile_choice
  end

  def validate_player_choice
    # p @game_host.empty_tiles_list.value?(@game_host.chosen_tile) # TODO: for testing, remove
    @game_host.empty_tiles_list.value?(@game_host.chosen_tile)
  end

  def coordinate_error_player_choice
    @game_host.display_player_choice_error_msg(@current_player)
    @game_host.collect_player_tile_choice
    p "player chose again: #{@game_host.chosen_tile}" # TODO: for testing, remove
    coordinate_tile_validation
  end

  def coordinate_tile_validation
    coordinate_error_player_choice if validate_player_choice == false
  end

  def place_player_token_on_tile
    @board_tiles.game_board_tiles[@game_host.chosen_tile.to_sym] = @player1_token
    # p "#{@game_host.chosen_tile} now holds #{current_player} token: #{@board_tiles.game_board_tiles[@game_host.chosen_tile.to_sym]}" # TODO: for testing, remove
  end

  def update_available_tiles
    tile_key = @game_host.empty_tiles_list.rassoc(@game_host.chosen_tile)
    tile, value = *tile_key
    p @game_host.empty_tiles_list.has_key?(tile)
    @game_host.empty_tiles_list[tile] = '     '
  end

  def update_current_player
    @current_player == @PLAYER1 ? @current_player = @PLAYER2 : @current_player = @PLAYER1
    p "current player: #{@current_player}" # TODO: for testing, remove
    @current_player # TODO: I don't need this, right?
  end
end
