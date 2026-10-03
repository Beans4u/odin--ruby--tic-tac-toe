# Dev Log: Tic Tac Toe

## + + + + DAY 1 NOTES + + + +

Today I'm listening to Gazpacho's albums "March of Ghosts", "Missa Atropos", "Tick Tock", and "Night".

I'm coming back from a long break again (house repairs and a minor injury - nevermind that!), so I'm going to be a little lost. Leading up to this assignment were lessons on OOP and project file management, and linting and RuboCop, so I'm going to incorporate those in this assignment as much as (or to keep the scope lean, _as little as_) reasonable.

## + + + Assignment Objectives + + +

To paraphrase, a simple Tic Tac Toe console game which is playable by two players sharing a keyboard.

I assume we must use principles we learned leading to this assignment.

### Requirements:

- Tic Tac Toe console game playable by two players sharing a keyboard
- Use OOP principles as appropriate (classes, modules)
- Use project management to keep files separate (class file, ruby code file, etc.)
- Use RuboCop & Ruby LSP (I've been using it since I installed Ruby the first time because I got used to the linter for JavaScript and didn't realize I wasn't supposed to add RuboCop yet). I'm using their default settings.

### OOP Principles

Need to determine ownership of code and code architecture in terms of OOP principles just learned.

Considerations:

- When do I need a class? When it needs to know or do things, right?
  - What does the object need to know?
  - Can what it needs to know be temporary or does the info persist in the object? (instance vs local variables)
  - What does the object need to do?
- Do two different objects have an is-a relationship, benefitting from inheritance?

### Project Management

Directory: (example from [Project Management](https://www.theodinproject.com/lessons/ruby-project-management) lesson)

```
├── lib
│   ├── sort
│   │   ├── bogo_sort.rb
│   │   ├── bubble_sort.rb
│   │   └── merge_sort.rb
│   └── sort.rb
└── main.rb
```

I'll know more about what my own structure will look like after I figure out what my classes should look like.

### Linting and RuboCop

- RuboCop & Ruby LSP installed
- Use of Ruby bundle init and Gemfile (I just added the below to the Gemfile). I genuinely can't remember where I got it, but it's in my notes. Yes, the notes we're encouraged not to take.
- Split code into one class per file in a lib directory, and use require_relative to load them into the program

Gemfile:

```ruby
group :development, :test do
  gem 'standard'
end
```

## Problem: What do?

Assignment: "Build a tic-tac-toe game on the command line where two human players can play against each other and the board is displayed in between turns."

Tic Tac Toe flow:

GAME FLOW:

- GAME LOOP:
  - PROMPT PLAYER:
    - DISPLAY: game board
    - DISPLAY: game board tile options & prompt player for their choice
    - GET: Receive Player one/two game board tile choice
      - Error handling for incorrect responses
      - RESTART PLAYER PROMPT LOOP if response is invalid
    - END PROMPT PLAYER LOOP
  - UPDATE: the chosen game board tile with the player token (for display)
  - UPDATE: remove the chosen game board tile from the game board tile options displayed to user on their turn
  - LOGIC: Check for winning or stalemate conditions
- BREAK GAME LOOP IF: winning condition or stalemate condition is met

END GAME FLOW:

- GET: Display choice to start new game or exit terminal
  - Error handling for incorrect responses
  - RETURN to END GAME FLOW prompt if response is invalid
- RETURN to GAME START LOOP --or-- EXIT terminal

That's as much as I probably need to figure out at this point. Can I start thinking about classes and ownership?

Classes:

- GameBoard
  - Owns tiles
  - Knows what state the tiles are in (have x or o tokens on them or empty)
  - Owns the player tokens x and o
  - Methods to update tiles (logic lives in another class?)
  - Limit one object per game
- Logic/Rules
  - Player 1/2 turn state
  - Checks if player's tile selection is valid or invalid
  - Restarts loop on incorrect response received to re-prompt player
  - Removes GameBoard tile options for player prompt after they choose one for token placement
  - Contains logic for winning and stalemate conditions? Or should this be in GameBoard?
- GameHost (talks to the user on behalf of the game)
  - Displays GameBoard
  - Displays GameBoard tile options for players to place their x or o token onto
  - Displays error messages to clarify prompt
  - Displays end game options to start a new game or exit terminal

Removed:

- Player
  - Knows it's an x or an o? Is this enough to merit a class? No, I don't need a player class. I can handle this with logic since they share a keyboard. Right?? Right. No Player class, then.

Ok I have separated concerns and put things into classes. Is this making sense? Do the logic/rules need a class or should they be a module that gets mixed into the GameBoard and GameHost classes? The logic doesn't need to be an object, right?

I think I should keep the logic in the classes they belong to. At this point, everything in the logic class looks like it knows about the logic of all the classes, which doesn't make sense.

So the new layout is:

Classes:

- GameBoard
  - Owns tiles
  - Knows what state the tiles are in (have x or o tokens on them or empty)
  - Owns the player tokens x and o
  - Player 1/2 turn state
  - Checks if player's tile selection is valid or invalid
  - Restarts loop on incorrect response received to re-prompt player
  - Removes tile options for player prompt after they choose one for token placement
  - Contains logic for winning and stalemate conditions
  - Limit one GameBoard object per game
- GameHost (talks to the user on behalf of the game)
  - Displays GameBoard
  - Displays GameBoard tile options for players to place their x or o token onto
  - Displays error messages to clarify prompt
  - Displays end game options to start a new game or exit terminal

Well, I'm worried this makes GameBoard too big, but I don't want GameHost to do anything more than display things to the users. Does GameBoard own too much?

Maybe the logic/controller class made sense after all? I think the turn state can make sense in another class, as well as the error handling. But for such a small game, I think we can say the GameBoard owns all of this. I could sully GameHost and make the host keep track of the player turn, which makes sense semantically, but doesn't separate concerns the way I would like. We can just imagine that this game board would know whose turn it is. Like Jamanji.

I'm going to take this into my scratch.rb doc and mess around.

Okay, I'm feeling very encouraged. I actually managed to figure this out. Help in thanks to reviewing the [lessons](https://www.theodinproject.com/lessons/ruby-object-oriented-programming) before hand, and this great article:

- [Using Ruby Classes to Implement a Game of BlackJack](https://medium.com/quick-code/using-ruby-classes-to-implement-a-game-of-blackjack-535a786c417) (Danielle Walraven, Medium)

```ruby
# GameBoard knows the tiles, player tokens, turn state, win/stalemate logic, and validates user responses
class GameBoard
  attr_accessor :tiles
  attr_reader :player1_token, :player2_token, :empty_tile

  def initialize # I have no idea if I'm doing this right
    @player1_token = 'x'
    @player2_token = 'o'
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
  end

  def tiles
    @tiles = [
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
  end

end

# GameHost talk to the user on behalf of the game
class GameHost

  def display_game_board(board)
    puts "
      Game Board:
      #{board.tiles[0]}  #{board.tiles[1]}  #{board.tiles[2]} \n
      #{board.tiles[3]}  #{board.tiles[4]}  #{board.tiles[5]} \n
      #{board.tiles[6]}  #{board.tiles[7]}  #{board.tiles[8]} \n
    "
  end
end

game_board = GameBoard.new
game_host = GameHost.new

game_host.display_game_board(game_board)
```

## + + + + DAY 2 NOTES + + + +

Good morning. It's Saturday. Whee. Today I'm listening to Dol Theeta's albums "The Universe Expands" and "Monad", lest they prove to be distracting. It's been a minute since I've given them a thorough listening-to. I have already hidden the first track _Which Are You_ while writing this paragraph, ahah. Moving on.

### Problem: Understanding how to use classes

Previously, I hacked away at the first two classes until I got them to display the game board. Now I need to develop the behaviours of each class. In GameBoard, I created a method for tiles, but I treated it as a container for my values rather than the constructor that it is, because I guess I was le tired and didn't question my assumption on that one.

I also think the tile grid should be generated on board creation rather than have to call a method to build it. But now that I've moved it to the initialize method, that method is like 25 lines long.

Is that ok? I feel like I'm doing classes wrong. Should `Tiles` be a subclass of `GameBoard`? Does each tile need to be an object? Would I be separating them just to keep things smaller or would there actually be a benefit separating them?

If each tile was an object, I could generate them in a loop as I saw with the deck of cards in the BlackJack game linked in DAY 1. So each object would be `tile1`...`tile8` and contain what? Only whether it has a tile or not. So each object would only need to know whether it was empty or held a `Player1_token` or `Player2_token`. Is this enough to justify an entire subclass? It would keep my GameBoard cleaner. I guess there's no harm in trying it.

As I made this, I realized on migrating all the tile code to the `BoardTiles` class that I don't actually need to make each `tile` object, I can use it the same way I was using it in `GameBoard`.

Also on migrating all the tile code to the subclass, I realize just how much of it there is and I'm really glad I went ahead with it. Now the `GameBoard` is responsible for the players, player tokens, and the game logic. It is like a `GameHost` _doing_ vs the `GameHost` `showing`. I wonder if I should rename `GameBoard` to something more idiomatic, such as `GameCoordinator` or somesuch. To be determined.

I also realized that `BoardTiles` doesn't need any of the methods from `GameBoard`, so it doesn't inherit from it anymore.

Looks like I'm out of time for now. I'm pretty happy with this so far, I seem to have figured out how to make things work together. Here is what I came up with so far:

```ruby
# frozen_string_literal: true

# GameBoard knows the players, player tokens, turn state, win/stalemate logic
# and validates user responses
# frozen_string_literal: true

# GameBoard knows the players, player tokens, turn state, win/stalemate logic
# and validates user responses
class Game
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

  # forbid more than one GameBoard object from existing in a single game
  def limit_one_GameBoard_object
    p 'this is not developed yet'
  end
end

# BoardTiles knows the tiles and updates them with the GameBoard player tokens based on player choices
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
    @tile1_option = "tile1"
    @tile2_option = "tile2"
    @tile3_option = "tile3"
    @tile4_option = "tile4"
    @tile5_option = "tile5"
    @tile6_option = "tile6"
    @tile7_option = "tile7"
    @tile8_option = "tile8"
    @tile9_option = "tile9"

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
  def update_tile(host, game_board)
    @tiles_grid[host.player_choice] = game_board.current_player_token
  end

  # GameHost object will send the user's tile choice here, but is it valid?
  def validate_tile_chosen(host)
    # CHECK: will this spread allow any value from the array?
    host.player_choice == @tile_options[0..8] ? true : false
  end

  # After @tile_grid tile is updated with player's token
  # the tile options will update to remove that tile as an option
  # CHECK: no idea if this method will work
  def update_tile_options(host)
    tile_options.splice!(host.player_choice, 1)
  end


end

# GameHost talk to the user on behalf of the game
class GameHost
  attr_reader :player_choice

  def initialize
    @player_choice = ''
  end

  def display_board_tiles(board_tiles)
    puts "
      Game Board:
      #{board_tiles.tile_grid[0]}  #{board_tiles.tile_grid[1]}  #{board_tiles.tile_grid[2]} \n
      #{board_tiles.tile_grid[3]}  #{board_tiles.tile_grid[4]}  #{board_tiles.tile_grid[5]} \n
      #{board_tiles.tile_grid[6]}  #{board_tiles.tile_grid[7]}  #{board_tiles.tile_grid[8]} \n
    "
  end

  def present_available_tiles(board_tiles, game_board)
    puts "
    - - #{game_board.current_player} turn - - \n
    Which tile will you place your player token on?: \n
      #{board_tiles.tile_options[0]}  #{board_tiles.tile_options[1]}  #{board_tiles.tile_options[2]} \n
      #{board_tiles.tile_options[3]}  #{board_tiles.tile_options[4]}  #{board_tiles.tile_options[5]} \n
      #{board_tiles.tile_options[6]}  #{board_tiles.tile_options[7]}  #{board_tiles.tile_options[8]} \n
    "
  end

  def get_player_choice
    @player_choice = gets.chomp
    @player_choice
  end

  def display_tile_validation_error
    puts "#{current_player}, you entered #{@player_choice}, which is invalid. \n
    Please review the tile options and enter the tile exactly as presented."
  end

  # forbid more than one GameHost object from existing in a single game
  def limit_one_GameHost_object
    p 'this is not developed yet'
  end
end

class RunGame
  attr_reader :game_board, :board_tiles, :game_host

  def initialize
    @game_board = Game.new
    @board_tiles = BoardTiles.new
    @game_host = GameHost.new
  end

  # todo: create PROMPT PLAYER loop from DEV_LOG.md
  def play_game
    @game_host.display_board_tiles(@board_tiles)
    @game_host.present_available_tiles(@board_tiles, @game_board)
  end

end

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +
run_game = RunGame.new
run_game.play_game
```

I tried putting the above code into a collapsible section, but then that block removed all the formatting from the code block??? Why??? Lame. Ok. I'm over it. Moving on.

Next session, I will separate them into files and start building out the app for real.

## + + + + DAY 3 NOTES + + + +

Forgot to commit my work yesterday. Whoops.

Today I'm listening to some albums by Mega Drive: "Mega Drive", "198XAD", and "Encoder".

### + + + Today's Tasks + + +

1. Split the classes into distinct 'production' documents and require them into the main `tic-tac-toe.rb` document. Not sure yet what that should look like.
2. Build the process flow (loops, etc.) outlined in DAY 1 of this doc as a means of also developing the remaining behaviours (methods) of each class.

### Task 1: Separate classes into class documents

Not sure what this should look like yet. Should the `tic-tac-toe.rb` doc just run the procedural code I have at the bottom? Literally run the game and that's it? I'm ok with that. Just not sure if that's standard or if the RunGame class should just become the `tic-tac-toe.rb` program.

I think I'll do the former because it seems easier? Am I thinking of this the wrong way?

First I want to rethink the GameBoard class. I think it should be renamed to reflect its refined purpose, which is to orchestrate the game logic and track state. GameState??? GameManager? GameCoordinator? GameModerator? GameMaster? GameWizard.

Reference from [Project Management](https://www.theodinproject.com/lessons/ruby-project-management) lesson:

```
├── lib
│   ├── sort
│   │   ├── bogo_sort.rb
│   │   ├── bubble_sort.rb
│   │   └── merge_sort.rb
│   └── sort.rb
└── main.rb
```

So mine would be:

```
├── lib
│   ├── game_moderator.rb
│   ├── board_tiles.rb
│   ├── game_host.rb
│   └── run_game.rb
│
└── tic_tac_toe.rb
```

I removed the load file because I don't think I really need a file as a shorthand for the four files I need to require. I assume standard practice is not to over-engineer the file structure for such small games.

## + + + + + Pain Points / Lessons Learned + + + + +

- Thinking I can use classes like hashes to access information
- How to share information between objects of different classes
