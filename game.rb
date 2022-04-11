require './grid'

# Conway's game of life 
# User can select (width, height) of the grid and the initial pattern of live cells

# Es. 3 x 3 grid the cell coordinates are denoted as follows
# | (0, 0) (0, 1) (0, 2) |
# | (1, 0) (1, 1) (1, 2) |
# | (2, 0) (2, 1) (2, 2) |

class Game
  def initialize(height = 15, width = 30, live_cells=[])
    @grid = Grid.new(:height => height, :width => width, :live_cells => live_cells)
  end

  # Run the game
  def run!
    i = 1
    while true
      @grid.get_visualization(i)
      @grid = @grid.set_new_generation
      sleep 2.1
      i +=1
    end
  end
end

def incorrect_value(input)
  puts 'Incorrect choice. Exit' if input < 5
  exit if input < 5
end

puts "Conway's Game of Life"
puts "\n"
puts 'Select the width of the grid +++ width >= 5 +++'
w = gets.chomp.to_i

incorrect_value(w)

puts "\n"
puts 'Select the height of the grid +++ height >= 5 +++'
h = gets.chomp.to_i

incorrect_value(h)

puts 'Select the figure you want to play'
puts "\n"
puts '1.- Blinker 2.- Glider '
puts "\n"

Thread.new do
  loop do
    exit if gets.chomp.casecmp('q').zero?
  end
end

# glider = [[0, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
# foo = [[0, 2], [1, 2], [1, 3], [1, 1]]
# Game.new(w, h, foo).run!

loop do
  puts '< press enter and select >'
  figure = gets.chomp.to_i
  case figure
  when 1
    blinker = [[2, 1], [2, 2], [2, 3]]
    Game.new(w, h, blinker).run!
  break
  when 2
    glider = [[0, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
    Game.new(w, h, glider).run!
    break
  else
    puts 'Incorrect choice'
  end
end