# Dev Log: Tic Tac Toe

## + + + + DAY 1 NOTES + + + +

Today I'm listening to Gazpacho's albums "March of Ghosts", "Missa Atropos", "Tick Tock", and "Night".

I'm coming back from a long break again (house repairs and a minor injury - never mind that!), so I'm going to be a little lost. Leading up to this assignment were lessons on OOP and project file management, and linting and RuboCop, so I'm going to incorporate those in this assignment as much as (or to keep the scope lean, _as little as_) reasonable.

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

Today I'm listening to some albums by Mega Drive: "Mega Drive", "198XAD", and "200XAD".

### + + + Today's Tasks + + +

1. Split the classes into distinct 'production' documents and require them into the main `tic-tac-toe.rb` document. Not sure yet what that should look like.
2. Build the process flow (loops, etc.) outlined in DAY 1 of this doc as a means of also developing the remaining behaviours (methods) of each class.

### Task 1: Separate classes into class documents

Not sure what this should look like yet. Should the `tic-tac-toe.rb` doc just run the procedural code I have at the bottom? Literally run the game and that's it? I'm ok with that. Just not sure if that's standard or if the RunGame class should just become the `tic-tac-toe.rb` program.

I think I'll do the former because it seems easier? Am I thinking of this the wrong way?

First I want to rethink the `GameBoard`class. I think it should be renamed to reflect its refined purpose, which is to orchestrate the game logic and track state. GameState??? GameManager? GameCoordinator? GameModerator? GameMaster? GameWizard.

I'm going to review the project management lesson real quick.

(...)

Ok so I think it's pretty straightforward.

