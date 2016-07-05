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

  class EmptyNode
    include Enumerable

    attr_reader :right, :value, :left, :up

    def initialize(*)
      @value = nil
      @left = self
      @right = self
      @up = self
    end

    def to_a
      []
    end

    def push(*)
      false
    end

    alias_method :<<, :push

    def each
      enum_for :each if block_given?
    end

    def each_node
      enum_for :each_node if block_given?
    end

    def include?(*)
      false
    end

    def inspect
      "{#{self.class}}"
    end

    def to_s
      inspect
    end
  end

  EMPTY_NODE = EmptyNode.new

  class Node
    include Enumerable

    attr_accessor :right, :value, :up, :left

    def initialize(value=nil, up: BinaryTree::EMPTY_NODE, left: BinaryTree::EMPTY_NODE, right: BinaryTree::EMPTY_NODE)
      @value = value
      @up = up
      @left = left
      @right = right
    end

    def each
      return enum_for :each unless block_given?

      self.each_node do |node|
        yield node.value
      end
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

    def push(value)
      if @up.nil?
        @value = value
        return self
      end

      case self.value <=> value
        when -1 then
          self.push_right(value)
        else
          self.push_left(value)
      end
      self
    end

    alias_method :<<, :push

    def include?(value)
      case @value <=> value
        when -1 then
          right.include?(value)
        when 1 then
          left.include?(value)
        when 0 then
          true
        else
          false
      end
    end

    def <=>(other)
      [@value, @up] <=> [other.value, other.up]
    end

    def inspect
      "{Node:#{@value}:#{@left.inspect}:#{@right.inspect}:#{@up.inspect}}"
    end

    def to_s
      "{Node:#{value}:#{@left.value}:#{@right.value}"
    end

    protected
    def push_left(v)
      @left.push(v) || (@left = Node.new(v, up: self))
      self.up || self
    end

    def push_right(v)
      @right.push(v) || (@right = Node.new(v, up: self))
      self.up || self
    end

    def is_leaf?
      @left.value.nil? or @right.value.nil?
    end
  end
end