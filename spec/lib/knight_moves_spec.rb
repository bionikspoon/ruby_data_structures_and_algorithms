# frozen_string_literal: true
require 'knight_moves'

describe Chess do
  describe Chess::Board do
    context Chess::Board.new do
      its('cells.length') { should be 64 }
    end
  end

  describe Chess::Cell do
    describe '#initialize' do
      subject { Chess::Cell.new y: 4, x: 3 }
      its(:value) { should be_nil }
      it { should respond_to :name, :x, :y, :value, :up, :down, :left, :right }
      its(:name) { should eq :D4 }
      its(:x) { should be 3 }
      its(:y) { should be 4 }
    end

    describe '#inspect' do
      subject { Chess::Cell.new y: 4, x: 3 }
      its(:inspect) { should eq '{D4}' }
    end
  end

  describe 'Chess::Names' do
    subject { Chess::Name }
    describe 'get' do
      it { expect(subject.get(0, 0)).to eq :A8 }
      it { expect(subject.get(3, 4)).to eq :E5 }
      it { expect(subject.get(9, 9)).to be_nil }
    end
  end
end

describe BinaryTree, :include_BinaryTree do
  describe BinaryTree::Node do
    shared_context(:empty) { subject { BinaryTree::Node.new } }
    shared_context(:words) do
      subject { BinaryTree.factory(%w(value left right), shuffle: false) }
    end
    shared_context(:numbers) do
      subject do
        BinaryTree.factory([4, 3, 5], shuffle: false)
      end
    end

    describe '#initialize' do
      context 'without values' do
        include_context :empty
        it { should be_truthy }
        it { should respond_to :value }
        it { should respond_to :left }
        it { should respond_to :right }
      end

      context 'with values' do
        include_context :words
        its(:value) { should eql 'value' }
        its('left.value') { should eql 'left' }
        its('left.right.value') { should eql 'right' }
      end
      context 'with numbers' do
        include_context :numbers
        its('left.value') { should eql 3 }
        its('right.value') { should eql 5 }
      end
    end

    describe '#each' do
      include_context :numbers
      its('each.to_a') { should eq [3, 4, 5] }
      its(:each) { should be_an_instance_of Enumerator }
      it { expect { |b| subject.each(&b) }.to yield_successive_args 3, 4, 5 }
    end

    describe '#each_node' do
      include_context :numbers
      its('each_node.to_a') { should eq [subject.left, subject, subject.right] }
    end

    describe '#nodes' do
      include_context :numbers
      its(:nodes) { should eq [subject.left, subject, subject.right] }
    end

    describe '#push' do
      include_context :empty

      context '1 item' do
        before { subject.push 5 }
        its(:value) { should be 5 }
      end

      context '2 items' do
        before do
          subject.push(5)
          subject.push(4)
        end
        its('left.value') { should be 4 }
      end

      context 'a few items' do
        before { subject.push(5).push(4).push(7).push(6) }
        its(:to_a) { should eq [4, 5, 6, 7] }
      end

      context '100 items' do
        before { 100.times { |i| subject << i } }
        its(:to_a) { should eq((0..99).to_a) }
      end

      context '100 shuffled items' do
        before do
          shuffled = (0..99).to_a.shuffle
          shuffled.each { |i| subject << i }
        end
        its(:to_a) { should eq((0..99).to_a) }
        its('to_a.length') { should be 100 }
      end
    end

    describe '#include?' do
      include_context :empty
      context 'a few items' do
        before(:each) { subject.push(3).push(5).push(1).push(4).push(3) }
        it { expect(subject.include?(15)).to be false }
        it { expect(subject.include?(3)).to be true }
        it { expect(subject.include?(5)).to be true }
        it { expect(subject.include?(1)).to be true }
        it { expect(subject.include?(4)).to be true }
        it { expect(subject.include?(0)).to be false }
      end
    end

    describe '#<=>' do
      include_context :numbers
      it { expect(subject <=> BinaryTree::Node.new(3)).to be 1 }
    end

    describe '#inspect' do
      include_context :numbers
      its(:inspect) { should eq '{Node:4:{Node:3:{#}:{#}}:{Node:5:{#}:{#}}}' }
    end

    describe '#to_s' do
      include_context :numbers
      its(:to_s) { should eq '{Node:4:3:5}' }
    end

    describe '#leaf?' do
      include_context :numbers
      its(:leaf?) { should be false }
      its('left.leaf?') { should be true }
      its('right.leaf?') { should be true }
    end

    describe 'enum methods' do
      include_context :numbers

      describe '#inject' do
        it do
          expect(subject.inject(0) { |memo, value| memo + value }).to be 12
        end
      end

      describe '#max' do
        its(:max) { should be 5 }
      end
    end

    describe 'aliases' do
      context ':push, :<<' do
        it { expect(subject.method(:push)).to eq subject.method(:<<) }
      end
    end
  end

  describe 'EmptyNode' do
    subject { BinaryTree::EmptyNode }
    describe '#initialize' do
      its(:value) { should be_nil }
      its(:left) { should be subject }
      its(:right) { should be subject }
      its(:to_a) { should eq [] }
      its(:push) { should be false }
      its(:<<) { should be false }
      its(:each) { should be_nil }
      its(:each_node) { should be_nil }
      its(:include?) { should be false }
      its(:inspect) { should eql '{#}' }
      its(:to_s) { should eql '{#}' }
    end

    describe 'aliases' do
      context ':push, :<<' do
        it { expect(subject.method(:push)).to eq subject.method(:<<) }
      end
    end
  end

  describe '#factory' do
    context 'with shuffle' do
      subject { BinaryTree.factory 0..99 }
      its('to_a.length') { should be 100 }
    end
    context 'with out shuffle' do
      subject { BinaryTree.factory 0..89, shuffle: false }
      its('to_a.length') { should be 90 }
    end
    context 'with one item' do
      subject { BinaryTree.factory [1] }
      its(:to_a) { should eq [1] }
    end
  end
end
