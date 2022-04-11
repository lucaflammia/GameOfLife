require './cell'

class Grid

  # Set the grid for Conway'game of life

  # Es. 3 x 3 grid 
  # cell coordinates are denoted as follows

  # | (0, 0) (0, 1) (0, 2) |
  # | (1, 0) (1, 1) (1, 2) |
  # | (2, 0) (2, 1) (2, 2) |

  def initialize(opts = {})
    @width  = opts[:width] 
    @height = opts[:height]

    # let's draw the grid
    draw_grid!
    # define live cells over the grid
    get_live_cells(opts[:live_cells]) if opts[:live_cells]

  end

   # Get a pattern of cells
  def draw_grid!
    @grid = Array.new(@height) do |i|
      Array.new(@width) do |j|
        Cell.new(i, j)
      end
    end
  end

  # Get grid flatten
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

  # Insert an imported initial state
  def get_initial_state(istate)
    get_live_cells(istate) 
  end

  # Generates the new grid with live cells.
  def set_new_generation
    self.class.new(:height => @height, :width => @width,
      :live_cells => new_live_cell_positions)
  end

  # Print the resulted grid
  def get_visualization(iteration=0)
    system("clear")
    puts "#{@width} X #{@height} GRID"
    putc "\n"
    putc "\n"
    print "--- GENERATION #{iteration} ---"
    putc "\n"
    putc "\n"
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
    puts 'press "q<Enter>" to exit'
  end

  # Returns the array of coordinates for live cells in the next generation according to Conway's Game of Live rules
  def new_live_cell_positions
    cells.map do |cell|
      count = get_neighbours(cell)
      if cell.alive?
        cell.coordinates if count == 2 || count == 3
      else
        cell.coordinates if count == 3
      end
    end.compact
  end

  # Get the number of neighbours for every cell of the grid
  def get_neighbours(cell)
    # ------------------
    # In general, the eight neighbours are around the selected cell at position (i, j) as follows

    # |  + ----      +         +         +     ---- + |
    # |  + ---- (i-1, j-1) (i-1, j) (i-1, j+1) ---- + |
    # |  + ---- (i, j-1)   (i, j)    (i, j+1)  ---- + |
    # |  + ---- (i+1, j-1) (i+1, j) (i+1, j+1) ---- + |
    # |  + ----      +         +         +     ---- + |

    # where cells at the boundaries are denoted with "+"
    # Index i runs over the y axis
    # Index j runs over the x axis
    # ------------------
    count = 0

    ((cell.x - 1)..(cell.x + 1)).each do |i|
      ((cell.y - 1)..(cell.y + 1)).each do |j|

        # since i(j) runs from -1 to width(height) we ignore to count the same index twice (-1 means the last index of the array) 
        # we skip the count evaluation for i = width 
        next if i == @width
        # we skip the count evaluation for j = height 
        next if j == @height

        # we add one unit to the neighbour evaluation when live cells around at the selected one at (i, j) are present
        count +=1 if !cell.at?(i, j)  && cell(i, j).alive?
      end
    end

    count
  end

end