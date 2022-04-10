require './pattern'

# Conway's game of life Width x Height pattern with input state defined by the user.

# Es. 3x3 pattern coordinates
# | (0, 0) (0, 1) (0, 2) |
# | (1, 0) (1, 1) (1, 2) |
# | (2, 0) (2, 1) (2, 2) |

class Game
  def initialize(height = 15, width = 30)
    @pattern = Pattern.new(:height => height, :width => width)
    @pattern.get_input_state
  end

  # Run the game.
  def run!
    i = 1
    while true
      @pattern.get_visualization(i)
      @pattern = @pattern.set_new_generation
      sleep 2.1
      i +=1
    end
  end
end