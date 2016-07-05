require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'knight_moves'

test_data = []

5000.times { test_data << (rand 50000) }

tree = BinaryTree::Node.new test_data.first
test_array = []

Benchmark.bm do |benchmark|
  benchmark.report("test_array push") { test_data.each { |value| test_array << value } }
  benchmark.report("bin tree insert") { test_data.each { |value| tree << value } }
end
Benchmark.bm do |benchmark|
  benchmark.report("test_array include") { (1..50000).each { |n| test_array.include?(n) } }
  benchmark.report("binary tree search") { (1..50000).each { |n| tree.include?(n) } }
end