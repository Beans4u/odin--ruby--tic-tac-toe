# Dev Log: Tic Tac Toe

## + + + + + DAY ONE NOTES + + + +

Today I am listening to Hawkwind's most 3 recent albums that aren't live or compilations: "The Future Never Waits", "Stories From Time and Space", and "There is No Space For Us", each on repeat. They are really chill.

## Objective

The assignment asks that I create a Tic Tac Toe game that is played between two human players in the console, the "board" displayed to the users after each turn is played.

### Plan: Two players

Text will explicitly state which player's turn it is.

Something like this?

```ruby
player_one_prompt = "PLAYER ONE: Choose your next move"
```

I'll have to figure out the verbiage later once I figure out the game flow.

### Problem: What does the console's Tic Tac Toe "board" look like?

- The 'board' can be outlined using dashes and pipes. ALT+0175 gives the upper score. Ok, that doesn't actually work in bash, or at least not in this markdown file. I'll just use the vertical pipes to keep this simple.
- The console doesn't use monospace so I'll use two spaces for empty spots.

maybe something like:

```bash
| x |   |   |

| x | o |   |

|   |   | o |
```

### Problem: Game flow

Let's start super basic.

**Play flow:**

1. Prompt `player_1` for their move
2. Update game board/state internally
3. Display board
4. Prompt `player_2` for their move
5. Update game board/state internally
6. Display board

**Out of empty squares phase:**

1. Determine win status for players (including stalemate)
2. Internally update win status for winning player or stalemate
3. Display win message or stalemate message
4. Ask if the players want to play a new game
5. Clear game state and prompt user for their first move (no exit game feature)

I will not be keeping scores across games as it is not an assignment requirement and I want to keep this in scope so I can move onto the next assignment.

**Errors or disallowed actions:**

- Re-prompt player when making selection including if invalid keys were used or if selecting non-empty spots on the board

I think that's it?

## Code design

So the point of this assignment is to get comfortable using OOP best practices / style rules. Since I'm borderline obsessed with that in the first place, I think this can be both fun and straightforward for me. I already jumped ahead with RuboCop and linters starting from my first Ruby assignment, I believe. I carried some habits over from Foundations, I had a hard time proceedign without them, but actually, I'm pretty sure I didn't.

So with my basic, rudimentary, high-level flow outlined, I can at least start thinking about classes and other objects.

In JavaScript, I used a single function to play out all my helper methods, but it looks like Ruby rules restrict methods to 4 lines of code?

This was my first instinct:

```ruby
def play_game
# below: helper methods
  # Prompt `player_1` for their move
  # Update game board/state internally
  # Display board
  # Prompt `player_2` for their move
  # Update game board/state internally
  # Display board
  # Determine win status for players (including stalemate)
  # Internally update win status for winning player or stalemate
  # Display win message or stalemate message
  # Ask if the players want to play a new game
  # Clear game state and prompt user for their first move (no exit game feature)
end

play_game

# helper functions
```

And obviously I can combine some of those methods to execute together in yet even more helper methods to reduce them, e.g. the player flows. So it would really have looked closer to this:

```ruby
def play_game
# below: helper methods
  # Player flow
  # End game flow
end

play_game

# helper functions
```

Which looks a lot cleaner. I assume that I will have each method can call another method as part of its process and keep things flowing cleanly.

### Problem: When to use classes and modules

Do I need classes? I'm not instantiating any objects here, am I? Do I need to? Why or why not? We learned about classes on our way to this assignment. I assume this means I should be using them. I'm going to assume that I can use the classes and their objects even if I only instantiate one object per class.

ref:

