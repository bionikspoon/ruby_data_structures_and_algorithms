class Node
  attr_accessor :value, :up, :left, :right

  def initialize(value=nil, up: nil, left: nil, right: nil)
    @value = value
    @up = up
    @left = left
    @right = right
  end

  def fork(value)
    if value <= @value
      if @left === nil
        @left = Node.new value, up: self
        return self
      else
        @left.fork value
      end
    else
      if @right === nil
        @right = Node.new value, up: self
        return self
      else
        @right.fork value
      end
    end
  end

  def is_leaf?
    @left === nil && @right === nil
  end

  def inspect
    value = @value ? "@value=#{@value}" : nil
    up = @up ? "@up=<Node:#{@up.value}>" : nil
    left = @left ? "@left=<Node:#{@left.value}>" : nil
    right = @right ? "@right=<Node:#{@right.value}>" : nil
    "<Node:#{[value, up, left, right].compact.join(',')}>"
  end

  def to_s
    self.inspect
  end
end

def build_tree(data, shuffle: true)
  data = data.to_a.dup
  data.shuffle! if shuffle

  root = Node.new data.shift
  data.each { |value| root.fork value }
  root
end

def breadth_first_search(target, tree)
  q = Queue.new
  q << tree
  visited = []

  until q.empty?
    node = q.shift
    visited << node
    return node if node.value == target

    [node.up, node.left, node.right]
        .compact
        .reject { |n| visited.include? n }
        .each { |n| q << n }
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
    stack.concat [node.up, node.left, node.right]
                     .compact
                     .reject { |n| visited.include? n }
  end
end

def dfs_rec(target, node, visited: [])
  return node if node.value == target
  visited << node
  [node.up, node.left, node.right]
      .compact
      .reject { |n| visited.include? n }
      .collect { |n| dfs_rec(target, n, visited: visited) }
      .reject { |n| n === nil }
      .first
end