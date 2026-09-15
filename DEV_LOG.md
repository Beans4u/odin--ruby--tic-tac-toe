# Dev Log: Tic Tac Toe

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
- **Potential actions:**

- Display board: once a player completes their turn, display game board
- New game: once a player selects _new game_, clear game state
- **Game board variables:**

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

- Re-prompt player when making selection including if invalid keys were used or if selecting non-empty spots on the board

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

# ---- player choices for next move ---
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

# ---- dividers ---
row_pipe = "|"

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
