# frozen_string_literal: true
require 'singleton'

# Chess Board and components
module Chess
  # Map Board Cells to Cell Name
  class Name
    include Singleton
    class << self
      DELTA = { up: [-1, 0],
                right: [0, 1],
                down: [1, 0],
                left: [0, -1] }.freeze

      def init
        size = (0..7).to_a
        col_names = 'A'.upto('H').to_a
        row_names = 8.downto(1).to_a.map(&:to_s)

        @@hash = Hash[size.product(size).collect { |y, x| [[y, x], (col_names[x] + row_names[y]).to_sym] }]
      end

      def includes?(k)
        @@hash.key?(k)
      end

      def each
        @@hash.each_key
      end

      def get(y, x)
        @@hash[[y, x]]
      end

      def adjacent(cell_y, cell_x)
        DELTA
          .collect { |k, (y, x)| [k, get(y + cell_y, x + cell_x)] }
          .reject { |_, v| v.nil? }
          .collect { |k, name| [k, block_given? ? yield(name) : name] }
          .to_h
      end
    end
    init
  end

  # Chess Board model
  class Board
    attr_reader :cells

    def initialize
      super
      self.cells = Name.each.collect { |y, x| Cell.new y: y, x: x }
    end

    def get(y: nil, x: nil, name: nil)
      name = Name.get(y, x) if name.nil?
      return false if name.nil?
      @cells.find { |cell| cell.name == name }
    end

    protected

    def cells=(cells)
      @cells = cells
      @cells.each(&:link.with(self))

      # @cells.each do |cell|
      #   Name
      #     .adjacent(cell.y, cell.x) { |name| get(name: name) }
      #     .each { |args| cell.link(*args) }
      # end
      # @cells
      #   .collect { |cell| [cell, Name.adjacent(cell.y, cell.x)] }
      #   .collect do |cell, moves|
      #   moves.collect { |direction, name| [direction, get(name: name)] }
      #     .tap { |all| puts all.to_s }
      #   [cell, moves.map { |move| get(name: move) }]
      # end
      # # .tap { |all| puts all.collect(&:to_s) }
    end
  end

  # EmptyCell placeholder
  class EmptyCell
    include Singleton
    class << self
      attr_reader :value

      def name
        :**
      end

      def to_s
        '{**}'
      end

      alias inspect to_s
    end
    instance
  end

  # Each Cell of Chess Board
  class Cell
    attr_reader :name, :x, :y, :up, :down, :left, :right
    attr_accessor :value

    DELTA = [[:@up, [-1, 0]],
             [:@right, [0, 1]],
             [:@down, [1, 0]],
             [:@left, [0, -1]]].freeze

    def initialize(y: nil, x: nil, name: nil, value: nil)
      @y = y
      @x = x
      @value = value
      @name = name || Name.get(@y, @x)
      @up, @right, @down, @left = [EmptyCell] * 4
    end

    # def link(direction, cell)
    #   puts :a + :b
    # end

    def link(board)
      return false if [@up, @right, @down, @left].any?(&:value)
      DELTA
        .map { |ref, (y, x)| [ref, [@y + y, @x + x]] }
        .map { |ref, (y, x)| [ref, board.get(y: y, x: x) || nil] }
        .reject { |_, cell| cell.nil? }
        .map { |ref, cell| instance_variable_set(ref, cell) }
    end

    def to_s
      "{#{[@name, @value].compact.join(':')}}"
    end

    alias inspect to_s
  end
end

# Binary Tree data structure
module BinaryTree
  # Node Stub
  class EmptyNode
    include Singleton
    class << self
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
    initialize
  end

  # BinaryTree Node object
  class Node
    include Enumerable

    attr_accessor :value
    attr_reader :left, :right

    def initialize(value = nil)
      @value = value
      @left = EmptyNode
      @right = EmptyNode
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
      return false if @value == v

      if @value.nil?
        @value = v
      elsif @value < v
        push_right(v)
      else
        push_left(v)
      end

      self
    end

    alias << push

    def include?(value)
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

# Patch Symbol
class Symbol
  # Source: https://stackoverflow.com/questions/23695653/can-you-supply-arguments-to-the-mapmethod-syntax-in-ruby
  def with(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end
end
