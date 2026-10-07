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
    @player2_token = 'o'
    @current_player_token = @player1_token
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

  def update_current_player_token
    @current_player_token == @player1_token ? @current_player_token = @player2_token : @current_player_token = @player1_token
    p "current player: #{@current_player_token}" # TODO: for testing, remove
    @current_player_token # TODO: I don't need this, right?
  end

  # runs after each turn so that both players are checked
  # TODO: create loop that enables this to run only after a player has placed 3 tiles
  def check_win_conditions
    win_message = "#{@current_player} wins!"

    case
      # - - - ROWS - - - -
    when @board_tiles.game_board_tiles[:tile1] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile2] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile3] == @current_player_token
      puts win_message
      @game_over = true
    when @board_tiles.game_board_tiles[:tile4] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile6] == @current_player_token
      puts win_message
      @game_over = true
    when @board_tiles.game_board_tiles[:tile7] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile8] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @current_player_token
      puts win_message
      @game_over = true

      # - - - COLUMNS - - - -
    when @board_tiles.game_board_tiles[:tile1] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile4] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile7] == @current_player_token
      puts win_message
      @game_over = true
    when @board_tiles.game_board_tiles[:tile2] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile8] == @current_player_token
      puts win_message
      @game_over = true
    when @board_tiles.game_board_tiles[:tile3] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile6] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @current_player_token
      puts win_message
      @game_over = true

    # - - - DIAGONAL - - - -
    when @board_tiles.game_board_tiles[:tile1] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @current_player_token
      puts win_message
      @game_over = true
    when @board_tiles.game_board_tiles[:tile3] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @current_player_token &&
      @board_tiles.game_board_tiles[:tile7] == @current_player_token
      puts win_message
      @game_over = true
    end
  end

  def check_stalemate_condition
    false unless @board_tiles.game_board_tiles.any?(' ')
  end

  def check_end_game_conditions
    if check_win_conditions == true
      true
    else
      check_stalemate_condition == true
    end
  end
end
