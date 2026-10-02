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
