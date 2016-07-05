require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'knight_moves'

test_data = []

500000.times { test_data << (rand 50000) }

def array_factory(items)
  list = []
  items.each { |item| list << item }
  list
end

def hash_factory(items)
  hash = Hash.new
  items.each { |item| hash[item] = true }
  hash
end

test_array, test_tree, test_hash = nil, nil, nil

Benchmark.bm do |benchmark|
  benchmark.report("test_array create") { test_array = array_factory(test_data) }
  benchmark.report("test_tree  create") { test_tree = BinaryTree.factory(test_data, shuffle: false) }
  benchmark.report("test_hash  create") { test_hash = hash_factory(test_data) }
end
Benchmark.bm do |benchmark|
  benchmark.report("test_array include?     ") { (1..50000).each { |n| test_array.include?(n) } }
  benchmark.report("test_tree  include? x100") { (1..500000).each { |n| test_tree.include?(n) } }
  benchmark.report("test_hash  has_key? x100") { (1..500000).each { |n| test_hash.has_key?(n) } }

end