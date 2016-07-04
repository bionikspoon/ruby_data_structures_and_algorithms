DIM_X, DIM_Y = [(0..7).to_a] * 2
NAME = Hash[DIM_Y.product(DIM_X).collect { |y, x| [[y, x], ('A'.upto('H').to_a[x] + 8.downto(1).to_a[y].to_s).to_sym] }]

def TO_NAME(y, x)
  NAME[[y, x]]
end

class Board
  attr_reader :cells

  def initialize
    @cells = NAME.keys.collect do |y, x|
      Cell.new y: y, x: x
    end

    @cells.each do |cell|
      adjacent_cells = { 'up=': [cell.y - 1, cell.x],
                         'right=': [cell.y, cell.x + 1],
                         'down=': [cell.y + 1, cell.x],
                         'left=': [cell.y, cell.x - 1], }
      adjacent_cells
          .collect { |k, v| [k, TO_NAME(*v)] }
          .reject { |_, v| v.nil? }
          .collect { |k, v| [k, @cells.find { |c| c.name == v }] }
          .each { |k, v| cell.send(k, v) }

    end
  end
end

class Cell
  attr_reader :name, :x, :y
  attr_accessor :value, :up, :down, :left, :right

  def initialize(y: nil, x: nil, name: nil, value: nil)
    @y = y
    @x = x
    @value = value
    @name = name || TO_NAME(@y, @x)
    @up, @right, @down, @left = [nil]*4
  end

  def inspect
    s = []
    s << "*: #{to_s}"
    s << "u: #{@up.to_s}" if @up
    s << "r: #{@right.to_s}" if @right
    s << "d: #{@down.to_s}" if @down
    s << "l: #{@left.to_s}" if @left
    "{#{s.join(', ')}}"
  end

  def to_s
    value = @value ? ":{#{@value}" : nil
    "<#{@name}#{value}>"
  end
end