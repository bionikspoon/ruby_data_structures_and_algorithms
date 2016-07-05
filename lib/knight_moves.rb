module Chess
  DIM_X, DIM_Y = [(0..7).to_a] * 2
  NAME = Hash[DIM_Y.product(DIM_X).collect { |y, x| [[y, x], ('A'.upto('H').to_a[x] + 8.downto(1).to_a[y].to_s).to_sym] }]

  def to_name(y, x)
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
            .collect { |k, v| [k, to_name(*v)] }
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
      @name = name || to_name(@y, @x)
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
end


module BinaryTree
  class Node
    include Enumerable

    attr_accessor :right, :value, :up, :left

    def initialize(value=nil, up: nil, left: nil, right: nil)
      @value = value
      @up = up || EmptyNode.new
      @left = left || EmptyNode.new
      @right = right || EmptyNode.new
    end

    def each
      return enum_for :each unless block_given?

      left.each { |node| yield node }
      yield value
      right.each { |node| yield node }
    end

    def insert value, up: nil
      up ||= self.class.new up

      unless up?
        @value = value
        @up = up
        return self
      end

      case self.value <=> value
        when -1 then
          insert_right(value)
        else
          insert_left(value)
      end

      self.up || self
    end

    def each_node
      return enum_for :each_node unless block_given?

      left.each_node { |node| yield node }
      yield self
      right.each_node { |node| yield node }
    end

    def nodes
      each_node.to_a
    end

    def <=> other
      [value, up] <=> [other.value, other.up]
    end

    def inspect
      "{Node:#{@value}:#{@left.inspect}:#{@right.inspect}:#{@up.inspect}}"
    end

    def to_s
      "{Node:#{value}:#{@left.value}:#{@right.value}:#{@up.value}}"
    end

    protected
    def insert_left(value)
      left.insert(value) or self.left = Node.new(value, up: self)
    end

    def insert_right(value)
      right.insert(value) or self.right = Node.new(value, up: self)
    end

    def is_leaf?
      !(left? or right?)
    end

    def up?
      up.is_a? self.class
    end

    def left?
      left.is_a? self.class
    end

    def right?
      right.is_a? self.class
    end

  end
  class EmptyNode
    include Enumerable

    attr_reader :right, :value, :left, :up

    def initialize(*)
      @value = nil
      @left = self
      @right = self
      @up = self
    end

    def each
      enum_for :each unless block_given?
    end

    def each_node
      enum_for :each_node unless block_given?
    end

    def insert(*)
      false
    end

    def up?
      false
    end

    def left?
      false
    end

    def right?
      false
    end

    def inspect
      "{#{self.class}}"
    end

    def to_s
      inspect
    end
  end
end