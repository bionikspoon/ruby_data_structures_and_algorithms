# frozen_string_literal: true
require 'knight_moves'

describe Chess do
  describe 'Name' do
    subject { Chess::Name }

    describe '#includes?' do
      it { expect(subject.includes?([1, 2])).to be true }
    end

    describe '#each' do
      subject { Chess::Name.each }
      its(:size) { should be 64 }
      it { should be_an_instance_of Enumerator }
    end

    describe '#get' do
      it { expect(subject.get(0, 0)).to eq :A8 }
      it { expect(subject.get(3, 4)).to eq :E5 }
      it { expect(subject.get(9, 9)).to be_nil }
    end
  end

  describe Chess::Board do
    let(:board) { Chess::Board.new }

    describe '#initialize' do
      its('cells.length') { should be 64 }
    end

    describe '#get' do
      context do
        subject { board.get(x: 1, y: 1) }
        its(:name) { should be :B7 }
      end

      context do
        subject { board.get(x: 0, y: 0) }
        its(:name) { should be :A8 }
      end

      context do
        subject { board.get(name: :E3) }
        its(:name) { should be :E3 }
      end
    end

    describe '#delta' do
      let(:cell) { board.get name: :D4 }

      context do
        subject { board.delta cell, y: -2, x: -1 }
        its(:name) { should be :C6 }
      end

      context do
        subject { board.delta cell, y: -2, x: 1 }
        its(:name) { should be :E6 }
      end

      context do
        subject { board.delta cell, y: 2, x: -1 }
        its(:name) { should be :C2 }
      end

      context do
        subject { board.delta cell, y: -4, x: -3 }
        its(:name) { should be :A8 }
      end

      context 'out of bounds' do
        subject { board.delta cell, y: -4, x: -4 }
        its(:name) { should be :** }
      end

      context '0, 0' do
        subject { board.delta cell }
        it { should be cell }
      end
    end

    describe 'traversing cells' do
      subject { board.get(name: :D4) }
      its('up.name') { should be :D5 }
      its('up.up.name') { should be :D6 }
      its('up.up.up.up.name') { should be :D8 }
      its('up.up.up.up.left.name') { should be :C8 }
      its('up.up.up.up.left.left.left.name') { should be :A8 }
      its('up.up.up.up.left.left.left.left.name') { should be :** }
    end
  end

  describe Chess::EmptyCell do
    subject { Chess::EmptyCell }
    its(:value) { should be_nil }
    its(:name) { should be :** }
    its(:to_s) { should be '{**}' }
  end

  describe Chess::Cell do
    let(:cell) { Chess::Cell.new y: 4, x: 3 }
    describe '#initialize' do
      subject { cell }
      it { should respond_to :value, :name, :x, :y, :up, :down, :left, :right }
      its(:value) { should be_nil }
      its(:name) { should eq :D4 }
      its(:x) { should be 3 }
      its(:y) { should be 4 }
      its(:up) { should be Chess::EmptyCell }
      its(:right) { should be Chess::EmptyCell }
      its(:down) { should be Chess::EmptyCell }
      its(:left) { should be Chess::EmptyCell }
    end

    describe '#inspect' do
      subject { cell }
      its(:inspect) { should eq '{D4}' }
    end

    describe '#set' do
      let(:other) { Chess::Cell.new }
      subject { cell }

      context 'called once' do
        before { cell.set(up: other) }
        its(:up) { should be other }
        its(:down) { should be Chess::EmptyCell }
      end

      context 'called twice' do
        before do
          cell.set(up: other)
          cell.set(up: Chess::Cell.new, down: Chess::Cell.new)
        end
        its(:up) { should be other }
        its(:down) { should be Chess::EmptyCell }
      end
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

      describe '#reduce' do
        it do
          expect(subject.reduce(0) { |memo, value| memo + value }).to be 12
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
