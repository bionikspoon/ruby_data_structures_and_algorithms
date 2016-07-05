# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'knight_moves'

test_data = []

50_000.times { test_data << (rand 500_000) }

def array_factory(items)
  list = []
  items.each { |item| list << item }
  list
end

def hash_factory(items)
  hash = {}
  items.each { |item| hash[item] = true }
  hash
end

test_array = nil
test_tree = nil
test_hash = nil

Benchmark.bm do |benchmark|
  benchmark.report('test_array create') { test_array = array_factory(test_data) }
  benchmark.report('test_tree  create') { test_tree = BinaryTree.factory(test_data, shuffle: false) }
  benchmark.report('test_hash  create') { test_hash = hash_factory(test_data) }
end
Benchmark.bm do |benchmark|
  benchmark.report('test_array include?     ') { (1..50_000).each { |n| test_array.include?(n) } }
  benchmark.report('test_tree  include? x100') { (1..500_000).each { |n| test_tree.include?(n) } }
  benchmark.report('test_hash  has_key? x100') { (1..500_000).each { |n| test_hash.key?(n) } }
end
