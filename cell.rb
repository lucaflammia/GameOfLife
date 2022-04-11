class Cell
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @alive = false
  end

  def original_coordinates
    [x+1, y+1]
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
  def life!
    @alive = true
  end

  # If the cell is printed, return a character. Live cell (*) - dead cell (.)
  def to_s
    alive? ? "\u{002A}" : "\u{002E}"
  end
end