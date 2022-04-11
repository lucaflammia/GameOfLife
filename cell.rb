class Cell
  # Cell definition 
  # Live or dead cells to be assessed
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @alive = false
  end

  def coordinates
    [x, y]
  end

  def at?(at_x, at_y)
    x == at_x && y == at_y
  end

  # Checks if the cell is alive.
  def alive?
    @alive == true
  end

  # Set the selected cell as alive.
  def alive!
    @alive = true
  end

  # If the cell is printed, return a character. Live cell (*) - Dead cell (.)
  def to_s
    alive? ? "\u{002A}" : "\u{002E}"
  end

end