File structure reference from [Project Management](https://www.theodinproject.com/lessons/ruby-project-management) lesson:

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

### Task 2: Build game process flow and remaining class behaviours

I'm going to repeat the game flow I estimated from DAY 1 for easy reference:

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

And this is all I figured out for `RunGame` so far:

```ruby
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
```

So I'll start with the prompt player loop. I'm going to rename it to `play_turn` for clarity.

PLAY TURN LOOP:

- DISPLAY: `game_host` to `display_board_tiles` using `board_tiles.tile_grid`
- DISPLAY: `game_host` to `present_available_tiles` using `board_tiles.tile_options`
- GET: `board_tiles` to `collect_player_choice` and receive `@player_choice`
- VALIDATE CHOICE: `board_tiles` to `validate_tile_chosen` using `@player_choice` and returning `true` or `false` (truthy/falsy)
  - (if falsy) DISPLAY: `game_host` to `display_tile_validation_error` message to clarify request
  - (if truthy) BREAK PLAY TURN LOOP: using ?? <-- I need to look this up, I don't remember

END PROMPT PLAYER LOOP

Updating the tiles can happen outside of this loop, but all of this will take place inside of a larger game loop.

Alright, so I've been sort of working at it by instinct, and I kept going back and forth on `play_turn` and how to construct it, and where to keep the helper methods. I tried a few things, but I know I'm going about this the wrong way. It feels like I've made a real mess of things and I feel like I need to step back and rethink this whole thing. Maybe start over?

Instead of a loop, I came up with this in the `RunGame` class:

```ruby
  def play_turn
    @game_host.display_board_tiles(@board_tiles)
    @game_host.present_available_tiles(@board_tiles, @game_moderator)
    @board_tiles.collect_player_choice
    @board_tiles.handle_error(@game_host, @run_game) if @board_tiles.validate_tile_chosen == false
  end
```

In `tic_tac_toe.rb`, this would just appear as:

```ruby
@run_game.play_turn
```

I'm assuming `play_turn` is packing too much into one method.

`@board_tiles.handle_error` calls `@game_host.display_validation_error`, and then `@run_game.play_turn` rather than use a loop. But I have the feeling it doesn't belong in `BoardTiles`, and I'm getting tired enough that my eyes feel dry. Perhaps it's time I called it a night, even though I still have music left.

```ruby
def handle_error(host, run)
  @game_host.display_tile_validation_error
  @run_game.play_turn
end
```

I can tell I'm going about this all wrong and that I'm in over my head a little bit. I wish I had an example to look at for a small, simple game of this size and complexity (in other words, for beginners). I'll try again in the morning, and hope it's wiser than the night.

I would rather study existing code bases than learn everything the hard way. If I was in a class in school, I'm sure we'd be shown examples or be able to talk to the teacher about what we were doing. I guess I could always use Discord. I just wish there was a dedicated "example" repo, even if it just showed a glorified version of all those vehicle/car class/object examples I keep seeing around the tutorials. Just a small console vroom vroom game with 3 or 4 classes and we can just see what is going on and what the tutorials and blog posts meant for us to do with what they taught.

Anyway, I can complain or I can learn. Never trust your thoughts after 9:00, right? Alright, I'm going to start winding down my day and think more about all this when I return tomorrow.

## + + + + DAY 4 NOTES + + + +

Whoooooof. Sunday. 1pm, just sitting down. Still feeling heavy, groggy. Love a lazy Sunday, though. Today feels like a Habitants day. Listening to their only two albums, "One Self" and "Alma".

So last night I left things off on a negative note, feeling I have lost control of my classes. Today I'll review my work. I think what probably happened was I got ahead of myself and started defining methods before I needed them, and even minor refactors wound up confusing me later, managing what is essentially junk data at present.

Sometimes I get an idea of how I think it will go and I just plug in a placeholder "something like this" method off the dome and I don't even end up using it by the time I get there. So lesson learned: Everything in its time, Rin!!

### Task 2, continued: Build game process flow and remaining class behaviours

I'm going to continue building out the methods via building the game flow in the RunGame class.

So far I've been trying to get it to work. Spent a whole album just tweaking code to see what will resolve the error messages that come up. It's nice to see an error message turn into a new error message, but at this point, I've spent an entire album doing this and I'm still at that place where I feel confused and overwhelmed by the class things and I'm convinced I'm doing classes wrong.

```ruby
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
    @board_tiles.handle_error(@game_host, @run_game, @board_tiles, @game_moderator) if @board_tiles.validate_tile_chosen(@game_host) == false
  end
end

class GameModerator
  attr_reader :player1_token, :player2_token, :current_player

  def initialize
    @player1_token = 'x'
    @player2_token = 'o'
    @PLAYER1 = 'Player 1'
    @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1 # default for new games
  end
# ...
end

class BoardTiles
  attr_reader :empty_tile, :tile_grid, :tile_options

  # ...

    def validate_tile_chosen(host)
    # CHECK: will this spread allow any value from the array?
    # below is a true/false bool that RuboCop asked me to change,
    # TODO: use true/false val as message in method that will require
    # it when I build it out later.
    p "|| board >> validate_tile_chosen(host).host.player_choice == @tile_options[0..8] || #{host.player_choice == @tile_options[0..8]}" # TODO: delete after testing
    host.player_choice == @tile_options[0..8]
  end

  def handle_error(host, run, board, moderator)
    host.display_tile_validation_error(moderator, board)
    run.play_turn
  end

  # ...
end

class GameHost
  attr_reader :player_choice

  def initialize
    @player_choice = nil
  end

  # ...

  def collect_player_choice
    @player_choice = gets.chomp
    p "|| host >> game_host.collect_player_choice || #{@player_choice}" # TODO: for testing, remove later
    @player_choice
  end

  def display_tile_validation_error(game_moderator, board_tiles)
    puts "#{game_moderator.current_player}, you entered #{board_tiles.player_choice}, which is invalid. \n
    Please review the tile options and enter the tile exactly as presented."
  end

  # ...
end

# TIC TAC TOR doc
# ... the require_relative class docs

run_game = RunGame.new
run_game.play_turn
```

output:

```

      Game Board:








    - - Player 1 turn - -

    Which tile will you place your player token on?:

      tile1  tile2  tile3

      tile4  tile5  tile6

      tile7  tile8  tile9


tile1
"|| host >> game_host.collect_player_choice || tile1"
"|| run >> board tiles.player_choice || tile1"
"|| board >> validate_tile_chosen(host).host.player_choice == @tile_options[0..8] || false"

(...)odin--ruby--tic-tac-toe/lib/game_host.rb:37:in 'GameHost#display_tile_validation_error': undefined method 'player_choice' for an instance of BoardTiles (NoMethodError)

    puts "#{game_moderator.current_player}, you entered #{board_tiles.player_choice}, which is invalid. \n

        from (...)/odin--ruby--tic-tac-toe/lib/board_tiles.rb:68:in 'BoardTiles#handle_error'
        from (...)/odin--ruby--tic-tac-toe/lib/run_game.rb:18:in 'RunGame#play_turn'
        from tic_tac_toe.rb:11:in '<main>'
```

And basically I'm so fatigued from using classes as arguments and trying to remember where methods live, I feel like this is some kind of dependency hell or something. Surely I'm handling this all wrong.

At some point, I needed all four classes as method parameters to handle the validation error (and it's still not working). I am feeling dizzy from it all.

Surely this is not how this is supposed to go down. Surely I'm misunderstanding something. The tutorials don't really talk about using methods as arguments, do they? iirc they didn't have anything this complex going on, which makes me think I'm doing it wrong.

What is the architecture or syntax or methodology I should be using? And how do I find out?

So basically, aside from some errors resolved, I'm still at the same place I was last night. I've got to do something differently. I think?

I still have a few songs left on the last album, but I'm being kicked out of the office xD. I'm going to close this down and tomorrow I'll remove all the noise from the code base I built up. I should have done a sort of TDD approach, building up one method at a time and ensuring it works before adding others, and certainly not building anything hypothetical that I might not need, or need in that form.

## + + + + DAY 5 NOTES + + + +

I forgot to push yesterday again. Ah, well.

Today I'm listening to Lunatic Soul albums "Fractured" and "Under the Fragmented Sky". "Shaded Woods" if I can get away with the time commitment.

Today's goals:

- Task 1.5 (retroactive): remove the junk data from my code base, essentially start over where reasonable.
- Task 2, continued & restarted: Build game process flow and class behaviours

## Task 1.5: remove the junk data from my code base

Ok. Well, I pushed yesterdays' work, so if I regret it, I can just pull from GitHub. Let's do this.

Ok I removed all the definitions, but at this point, I'm tempted to also remove the initialize methods as well. Maybe that's part of assuming what I do and don't need. I mean, I've gone this far. Maybe I should start over completely? Maybe I don't need the classes I think I do. Or am I now taking this too far, having previously already determined which classes I was going to use? Yeah, I'll keep them, then.

However, I'm beginning to wonder if I really need the `RunGame` class. My idea was that all the mess of the code that runs the game using the other classes would be completed there, and that I would call those methods from `tic-tac-toe.rb` rather than at the bottom of the `RunGame` class, to keep it clean.

But does that make sense? Is that what people do in industry? If I do it this way, should `RunGame` also require the other classes at the top of the file? Because now I'm wondering if this is where a lot of my problems/confusion could have been avoided.

I guess I can try `RunGame` again, because I like the idea of keeping the game execution file clean. But maybe this time I can try requiring the other classes in `RunGame`? Well I'll leave it out initially and consider adding them if it seems like that's cleaner, or solves a problem.

**Reset Result:**

tic_tac_toe.rb

```ruby
# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

run_game = RunGame.new
```

run_game.rb

```ruby
class RunGame
  attr_reader :game_moderator, :board_tiles, :game_host

  def initialize
    @game_moderator = GameModerator.new
    @board_tiles = BoardTiles.new
    @game_host = GameHost.new
  end
end
```

game_moderator.rb

```ruby
class GameModerator
  attr_reader :player1_token, :player2_token, :current_player

  def initialize
    @player1_token = 'x'
    @player2_token = 'o'
    @PLAYER1 = 'Player 1'
    @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1 # default for new games
  end
end
```

board_tiles.rb

```ruby
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
    @tile1_option = 'tile1'
    @tile2_option = 'tile2'
    @tile3_option = 'tile3'
    @tile4_option = 'tile4'
    @tile5_option = 'tile5'
    @tile6_option = 'tile6'
    @tile7_option = 'tile7'
    @tile8_option = 'tile8'
    @tile9_option = 'tile9'

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
end
```

Above is why I was considering starting over completely, without initializing anything. This seems like maybe there's a better way. Perhaps using hashes will reduce lines of code since I won't have to declare variables before putting them into a array.

I'm also beginning to wonder if the tile_options should belong to GameHost since the `BoardTiles` class doesn't need to talk to the player, or know what is being communicated with them.

game_host.rb

```ruby
class GameHost
  attr_reader :player_choice

  def initialize
    @player_choice = nil
  end
end
```

The GameHost methods were the most painful to delete because I feel keeping them would save me rework rebuilding those. But I did build them before I needed them, and dems the rules (that I self-imposed).

Aaaaaaah fine. Gone. they're gone. Everything is gone.

**Final Reset Result:**

tic_tac_toe.rb

```ruby
# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

run_game = RunGame.new
```

run_game.rb

```ruby
class RunGame

end
```

game_moderator.rb

```ruby
class GameModerator

end
```

board_tiles.rb

```ruby
class BoardTiles

end
```

game_host.rb

```ruby
class GameHost

end
```

Okay????

Well, let's get (re)building! Hooooooaaaah, boy.

Ok let's do this.

## Task 2 (redux): build out game flow and helper methods

I am once again going to repeat the game flow I estimated from DAY 1 for reference:

**Game flow:**

GAME LOOP:

- PROMPT PLAYER:
  - DISPLAY: game board
  - DISPLAY: game board tile options & ask player for their choice
  - GET: Receive Player one/two game board tile choice

- DATA VALIDATION:
  - Validate received tile choice from player. If invalid:
    - DISPLAY error message
    - call PROMPT PLAYER method again

- UPDATE: the chosen BOARD TILE with the PLAYER TOKEN (for display)
- UPDATE: remove the chosen BOARD TILE from the EMPTY TILES displayed to user on their turn
- UPDATE: switch CURRENT PLAYER flag to the next player (for DISPLAY messages)
- LOGIC: Check for winning or stalemate conditions

- BREAK GAME LOOP IF: winning condition or stalemate condition is met

END GAME FLOW:

- DISPLAY: game results (winner or stalemate)
- DISPLAY: game board with final play
- GET: Ask user to start new game or exit terminal
  - DATA VALIDATION:
    - DISPLAY: error message for incorrect response
    - CALL the GET function again
  - If yes: CALL the GAME START method to reset game
  - If no: EXIT terminal

I updated it a little bit to get a better feel for it.

### Helper: Prompt Player for tile choice

I'm going to take this slowly. What do I need to accomplish this part of the game flow?

- PROMPT PLAYER:
  - DISPLAY: game board
  - DISPLAY: game board tile options & ask player for their choice
  - GET: Receive Player one/two game board tile choice

I'll start with the `GameHost` class.

```ruby
class GameHost

  def display_board_tiles

  end
end
```

So right off the bat I can see that I need board tiles to display. So I'm actually going to start there and maybe get myself another coffee with hopes it will make me smarter. Or still dumb, but faster. -.-"

## State and Display: Board Tiles

So I was considering using hashes instead of arrays in order to reduce the number of lines the initialize function will use.

And since players can't take their moves back or destroy each-other's tiles, I don't need to hold the empty string in a variable, do I? I was doing it to be idiomatic. Should I do that or forgo it?

We'll see how much I hate it without.

```ruby
class BoardTiles
  attr_reader :game_board_tiles

  def initialize
    @game_board_tiles = {
      tile1 => ' ',
      tile2 => ' ',
      tile3 => ' ',
      tile4 => ' ',
      tile5 => ' ',
      tile6 => ' ',
      tile7 => ' ',
      tile8 => ' ',
      tile9 => ' '
    }
  end

  def game_board
    @game_board = "
    + + + GAME BOARD + + + \n
    #{}  #{}  #{} \n
    #{}  #{}  #{} \n
    #{}  #{}  #{} \n
    "
  end
end
```

Ruby is already saying I have too many lines. What do you want from me??? xD

Deal with it. idk how else I'm supposed to get my tile grid. I guess I could construct it in a loop? That feels like over-engineering to me. There's only nine tiles. And then instead of the BoardTiles object just having them on init, I would have to call the method to construct them, which also feels like over-engineering. But as a noobie, I should not be making these assumptions. But I am going to just continue ignoring RuboCop on this one.

Well, that's "Through Shaded Woods" done. I'm going to take my lunch break and have a coffee.

Aaaaand, we're caffeinated.

Ok, this is exciting. It's kind of fun to return to a reset codebase and a new hash. Ok, so what's next?

I tested the hash using `board_tiles = BoardTiles.new` and then `p board_tiles.game_board_tiles` in the `tic_tac_toe.rb` doc, and I received in `'BoardTiles#initialize': undefined local variable or method 'tile1' for an instance of BoardTiles (NameError)`.

So why is tile1 an undefined local variable? I initialized it. Oh, I see. I should have used symbols instead of the rocketship arrow thing. I feel like such a noob. Ok, so now it works.

Wow. It took me the rest of this album to get the hash printing in `tic_tac_toe`, but I got there. Lots of syntax bloopers. Totally forgot about requiring the colon when referencing symbols in `"#{game_board_tiles[:tile1]}"`, having assumed I only needed the colon during hash construction. This and other syntax errors took me the better part of an hour to figure out. Alas. Again, feeling like a noob. I took a long break from this curriculum and it shows.

Well so now I'm onto my last album. I can probably get away with adding another one today. We'll see how the day unfolds. I really do need to run some errands later.

GameHost:

```ruby
class GameHost
  attr_reader :present_board_tiles

  def display_board_tiles(game_board)
    @present_board_tiles = puts "
    + + + GAME BOARD + + + \n
    #{game_board[:tile1]}  #{game_board[:tile2]}  #{game_board[:tile3]} \n
    #{game_board[:tile4]}  #{game_board[:tile5]}  #{game_board[:tile6]} \n
    #{game_board[:tile7]}  #{game_board[:tile8]}  #{game_board[:tile9]} \n
    "
  end
end
```

BoardTiles:

```ruby
class BoardTiles
  attr_reader :game_board_tiles

  def initialize
    @game_board_tiles = {
      tile1: ' ',
      tile2: ' ',
      tile3: ' ',
      tile4: ' ',
      tile5: ' ',
      tile6: ' ',
      tile7: ' ',
      tile8: ' ',
      tile9: ' '
    }
  end
end
```

tic_tac_toe.rb:

```ruby
# + + + + + + + + REQUIRED CLASS FILES + + + + + + + + + +
require_relative 'lib/game_moderator'
require_relative 'lib/board_tiles'
require_relative 'lib/game_host'
require_relative 'lib/run_game'

# + + + + + + + + PROCEDURAL RUN GAME CODE + + + + + + + +

board_tiles = BoardTiles.new
game_host = GameHost.new
# game_board_tiles = board_tiles.game_board_tiles
game_host.display_board_tiles(board_tiles.game_board_tiles)
```

So far so good. Next:

## Prompt user for tile to place their player token upon

Ok, Rin. You do not need to create the player token. I know it's tempting, but let us be steadfast in our resolve to build items only as they are needed. I speak to myself using the royal "we". Since childhood. Who can say why. I keep trying to correct it as I go, because it feels embarrassing. But surely, I'm not the only one who speaks/refers to themselves in the third person?

I'm musing rather than coding. Let's do this. Self. Let us... yeah.

**who should own #gets?**
So the `GameHost` owns communications, but should it own the stored variable to pass along? Or should `BoardTiles` own the `#gets` function? Or perhaps the `GameHost` uses `#gets`, and just stores it in `BoardTiles`? I'm a little confused about the ownership situation. Previously, I gave it to GameHost, but I'm pretty sure it started out in BoardTiles, which means that I had this conversation with myself before and that's where I landed.

I think since hte `GameHost` is the one asking, it should be the one collecting. But maybe I can save it directly to `BoardTiles`? Wait, I'm pretty sure separation of concerns means that classes are supposed to mind their own business. Does that mean my `present_board_tiles` `#puts` statement should have been saved as a variable in `BoardTiles` and then used in `GameHost`? Well, no, because `GameHost` constructs the sentences that it communicates, and at any rate, I'm still giving `GameHost` the `BoardTiles` class object as an argument. Wow, this is confusing. What are the industry standards for this type of MCP style architecture? Maybe I'm overthinking this. I'm just going to give the #gets message to `GameHost` and move on.

**who should own the list of empty tiles?**
So to present the empty tiles to the player, I need to construct a hash or array of empty tiles adn display that to the player. After each turn, the tile that player placed a token on will be removed from this hash or array.

Which class should own this? It is used for only one purpose, to display token-placement options to the players. And since the BoardTiles class doesn't need to see or know about this, I'm going to keep them in `GameHost` this time around. Last time I kept them in `BoardTiles`, but that only made sense semantically. Right? What I like most about this is I don't have to pass anything in. I'll just try it out.

Well, ok. That was very easy.

Next: validate the text.

## Task: Validate the player's input text (chosen tile)

I validated it, hooray. My eyes are turning to dust.

I'm not through the third album yet. I wound up getting sent to the hardware store for an emergency purchase for a home maintenance project my partner is onto. After that, I had to run an errand of my own, then the rest of the day got away from me. But I managed to get most of the last album in after dinner. Yeah, that's how I'm measuring time, I realize. To each their own?

Final code for the day:

```ruby
# + + + GAME MODERATOR CLASS + + +
class GameModerator

  def validate_player_choice(empty_tiles, player_choice)
    p empty_tiles.has_value?(player_choice)
    empty_tiles.has_value?(player_choice)
  end
end

# + + + BOARD TILES CLASS + + +
class BoardTiles
  attr_reader :game_board_tiles

  def initialize
    @game_board_tiles = {
      tile1: ' ',
      tile2: ' ',
      tile3: ' ',
      tile4: ' ',
      tile5: ' ',
      tile6: ' ',
      tile7: ' ',
      tile8: ' ',
      tile9: ' '
    }
  end
end

# + + + GAME HOST CLASS + + +
class GameHost
  attr_reader :present_board_tiles, :chosen_tile, :empty_tiles_list

  def initialize
    @empty_tiles_list = {
      empty_tile1: 'tile1',
      empty_tile2: 'tile2',
      empty_tile3: 'tile3',
      empty_tile4: 'tile4',
      empty_tile5: 'tile5',
      empty_tile6: 'tile6',
      empty_tile7: 'tile7',
      empty_tile8: 'tile8',
      empty_tile9: 'tile9'
    }
  end

  def display_board_tiles(game_board)
    @present_board_tiles = puts "
    + + + GAME BOARD + + + \n
    #{game_board[:tile1]}  #{game_board[:tile2]}  #{game_board[:tile3]} \n
    #{game_board[:tile4]}  #{game_board[:tile5]}  #{game_board[:tile6]} \n
    #{game_board[:tile7]}  #{game_board[:tile8]}  #{game_board[:tile9]} \n
    "
  end

  def ask_player_to_place_token
    puts "Where do you want to place your token? \n\nReview the empty tiles below and enter your choice exactly as displayed. \n
      #{@empty_tiles_list[:empty_tile1]}  #{@empty_tiles_list[:empty_tile2]}  #{@empty_tiles_list[:empty_tile3]} \n
      #{@empty_tiles_list[:empty_tile4]}  #{@empty_tiles_list[:empty_tile5]}  #{@empty_tiles_list[:empty_tile6]} \n
      #{@empty_tiles_list[:empty_tile7]}  #{@empty_tiles_list[:empty_tile8]}  #{@empty_tiles_list[:empty_tile9]} \n
    "
  end

  def collect_player_tile_choice
    @chosen_tile = gets.chomp
    @chosen_tile
  end

# + + + TIC TAC TOE PROJECT FILE + + +
# (This is mostly for testing, not sure if I'm going to use the RunGame class or not)

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
end
```

Ok, that's me.

I have a job tomorrow, so I won't be super available but I'll try to put in a good album or two of work in. ;)

## + + + + DAY 6 NOTES + + + +

Today may be a short one because I'm busy. But I have a feeling I can make it work, since I got a lot of stuff out of the way this morning, and still managed to do my workout.

ok. OK. OKAY. So I left off with-

Wait a second, it's quiet in here. Let's see... today I'm listening to one of my favourite bands of all time, The Gathering, and I prefer their middle classic stuff, so I'm starting with "Nighttime Birds", and if there's time, "if_then_else", and if I can manage it in the evening, "How to Measure a Planet?".

OK!!! So I left off with- wait, where's my water. [pauses music] Hold on.

(...)

OMGGGG, SO I LEFT OFF WITH data validation. I managed to get it working

I went back up to my game flow list for data val, here it is below. I'm going to work on the error message next.

- DATA VALIDATION:
  - Validate received tile choice from player. If invalid:
    - DISPLAY error message
    - call PROMPT PLAYER method again

### Task: Build method to display error message

Well, I have everything working separately, but putting the methods into an execution method to group them by task is proving challenging. It works procedurally, though. I'm having trouble with NoMethodErrors for undefined methods when trying to pass them in as arguments across classes.

I'm halfway through the album, but I'm going to break for lunch and read articles about this kind of thing.

Ok, I'm fed, caffeinated, and I managed to figure out the class thing. I can instantiate the GameModerator class as such and it solves my problems for now:

```ruby
# DOCUMENT: tic_tac_toe.rb

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

# DOCUMENT: game_moderator.rb
class GameModerator
  attr_reader :current_player

  def initialize(board_tiles, game_host)
    @board_tiles = board_tiles
    @game_host = game_host
    @PLAYER1 = 'Player 1'
    # @PLAYER2 = 'Player 2'
    @current_player = @PLAYER1
  end

  def ask_player_to_select_tile
    @game_host.display_board_tiles(@board_tiles.game_board_tiles)
    @game_host.ask_player_to_place_token
    @game_host.collect_player_tile_choice
  end

  def validate_player_choice
    p @game_host.empty_tiles_list.value?(@game_host.chosen_tile) # TODO: for testing, remove
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
end
```

I have the feeling that my helper methods here are a bit on the messy side and that there's probably a leaner way to do this, but this is what I have for now. It's working.

Next, updating the state and stuff.

## Task: Build method(s) to update board tile with player token

I'm going to do this in the `BoardTiles` class. Last track of the album is playing, it's 28 minutes long. Not gonna make it because I have to go now. xD

## + + + + + Pain Points / Lessons Learned + + + + +

- Thinking I can use classes like hashes to access information
- How to share information between objects of different classes
- This project has been so weird for git push corrections that I now have `git commit --amend --no-edit` and `git push --force-with-lease` memorized. I guess you really do fail forward xD
- Getting ahead of myself building methods I don't need yet.
- Trouble understanding how to pass methods as parameters/arguments in other methods across classes
