# frozen_string_literal: true

# GameOverLogic contains the logic that determines whether there is a player winner or a stalemate.

class GameOverLogic
  attr_reader :game_status, :in_progress, :game_over

  def initialize(board_tiles, game_host, game_moderator)
    @board_tiles = board_tiles
    @game_host = game_host
    @game_moderator = game_moderator
    @in_progress = 'in progress'
    @game_over = 'game over'
    @game_status = @in_progress
  end

  # runs after each turn so that both players are checked
  # TODO: create loop that enables this to run only after a player has placed 3 tiles
  def check_win_conditions
    win_message = "#{@current_player} wins!" #TODO: this should be in the game_host_class object

    case
      # - - - ROWS - - - -
    when @board_tiles.game_board_tiles[:tile1] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile2] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile3] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over
    when @board_tiles.game_board_tiles[:tile4] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile6] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over
    when @board_tiles.game_board_tiles[:tile7] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile8] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over

      # - - - COLUMNS - - - -
    when @board_tiles.game_board_tiles[:tile1] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile4] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile7] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over
    when @board_tiles.game_board_tiles[:tile2] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile8] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over
    when @board_tiles.game_board_tiles[:tile3] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile6] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
      @game_status = @game_over

    # - - - DIAGONAL - - - -
    when @board_tiles.game_board_tiles[:tile1] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile9] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
    when @board_tiles.game_board_tiles[:tile3] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile5] == @game_moderator.current_player_token &&
      @board_tiles.game_board_tiles[:tile7] == @game_moderator.current_player_token
      puts win_message
      :win_condition_true
    else
      puts "check_win_conditions || else statement: #{@check_win_conditions == true}" # TODO delete
      false
    end
  end

  # if false, stalemate is true.
  def check_stalemate_condition
    puts "check_stalemate_condition || @board_tiles.game_board_tiles.value?(' ') >> #{@board_tiles.game_board_tiles.value?(' ')}"

    @board_tiles.game_board_tiles.value?(' ')
  end

  def check_end_game_conditions
    if check_win_conditions == :win_condition_true
      puts "check_end_game_conditions: -IF- check_win_conditions == true is: || #{@check_win_conditions == :win_condition_true}" # TODO delete
      @game_status = @game_over

    elsif check_stalemate_condition == false
      # (must be true until all @game_board_tiles hold player tokens)
      puts "check_end_game_conditions: -ELSIF- 'check_stalemate_condition == false' is: || #{@check_stalemate_condition == false}" # TODO delete
      @game_status = @game_over
    end
  end
end
