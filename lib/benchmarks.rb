require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'knight_moves'

test_data = []

50000.times { test_data << (rand 50000) }

def array_factory(items)
  list = []
  items.each { |item| list << item }
  list
end

Benchmark.bm do |benchmark|
  benchmark.report("test_array push") { $test_array = array_factory(test_data) }
  benchmark.report("bin tree insert") { $test_tree = BinaryTree.factory(test_data, shuffle: false) }
end
Benchmark.bm do |benchmark|
  benchmark.report("test_array include") { (1..50000).each { |n| $test_array.include?(n) } }
  benchmark.report("binary tree search") { (1..50000).each { |n| $test_tree.include?(n) } }
end