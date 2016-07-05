# frozen_string_literal: true
require 'spec_helper'
require 'binary_tree'

describe 'Binary Tree' do
  describe Node do
    before(:each) do
      @empty_node = Node.new
    end

    describe '#value' do
      it 'should exist' do
        expect(@empty_node).to respond_to :value
      end
    end

    describe '#parent' do
      it 'should exist' do
        expect(@empty_node).to respond_to :up
      end
    end

    describe '#left' do
      it 'should exist' do
        expect(@empty_node).to respond_to :left
      end
    end

    describe '#right' do
      it 'should exist' do
        expect(@empty_node).to respond_to :right
      end
    end

    describe '#leaf?' do
      it 'should exist' do
        expect(@empty_node).to respond_to :leaf?
      end

      it 'should be true if left and right are nil' do
        expect(@empty_node.leaf?).to be true
      end

      it "should be false if left or right aren't nil" do
        @empty_node.left = 1
        @empty_node.right = 2
        expect(@empty_node.leaf?).to be false
      end
    end
  end
  describe '#build_tree' do
    before(:each) do
      @tree = build_tree [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324], shuffle: false
    end

    it('should build a binary tree') { expect(@tree.value).to eq 1 }
    it('should build a binary tree') { expect(@tree.right.left.value).to eq 4 }
    it('should build a binary tree') { expect(@tree.right.right.right.right.value).to eq 6345 }
    it('should build a binary tree') { expect(@tree.right.right.right.right.up.up.up.left.left.value).to eq 4 }
  end

  describe '#breadth_first_search' do
    before(:each) do
      @tree = build_tree(1..100)
    end

    it 'should return target node' do
      node = breadth_first_search 50, @tree

      expect(node).to be_truthy
      expect(node.value).to eq 50
    end

    it 'should return nil if target not found' do
      expect(breadth_first_search(500, @tree)).to be_nil
    end
  end

  describe '#depth_first_search' do
    before(:each) do
      @tree = build_tree(1..100)
    end

    it 'should return target node' do
      node = depth_first_search 50, @tree

      expect(node).to be_truthy
      expect(node.value).to eq 50
    end

    it 'should return nil if target not found' do
      expect(depth_first_search(500, @tree)).to be_nil
    end
  end

  describe '#dfs_rec' do
    before(:each) do
      @tree = build_tree(1..100)
    end

    it 'should return target node' do
      node = dfs_rec 50, @tree

      expect(node).to be_truthy
      expect(node.value).to eq 50
    end

    it 'should return nil if target not found' do
      expect(dfs_rec(500, @tree)).to be_nil
    end
  end
end
