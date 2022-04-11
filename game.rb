require './board'

# Conway's game of life 

# Users can either insert input parameters (i.e. width, height of the grid and the initial pattern of live cells)
# or they can upload an input file 

class Game
  def initialize(height = 15, width = 30, live_cells=[])
    @board = Board.new(:height => height, :width => width, :live_cells => live_cells)
  end

  # Run the game
  def run!
    i = 1
    while true
      @board.get_visualization(i)
      @board = @board.set_new_generation
      sleep 2.1
      i +=1
    end
  end
end

def incorrect_value(input)
  puts 'Incorrect choice. Exit' if input < 5
  exit if input < 5
end

# start message

puts "Conway's Game of Life"

puts "\n"
puts 'Please choose how to draw the grid'
puts "\n"
puts '1.- input parameters 2.- input file'

type = gets.chomp.to_i
case type

# input parameters
when 1
  puts "\n"
  puts 'Select the height of the grid +++ height >= 5 +++'
  height = gets.chomp.to_i

  incorrect_value(height)

  puts "\n"
  puts 'Select the width of the grid +++ width >= 5 +++'
  width = gets.chomp.to_i

  incorrect_value(width)

  puts 'Select the figure you want to play'
  puts "\n"
  puts '1.- Blinker 2.- Glider 3.- Random'

  loop do
    figure = gets.chomp.to_i
    case figure
    when 1
      blinker = [[2, 1], [2, 2], [2, 3]]
      Game.new(height, width, blinker).run!
    break
    when 2
      glider = [[0, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
      Game.new(height, width, glider).run!
      break
    when 3
      Game.new(height, width).run!
    else
      puts 'Incorrect choice'
    end
  end

# Upload an input file
when 2
  INPUT = './input.txt'
  input_state = File.readlines(INPUT).map { |l| l.split("\n") }
  
  totcells = 0
  nrow = 0

  # get number of rows and the total number of cells
  input_state.map do |row|
    nrow +=1
    row.each do |col|
      col.gsub(".") { |a| totcells+=1; "" }
      col.gsub("*") { |a| totcells+=1; "" }
    end
  end

  # number of row = height
  # number of columns = width = total of cells / number of row

  # ---- TO UPDATE ----
  # At the moment we need to insert manually the live cells list (3rd argument)
  Game.new(nrow, totcells / nrow, [[1, 3], [2, 2], [2, 3]]).run!
  # ---- NEXT SOLUTION ---
  # To find a solution in order to detect live cells from the imported file

end