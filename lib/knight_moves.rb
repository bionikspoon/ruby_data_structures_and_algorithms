# frozen_string_literal: true
require 'singleton'
# Chess Board and components
module Chess
  # Map Board Cells to Cell Name
  class Name
    include Singleton
    class << self
      def init
        size = (0..7).to_a
        col_names = 'A'.upto('H').to_a
        row_names = 8.downto(1).to_a.map(&:to_s)

        @@hash = Hash[size.product(size).map { |y, x| [[y, x], (col_names[x] + row_names[y]).to_sym] }]
      end

      def includes?(k)
        @@hash.key?(k)
      end

      def each
        @@hash.each
      end

      def get(y, x)
        @@hash[[y, x]]
      end
    end
    init
  end

  # Chess Board model
  class Board
    attr_reader :cells
    DELTA = { up: { y: -1 }, right: { x: 1 }, down: { y: -1 }, left: { x: -1 } }.freeze

    def initialize
      super

      @cells = Name.each.map { |(y, x), _name| Cell.new(y: y, x: x) }.to_bin
      link_cells
    end

    def get(y: nil, x: nil, name: nil)
      name = Name.get(y, x) if name.nil?
      return false if name.nil?
      @cells.find { |cell| cell.name == name }
    end

    def find
      @cells.find { |cell| yield cell }
    end

    def set(name, value = nil)
      cell = get(name: name)
      cell.value = value
    end

    def delta(cell, y: 0, x: 0, sym: nil)
      return delta(cell, **DELTA[sym]) if sym
      get(y: cell.y + y, x: cell.x + x) || EmptyCell
    end

    protected

    def link_cells
      # for each current ...
      @cells.each do |cell|
        # create a k,v hash where key = direction, value = adjacent current
        DELTA
          .each_key.map { |sym| [sym, delta(cell, sym: sym)] }.to_h
          .tap { |links| cell.set links } # and pass the results to current.set
      end
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

    def initialize(y: nil, x: nil, name: nil, value: nil)
      @y = y
      @x = x
      @value = value
      @name = name || Name.get(@y, @x)
      @up, @right, @down, @left = [EmptyCell] * 4
    end

    def set(up: EmptyCell, right: EmptyCell, down: EmptyCell, left: EmptyCell)
      return unless [@up, @down, @left, @right].all? { |cell| cell == EmptyCell }

      @up = up
      @right = right
      @down = down
      @left = left
    end

    def to_s
      "{#{[@name, @value].compact.join(':')}}"
    end

    alias inspect to_s

    def <=>(other)
      @name <=> other.name
    end
  end

  # Chess Piece Base
  class Piece
  end

  # Chess Piece :: Knight
  class Knight < Piece
    attr_reader :name

    def initialize(board)
      @board = board
      @name = :N
    end

    def cell
      @board.find { |cell| cell.value === self }
    end

    def move(to, force: false)
      return false unless force || possible_moves.map(&:name).include?(to)

      @board.set(cell.name)
      @board.set(to, self)
      true
    end

    def possible_moves
      cell = self.cell
      [[1, -2], [-1, -2], [2, -1], [-2, -1], [2, 1], [-2, 1], [1, 2], [-1, 2]]
        .map { |y, x| @board.delta cell, y: y, x: x }
        .reject { |c| c.name === :** }
    end
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

      def size
        0
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
      elsif (@value <=> v) < 0
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

    def size
      left.size + (@value.nil? ? 0 : 1) + right.size
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

# Patch Enumerable with #to_bin
module Enumerable
  def to_bin
    tree = BinaryTree::Node.new
    each { |item| tree << item }
    tree
  end
end

# Collection of search classes
module Search
  # Breadth first search base class
  class BreadthFirst
    attr_writer :set_current, :adjacent

    def initialize
      @q = Queue.new
      @path = Hash.new { |h, k| h[k] = [] }
      @set_current = ->(_) {}
      @adjacent = -> {}
    end

    def path(from, to)
      enqueue from
      until @q.empty?
        current = dequeue.tap { |c| @set_current.call(c) }

        @adjacent.call.select(&method(:untouched)).each { |node| enqueue node, current }
      end

      @path[to]
    end

    def untouched(node)
      @path[node].empty?
    end

    def dequeue
      @q.deq
    end

    def enqueue(node, current = nil)
      @q.enq(node)
      @path[node] += (@path[current] || []) + [node]
    end
  end

  # Search Knight's moves
  class KnightMoves < BreadthFirst
    def initialize
      super

      @board = Chess::Board.new
      @knight = Chess::Knight.new @board

      @set_current = ->(current) { @knight.move(current, force: true) }
      @adjacent = -> { @knight.possible_moves.map(&:name) }
    end

    def path(from, to)
      @board.set(from, @knight)
      super(from, to).map { |name| @board.get(name: name) }.map { |cell| [cell.y, cell.x] }
    end

    def self.path(from, to)
      this = new
      this.path(from, to)
    end
  end
end

def knight_moves(position, target)
  position = Chess::Name.get(*position)
  target = Chess::Name.get(*target)

  Search::KnightMoves.path(position, target)
end
