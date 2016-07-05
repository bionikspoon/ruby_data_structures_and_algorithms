# frozen_string_literal: true
module Chess
  DIM_X, DIM_Y = [(0..7).to_a] * 2
  NAME = Hash[DIM_Y.product(DIM_X).collect { |y, x| [[y, x], ('A'.upto('H').to_a[x] + 8.downto(1).to_a[y].to_s).to_sym] }]

  def self.to_name(y, x)
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
                           'left=': [cell.y, cell.x - 1] }
        adjacent_cells
          .collect { |k, v| [k, Chess.to_name(*v)] }
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
      @name = name || Chess.to_name(@y, @x)
      @up, @right, @down, @left = [nil] * 4
    end

    def inspect
      s = []
      s << "*: #{self}"
      s << "u: #{@up}" if @up
      s << "r: #{@right}" if @right
      s << "d: #{@down}" if @down
      s << "l: #{@left}" if @left
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

    attr_reader :right, :value, :left

    def initialize(*)
      @value = nil
      @left = self
      @right = self
    end

    def to_a
      []
    end

    def push(*)
      false
    end

    alias << push

    def each
    end

    def each_node
    end

    def include?(*)
      false
    end

    def inspect
      '{#}'
    end

    def to_s
      inspect
    end

    def leaf?
      nil
    end
  end

  EMPTY_NODE = EmptyNode.new

  class Node
    include Enumerable

    attr_accessor :right, :value, :left

    def initialize(value = nil, left: BinaryTree::EMPTY_NODE, right: BinaryTree::EMPTY_NODE)
      @value = value
      @left = left
      @right = right
    end

    def each
      return enum_for :each unless block_given?

      each_node do |node|
        yield node.value
      end
    end

    def to_a
      left.to_a + [@value] + right.to_a
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

    def push(v)
      if @value.nil?
        @value = v
        return self
      end
      # noinspection RubyCaseWithoutElseBlockInspection
      case value <=> v
      when -1 then
        push_right(v)
      when 1 then
        push_left(v)
      when 0 then
        false
      end
      self
    end

    alias << push

    def include?(value)
      # noinspection RubyCaseWithoutElseBlockInspection
      case @value <=> value
      when -1 then
        right.include?(value)
      when 1 then
        left.include?(value)
      when 0 then
        true
      end
    end

    def <=>(other)
      @value <=> other.value
    end

    def inspect
      "{Node:#{@value}:#{@left.inspect}:#{@right.inspect}}"
    end

    def to_s
      "{Node:#{value}:#{@left.value}:#{@right.value}}"
    end

    protected

    def push_left(v)
      @left.push(v) || (@left = Node.new(v))
      self
    end

    def push_right(v)
      @right.push(v) || (@right = Node.new(v))
      self
    end

    def leaf?
      @left.value.nil? || @right.value.nil?
    end
  end

  def self.factory(items, shuffle: true)
    tree = Node.new
    (shuffle ? items.to_a.shuffle : items).each do |item|
      tree << item
    end
    tree
  end
end
