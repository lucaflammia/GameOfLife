require './cell'

class Pattern

  # Set the pattern for Conway'game of life

  def initialize(opts = {})
    @width  = opts[:width] 
    @height = opts[:height]

    # print the pattern
    draw_grid!
    # define live cells over the pattern
    get_live_cells(opts[:with_alive]) if opts[:with_alive]

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

  # Given a M x N pattern, we seed a random amount of live cells
  def seed!
    Random.rand(@width * @height).times do
      cells.sample.life!
    end
  end

  # Insert an imported initial state
  def get_input_state
    draw_grid!
    get_live_cells([[1, 1], [1, 2], [1, 3]]) 
  end

  # Generates the new pattern with live cells.
  def set_new_generation
    self.class.new(:height => @height, :width => @width,
      :with_alive => new_live_cell_positions)
  end

  # Print the resulted pattern
  def get_visualization(iteration=0)
    system("clear")
    print "Game of Life"
    putc "\n"
    putc "\n"
    print "#{@width} X #{@height} grid --- GENERATION #{iteration}"
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
  end

  # Returns the array of coordinates for live cells in the next generation
  def new_live_cell_positions
    # update the 
    cells.map do |cell|
      count = get_neighbours(cell)
      if cell.alive?
        cell.coordinates if count == 2 || count == 3
      else
        cell.coordinates if count == 3
      end
    end.compact
  end

  # Get the number of neighbours for every cell of the pattern
  def get_neighbours(cell)
    # ------------------

    # For a M x N grid, cells at the boudaries (i.e. cell(0,:), cell(M, :), cell(:, 0), cell(:, N)) 
    # are neglected when it comes to count neighbours
    # The eight neighbours around the selected central cell at position (i, j)
    # are described in terms of coordinates as follows 

    # |  + ----      +         +         +     ---- + |
    # |  + ---- (i-1, j-1) (i-1, j) (i-1, j+1) ---- + |
    # |  + ---- (i, j-1)   (i, j)    (i, j+1)  ---- + |
    # |  + ---- (i+1, j-1) (i+1, j) (i+1, j+1) ---- + |
    # |  + ----      +         +         +     ---- + |
    
    # where cells at the boundaries are denoted with "+"
    # ------------------
    count = 0

    ((cell.x - 1)..(cell.x + 1)).each do |i|
      ((cell.y - 1)..(cell.y + 1)).each do |j|
        next if i == @width
        next if j == @height
        count +=1 if !cell.at?(i, j)  && cell(i, j).alive?
      end
    end

    count
  end

end