require './cell'

class Pattern

  # Set the pattern for Conway'game of life

  def initialize(opts = {})
    @width  = opts[:width]  || 15
    @height = opts[:height] || 30

    # print the pattern
    get_pattern!
    # define live cells over the pattern
    get_live_cells(opts[:with_alive]) if opts[:with_alive]

  end

   # Get a pattern of cells
  def get_pattern!
    @grid = Array.new(@height) do |i|
      Array.new(@width) do |j|
        Cell.new(i-1, j-1)
      end
    end
  end

  # Get cells flatten
  def cells
    @cells ||= @grid.flatten
  end

  # Take into account a cell for given coordinates
  def cell(x, y)
    @grid[x][y]
  end

  # Turn cells to be alive for given coordinates
  def get_live_cells(coordinates = [])
    coordinates.each do |x, y|
      cell(x, y).life!
    end
  end

  # Given a M x N pattern, we seed a random amount of live cells
  def seed!
    Random.rand(@width * @height).times do
      cells.sample.life!
    end
  end

  # Insert an imported initial state
  def get_input_state
    get_pattern!
    get_live_cells([[1, 2], [1, 1]]) #!!!! PERCHE' [1, 2] NON APPARE NELLA GRIGLIA INIZIALE???
    #get_live_cells([[1, 2], [1, 3], [2, 2], [2, 3]])
    #get_live_cells([[2, 1], [2, 2], [2, 3]])
  end

  # Generates the new pattern with live cells.
  def set_new_generation
    self.class.new(:height => @height, :width => @width,
      :with_alive => new_live_cell_positions)
  end

  # Print the resulted pattern
  def get_visualization
    #system("clear")
    @grid.each do |row|
      putc "|"
      putc " "
      row.each do |cell|
        putc cell.to_s
        putc " "
      end
      putc "|"
      putc "\n"
    end
    puts
  end

  # Returns the array of coordinates for live cells in the next generation
  def new_live_cell_positions
    # cells.map do |cell|
    #   print cell.coordinates
    #   print cell.x
    #   print cell.y
    # end
    # exit
    cells.map do |cell|
      count = get_neighbours(cell)
      #puts cell if cell.x == 1 && cell.y == 1
      if cell.alive?
        #next if cell.x == 1 && cell.y == 1
        cell.coordinates if count == 2 || count == 3
      else
        cell.coordinates if count == 3
      end
    end.compact
  end

  # Get the number of neighbours for every cell of the pattern
  def get_neighbours(cell)
    # ------------------
    # The eight neighbours are around the selected cell at position (i, j)
    # |(i-1, j-1) (i-1, j) (i-1, j+1)|
    # |(i, j-1) (i, j) (i, j+1)|
    # |(i+1, j-1) (i+1, j) (i+1, j+1)|
    # For M x N pattern, periodic boundary conditions are deployed along both axis so as cell at (1, 1) can "hear" cells
    # from opposite sides i.e. at (1, N), (2, N), (M, 1), (M, 2), (M, N)
    # ------------------
    count = 0

    ((cell.x - 1)..(cell.x + 1)).each do |i|
      ((cell.y - 1)..(cell.y + 1)).each do |j|
        count +=1 if !cell.at?(i, j)  && cell(i, j).alive?
      end
    end

    count
  end

end