- [When to use a module, and when to use a class](https://stackoverflow.com/questions/2671545/when-to-use-a-module-and-when-to-use-a-class) (StackOverflow)
- [I never know when to make a class and when not to](https://www.reddit.com/r/ruby/comments/57ocod/i_never_know_when_to_make_a_class_and_when_not_to/) (r/ruby)

I like this answer:

> "Classes have state (data/values) and behavior (methods). If you find yourself wanting to make a class but it is only to hold data (state), then you should look at making a struct instead. On the other hand if you only have a group of methods (behaviors), then maybe put them in a module. When you have both, then create a class."

Other replies indicate that it's a good idea to create classes to remember states, e.g. a Game class to track things like a win condition.

And this one:

> "A class should be used for functionality that will require instantiation or that needs to keep track of state. A module can be used either as a way to mix functionality into multiple classes, or as a way to provide one-off features that don't need to be instantiated or to keep track of state. A class method could also be used for the latter.
>
> With that in mind, I think the distinction lies in whether or not you really need a class. A class method seems more appropriate when you have an existing class that needs some singleton functionality. If what you're making consists only of singleton methods, it makes more sense to implement it as a module and access it through the module directly."

**What does this look like?**
Let's see, if I wanted to create players, I could instantiate them from a `Player` class and keep track of their states, if any.

ref:

- [Ruby Class Variables](https://www.codecademy.com/learn/learn-ruby/modules/learn-ruby-object-oriented-programming-part-i-u/cheatsheet) (codeacademy)
- [Beginner's Guide to Ruby Classes (Part 1)](https://medium.com/@grahamwatson/a-beginners-guide-to-ruby-classes-f8dec30d5821) (Medium)

```ruby
class Player
  attr_reader :turn_played_this_round?

  def initialize
    @turn_played_this_round? = false #is this where I'd put this?
  end

  def prompt_for_player_move
    # ask player what their move is
    # pass answer to another method that handles this part of the game flow
  end

  def prompt_for_new_game
    # ask player if they want to play a new game
    # pass answer to another method that handles this part of the game flow
  end
end

class GameState
  attr_accessor :win_condition_met?,

  def initialize
    @win_condition_met? = false
  end
end
```

Something like that. But I'm getting ahead of myself.

I have a very basic flow worked out, but what states will I need to track?

**Potential game states:**

- Board states: empty, x's, or o's, and in which row and column
- Player moves: whose turn is it?

**Potential actions:**

- Display board: once a player completes their turn, display game board
- New game: once a player selects _new game_, clear game state

**Game board variables:**

- row1_col1, row1_col2, row1_col3, row2_col1, row2_col2, row2_col3, row3_col1, row3_col2, row3_col3, player_1, player_2, row_pipe (player_1 and player_2 will be `x` and `o` on the board)
- player_1 & player_2 turn bools

I think I'm ready to drill down to a more detailed flow.

**Expanded Play flow:**

1. Check `player_1_turn` bool. It will be true since it's a new game.
2. Prompt `player_1` for their move by offering the available spaces on the board - display all "empty" variables cleanly in prompt?
3. `player_1` submits text such as "row 1 col 1"
4. Update game state from input. Branching determines match to _game board spaces_ variable and updates it with `player_1`'s mark (`x`).
5. Display updated board by calling `display_game_board`
6. Reset `player_1_turn?` bool

7. Prompt `player_2` for their move
8. Update game board/state internally
9. Display board

**Out of empty squares phase:**

1. Determine win status for players (including stalemate)
2. Internally update win status for winning player or stalemate
3. Display win message or stalemate message
4. Ask if the players want to play a new game
5. Clear game state and prompt user for their first move (no exit game feature)

I will not be keeping scores across games as it is not an assignment requirement and I want to keep this in scope so I can move onto the next assignment.

**Errors or disallowed actions:**

- Re-prompt player when making selection including whether invalid keys were used or if selecting non-empty spots on the board

I need to code this out of my system:

```ruby
# these variables will be probably be class variables in the Game/GameBoard class or module:

# ---- player turn state ---
player_1_turn? = true #default for new game start
player_2_turn? = false #default for new game start
current_player = player_1 #default for new game start

# ---- game board "pieces" ---
player_1 = "x"
player_2 = "o"
empty_space = ' '

# ---- game board space dividers ---
row_pipe = "|"

# ---- game board spaces ---
row1_col1 = player_1 # imagine game started and player 1 made their move
row1_col2 = player_2 # imagine game started and player 2 made their move
row1_col3 = empty_space
row2_col1 = empty_space
row2_col2 = empty_space
row2_col3 = empty_space
row3_col1 = empty_space
row3_col2 = empty_space
row3_col3 = empty_space

game_board_spaces = [ # should this be a hash instead?
  row1_col1,
  row1_col2,
  row1_col3,
  row2_col1,
  row2_col2,
  row2_col3,
  row3_col1,
  row3_col2,
  row3_col3
]

# ---- player choices to display for next move ---
sel_row1_col1 = 'row 1 col 2'
sel_row1_col2 = 'row 1 col 2'
sel_row1_col3 = 'row 1 col 3'
sel_row2_col1 = 'row 2 col 1'
sel_row2_col2 = 'row 2 col 2'
sel_row2_col3 = 'row 2 col 3'
sel_row3_col1 = 'row 3 col 1'
sel_row3_col2 = 'row 3 col 2'
sel_row3_col3 = 'row 3 col 3'

player_choices = [ # should this be a hash instead?
  sel_row1_col1,
  sel_row1_col2,
  sel_row1_col3,
  sel_row2_col1,
  sel_row2_col2,
  sel_row2_col3,
  sel_row3_col1,
  sel_row3_col2,
  sel_row3_col3,
]

# ----- MAIN FUNCTION: REQUEST PLAYER MOVE ----
def prompt_player
  puts "#{current_player}, please select your move"
  puts "#{display_empty_spaces}"
  player_choice = gets.chomp
  vetted_player_choice = check_choice(player_choice)
  vetted_player_choice # e.g. returns row1_col1
end

# e.g.:
player_move = prompt_player()

# ---- HELPER FUNCTIONS: for prompt_player ---

# these will probably be Game or GameBoard class methods

def display_empty_spaces
    puts "
    #{sel_row1_col1} #{sel_row1_col2} #{sel_row1_col3} /n/n
    #{sel_row2_col1} #{sel_row2_col2} #{sel_row2_col3} /n/n
    #{sel_row3_col1} #{sel_row3_col2} #{sel_row3_col3}
    "
end

def check_choice(received_player_choice) # e.g. 'row 1 col 1'
  if player_choices.any?{ |i| i[received_player_choice] }
    validated_player_choice = find_game_board_space(received_player_choice)
    validated_player_choice # e.g. returns row1_col1
  else
    puts 'Your response was invalid. Please carefully type your choice in lowercase exactly as it is presented'
    prompt_player
  end
end

def find_game_board_space(row_and_column) # received_player_choice e.g. 'row 1 col 1'
  # find match in game_board_spaces array for validated_player_choice variable, e.g. 'row 1 col 1' will find row1_col1
  game_space = game_board_spaces.select { |space| space == row_and_column}
  return game_space
end

# ----- MAIN FUNCTION: UPDATE GAME BOARD ----

def update_game_board(validated_prompt)
  updated_value = validated_prompt
end

# e.g.:
update_game_board(player_move)


# ----- MAIN FUNCTION: END TURN FLOW ----

def end_turn()
  display_game_board()
  update_player_turn()
end

# ---- HELPER FUNCTIONS: for end_turn ---

def display_game_board
  puts "#{current_player} has selected #{player_move}"
  puts "
    #{row_pipe} #{row1_col1} #{row_pipe} #{row1_col2} #{row_pipe} #{row1_col3} #{row_pipe} /n/n
    #{row_pipe} #{row2_col1} #{row_pipe} #{row2_col2} #{row_pipe} #{row2_col3} #{row_pipe} /n/n
    #{row_pipe} #{row3_col1} #{row_pipe} #{row3_col2} #{row_pipe} #{row3_col3} #{row_pipe}
  "
end

def update_player_turn
  if player_1_turn? == true do
    player_1_turn? = false
    player_2_turn? = true
    current_player = player_2
  else
    player_2_turn? = false
    player_1_turn? = true
    current_player = player_1
  end
end

# e.g.:
end_turn()

# + + + + + + ONE TURN PROGRAM FLOW VISUALIZATION + + + + +
def play_round
  player_move = prompt_player()
  update_game_board(player_move)
  end_turn()
end

# e.g.:
play_round()
```

**desired output (untested):**

```bash
| x | o |   |

|   |   |   |

|   |   |   |
```

I think I accidentally made most of the game already. I think this speaks to how far I've come, and I now feel foolish for my performance anxiety on my last assignment.

I'm probably going to take this to my `scratch.rb` file and see if I can make it work. I still need to build out a class and figure that out, then build out the turn flow, end-game state trigger, and end game flow.

I think it might be better for me to use a hash so I can more easily translate the print-friendly variable string for the back-end's version, e.g. `'row 1 col 1'` in the console vs `row1_col1` in the code. I think my search and display options might open up for me if I do that rather than keep them all separate in dedicated arrays and have to perform different operations on them just to see if they match or to display a value to the user or use it in a helper function.

Back on the morrow!

## + + + + + DAY 2 NOTES + + + +

_Spongebob title card voice: 11 hours later..._

Good morning. Last night I had dreams about this code. I almost skipped my workout this morning to work on it.

This morning we are listening to the albums "Buzz Factory", "Uncle Anesthesia", "Dust", and "Sweet Oblivion" by the Screaming Trees, because I'm feeling nostalgic.

## Problem: Access. Should these arrays should be hashes?

I'm going to start by rethinking my arrays as previously mentioned.

The arrays in question are below.

```ruby
# ---- game board spaces ---
row1_col1 = empty_space # e.g. player_1 which is "x"
row1_col2 = empty_space # e.g. player_2 which is "o"
row1_col3 = empty_space
row2_col1 = empty_space
row2_col2 = empty_space
row2_col3 = empty_space
row3_col1 = empty_space
row3_col2 = empty_space
row3_col3 = empty_space

game_board_spaces = [
  row1_col1,
  row1_col2,
  row1_col3,
  row2_col1,
  row2_col2,
  row2_col3,
  row3_col1,
  row3_col2,
  row3_col3
]

# ---- player choices to display for next move ---
sel_row1_col1 = 'row 1 col 1'
sel_row1_col2 = 'row 1 col 2'
sel_row1_col3 = 'row 1 col 3'
sel_row2_col1 = 'row 2 col 1'
sel_row2_col2 = 'row 2 col 2'
sel_row2_col3 = 'row 2 col 3'
sel_row3_col1 = 'row 3 col 1'
sel_row3_col2 = 'row 3 col 2'
sel_row3_col3 = 'row 3 col 3'

player_choices = [
  sel_row1_col1,
  sel_row1_col2,
  sel_row1_col3,
  sel_row2_col1,
  sel_row2_col2,
  sel_row2_col3,
  sel_row3_col1,
  sel_row3_col2,
  sel_row3_col3,
]
```

Last night I was wondering if it wouldn't be easier to find, return or update values that correspond with each-other if they shared a hash rather than have separate arrays to juggle.

I was also thinking that my approach is probably inefficient. For each state, I seem to want to initialize the variables, then add them to an array. I then create equivalent ones that are intended for hte user to read, because the back-end ones are not very presentable.

What I keep mentally circling back to is, what if I just found a way to make them more appealing in the first place? Though I'm certain that front-end to back-end mechanics must be common in real life. That's why I keep going back and forth on this, and before I can write it down, I'm back thinking about hashes.

### +++ Rin's overthinking corner +++

Ultimately my overarching goal across my recent assignments since I came back from my break is, "keep it simple, in scope, and move forward" because I tend to try to make things too polished right from the start, refactoring as I go and taking so long to complete any assignment.

SO. Focusing in. Do I really need to make it pretty? Can I just put it in a make-believe roadmap to demonstrate that I've been considering it, and move on? Yes. But I can't seem to let it go. I think UX is important. Perhaps it is necessary, even though it wasn't explicitly requested in the assignment. Is it really that much more work to include a UX version of these variables?

I say nay!

Ok, so if I'm keeping, I need to draw a line in the sand and say if I can't resolve it in a reasonable amount of time, I add it to a make-believe roadmap. Fair? Fair, me? Subconscious, are you listening? I'm serious.

### Back to the hash

So I'm going to make them hashes for utility. But what should that look like?

```ruby
# reminder: player_1 = "x", player_2 = "o", empty_space = " "

# ---- game board spaces ---
game_board_spaces = {
  row1_col1 => [empty_space, player_1, player_2],
  row1_col2 => [empty_space, player_1, player_2],
  row1_col3 => [empty_space, player_1, player_2],
  row2_col1 => [empty_space, player_1, player_2],
  row2_col2 => [empty_space, player_1, player_2],
  row2_col3 => [empty_space, player_1, player_2],
  row3_col1 => [empty_space, player_1, player_2],
  row3_col2 => [empty_space, player_1, player_2],
  row3_col3 => [empty_space, player_1, player_2],
}

# ----- display choices to player ----
  sel_row1_col1 => 'row 1 col 1',
  sel_row1_col2 => 'row 1 col 2',
  sel_row1_col3 => 'row 1 col 3',
  sel_row2_col1 => 'row 2 col 1',
  sel_row2_col2 => 'row 2 col 2',
  sel_row2_col3 => 'row 2 col 3',
  sel_row3_col1 => 'row 3 col 1',
  sel_row3_col2 => 'row 3 col 2',
  sel_row3_col3 => 'row 3 col 3'
```

Wait, I'm getting ahead of myself. I went into this thinking I was going to use classes.

## Problem: Should I use classes?

What I really should be asking here is who owns the data? From there I can determine whether it should be in a class (and how), or elsewhere.

Let's think this through.

What's most on my mind is the game flow and game board. I want to figure out how I'll manage which tiles have x's and o's on them.

### Data Ownership:

_So with classes I noticed that I can keep related things together, but then it violates SoP and MCP design. Is that normal? Or do I need to refactor?_

**`Game` (module?):**

constants:  
_(unless I decide to use them in the `GameBoard` class)_

- `PLAYER_1_TILE = 'x'`
- `PLAYER_2_TILE = 'o'`
- `PLAYER_1 = 'player 1'`
- `PLAYER_2 = 'player 2'`

states:

- `player_move`
- `current_player`
- `win_condition` (three x's or three o's touching vertically or horizontally)
- `stalemate_condition` (no tiles are empty, and no win condition met)

methods:

- get player move
  - e.g. can use `player_move = PLAYER_1_TILE`
- validate player move
- **`GameBoard` (class?):**

states:

- tiles (row1_col1...row3_col3)
- tile state (`empty`, `x`, `o`)
- are there `empty` tiles left (on `0` we can trigger stalemate if no one won?)
- are there three `x`'s or three `o`'s touching diagonally or orthogonally?

methods:

- to update tiles
  - do I include the `x`'s and `o`'s in this class, or do I take them as arguments from the outside?
- to display game board?
  - do I separate this concern and handle this elsewhere?

```ruby
module Game
  #attr_accessor:

  @@PLAYER_1_TILE = 'x'
  @@PLAYER_2_TILE = 'o'
  @@PLAYER_1 = 'player 1'
  @@PLAYER_2 = 'player 2'

  @@current_player = PLAYER_1 # default for turn 1

  def display_empty_spaces
      puts "
      #{sel_row1_col1} | #{sel_row1_col2} | #{sel_row1_col3} /n/n
      #{sel_row2_col1} | #{sel_row2_col2} | #{sel_row2_col3} /n/n
      #{sel_row3_col1} | #{sel_row3_col2} | #{sel_row3_col3}
      "
  end

  def get_player_move
    puts "#{current_player}, please select your move"
    puts "#{display_empty_spaces()}"
    player_choice = gets.chomp
    vetted_player_choice = validate_player_choice(player_choice)
    vetted_player_choice # e.g. returns row1_col1
  end

  def validate_player_choice(received_player_choice) # e.g. 'row 1 col 1'
    if game_board # has an exact match for the value of received_player_choice
      validated_player_choice = game_board.find_game_board_space(received_player_choice)
      validated_player_choice # e.g. returns row1_col1
    else
      puts 'Your response was invalid. Please carefully type your choice in lowercase exactly as it is presented'
      get_player_move()
    end
  end

  def update_player_move(player_tile, the_current_player)
    player_move = current_player
  end
end

class GameBoard
  attr_accessor: @row1_col1, @row1_col2, @row1_col3, @row2_col1, @row2_col2, @row2_col3, row3_col1, @row3_col2, @row3_col3

  def initialize()

    # my original idea of having a variable for each tile just hanging out:
    @row1_col1 = nil
    @row1_col2 = nil
    @row1_col3 = nil
    @row2_col1 = nil
    @row2_col2 = nil
    @row2_col3 = nil
    @row3_col1 = nil
    @row3_col2 = nil
    @row3_col3 = nil

    # or I could use an array like this:
    game_tiles = Array.new(3) { Array.new(3) }
    # then use game_tiles[1][3] for row 1 col 3, this is what I was trying to figure out earlier.
  end

  def find_game_board_tile(player_chosen_tile)
    # find a way to identify which game_board's tile's value to update
    # return updated game_board's tile instance variable
  end

  def update_game_board(tile, player_move)
    tile = player_move # tile would hold value of @row1_col1 for example, player_move would be an x or an o
  end

  def display_game_board # is this good separation of concerns? The display vs business logic are in the same class, is that bad?
  puts "#{Game.current_player} has selected #{Game.player_move}"
  puts "
    #{row_pipe} #{row1_col1} #{row_pipe} #{row1_col2} #{row_pipe} #{row1_col3} #{row_pipe} /n/n
    #{row_pipe} #{row2_col1} #{row_pipe} #{row2_col2} #{row_pipe} #{row2_col3} #{row_pipe} /n/n
    #{row_pipe} #{row3_col1} #{row_pipe} #{row3_col2} #{row_pipe} #{row3_col3} #{row_pipe}
  "
  end
end


  game_board = GameBoard.new

  vetted_player_move = Game.get_player_move # e.g. returns col1_row1
  game_board.update_game_board(player_tile, vetted_player_move)


```

Something like that, right?

I'm a little lost. I know I'm doing this wrong, but I still think I should do something with classes or I'll never learn. Already I know I'm not separating concerns like the pros. I think I've been hacking away at this without really trying to solve the problem first. I should take this to pen and paper and draw a process map or something.

(...)

## DAY 3 NOTES

I guess my day got away from me yesterday.

This morning I'm listening to the albums "Restless Youth", "Lonely Sand Dune", and "Klipsan Hideaway" by The Groovy Nobody.

### Problem: How to manage state and game flow

I have decided since this is my first assignment after learning about classes, I'm going to use a class or module to solve some problems, as I think that's the point. To keep it simple, I'm going to try to see if I can fit the whole thing in one class, and refactor if it make sense to.

It also occurred to me that I can create this in a class without actually needing to save the created object anywhere. So I don't for example need to do `game_1 = Game.new`, I can just use `Game.new`, let it exist in space. I think I can chain it too, so that it kicks off the method I want right away, so it could look like `Game.new.play_turn` (or to make it look pretty, I could just call it `play`).

As I mentioned yesterday, I've been thinking way too procedurally. I need to think about what messages need to be passed, and who owns what.

so it would be like:

```
CLASS Game
  CONSTANTS (if needed)

  (no accessors probably, I'm not making objects)

  INSTANTIATE
    LOCAL VARIABLES = DEFAULT VALUES (for turn 1)

  INSTANTIATE END

  METHOD (thing that needs to happen)

  METHOD END

CLASS END
```

Things that need to happen, eh?

So the states and behaviours should probably be broken down.

**We have:**

- Game board tiles that start empty but get updated once per turn by players
- `player_1` is an `x`, 'player 2' is an `o`
- Display available tiles on the game board for players to select from
- Turns for the players to take
- Display the game board to players after each turn
- Game to end on win condition or stalemate
- Display message on win or stalemate
- Game board tiles win and stalemate condition logic (which I haven't even begun to think about)
- Option for players to start a new game or exit terminal
- Clear game state and start new game if players want to start a new game

So looking this over, I can start to see what is what.

**We have constants/symbols:**

- `player_1_tile` is an `x` (for game board display)
- `player_2_tile` is an `o` (for game goard display)
- `empty` game board tiles are `" "` (for game board display)

**We have states:**

- Game board tiles (empty, `x`, or `o`)
- Whose turn it is
- Win condition met
- Stalemate condition met

**We have behaviours:**

- New game start on program run
- Prompt user for tile choice on their turn
  - Display game board (so they can visualize their options)
  - Display `empty_tiles` array that the user can select from
- Display winning player on game end (or stalemate)
- Prompt user for new game after game ends
- New game start or exit terminal on game end based on user selection

**We have logic:**

- Logic for game board tile selection
- Validate user input against available (empty) tiles
  - valid: can update tile
  - invalid: clarify ask, then return to tile selection prompt
- Find tile based on user input
  - in array? e.g. `col 1 row 1` would match to `tiles[0][0]`
  - update tile from empty to user's symbol (e.g. from `" "` to `"x"` in to display board)
  - update available tiles
- Update tile with user's symbol (`x` or `o`)
- Remove updated tile from `empty_tiles` array once it is updated to `x` or `o`
- Win condition
  - magic box, I haven't thought about this yet. Three `x`s or `o`s must appear in a row or as an x in the grid. I guess I can figure out what that would look like visually and map out the array matrix over them, and store the possible arrangements in an array, but that seems tedious. I imagine there might be a mathematical formula I can use or some other more elegantn solution.
- Stalemate condition
  - magic box solution where all possible paths for win condition are exhausted and not met. My 'simple' condition is that all spaces have been filled with `x`s and `o`s but no win condition was met (which would be annoying for players to have to play out once they realize no one can win)
- Logic for game end options

That's all the time I have for today! I'll be back on Day 4 and hopefully finish this off and then I can start coding it up in Scratch.

Today I also _finally_ mapped out a process map of the game flow on paper which really helped me identify areas I hadn't considered yet. I made a simple one, then went deeper on each point.

I will have less time tomorrow because of obligations, so I wish I hadn't wasted so much time on on days 1 and 2 imagining what the code might look like. I really botched my time management on this assignment because I didn't start on paper like I usually do.

Pain points: I didn't "think like a programmer" from the start. Instead, I started in the middle and confused myself, creating mental rework. Lesson learned.
