# frozen_string_literal: true

# Binary Tree Node object
class Node
  attr_accessor :value, :up, :left, :right

  # @param [Node] value
  # @param [Node] up
  # @param [Node] left
  # @param [Node] right
  def initialize(value = nil, up: nil, left: nil, right: nil)
    @value = value
    @up = up
    @left = left
    @right = right
  end

  def fork(value)
    (value <= @value) ? fork_left(value) : fork_right(value)
  end

  def leaf?
    @left.nil? && @right.nil?
  end

  def inspect
    "{Node:#{@value}:#{@left.inspect}:#{@right.inspect}}"
  end

  def to_s
    "{Node::#{value}}"
  end

  protected

  def fork_left(value)
    return @left.fork value unless @left.nil?

    @left = Node.new value, up: self
    self
  end

  def fork_right(value)
    return @right.fork value unless @right.nil?

    @right = Node.new value, up: self
    self
  end
end

def build_tree(data, shuffle: true)
  data = data.to_a.dup
  data.shuffle! if shuffle

  root = Node.new data.shift
  data.each { |value| root.fork value }
  root
end

def queue_factory(tree = nil)
  q = Queue.new
  q << tree if tree
  q
end

def breadth_first_search(target, tree)
  q = queue_factory tree

  visited = []
  until q.empty?
    node = q.shift
    visited << node
    return node if node.value == target

    [node.up, node.left, node.right].compact.reject { |n| visited.include? n }.each { |n| q << n }
  end
end

def depth_first_search(target, tree)
  stack = [tree]
  visited = []

  until stack.empty?
    node = stack.pop
    next if visited.include? node
    return node if node.value == target

    visited << node
    stack.concat [node.up, node.left, node.right].compact.reject { |n| visited.include? n }
  end
end

def dfs_rec(target, node, visited: [])
  return node if node.value == target
  visited << node
  [node.up, node.left, node.right]
    .compact
    .reject { |n| visited.include? n }
    .collect { |n| dfs_rec(target, n, visited: visited) }
    .reject(&:nil?)
    .first
end
