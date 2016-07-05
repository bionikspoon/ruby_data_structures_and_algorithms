require 'knight_moves'
include Chess, BinaryTree

describe Chess do
  describe Board do
    context Board.new do
      its('cells.length') { should eq 64 }
    end
  end

  describe Cell do
    context '#initialize' do
      subject { Cell.new y: 4, x: 3 }
      its(:value) { should be_nil }
      it { should respond_to :name, :x, :y, :value, :up, :down, :left, :right }
      its(:name) { should eq :D4 }
      its(:x) { should be 3 }
      its(:y) { should be 4 }
    end
  end

  describe NAME do
    its([[0, 0]]) { should be :A8 }
    its([[3, 4]]) { should be :E5 }
    its([[9, 9]]) { should be_nil }
  end

  describe :TO_NAME do
    it("should convert (y,x) to cell name") { expect(to_name(4, 3)).to be :D4 }
  end
end

describe BinaryTree do
  describe Node do
    shared_context(:empty) { subject { Node.new } }
    shared_context(:words) { subject { Node.new 'value', up: 'up', left: 'left', right: 'right' } }
    shared_context(:numbers) do
      subject do
        node = Node.new(4)
        left = Node.new(3, up: node)
        right = Node.new(5, up: node)
        node.left, node.right = left, right
        node
      end
    end

    describe '#initialize' do
      include_context :empty do
        it { should be_truthy }
        it { should respond_to :value }
        it { should respond_to :up }
        it { should respond_to :left }
        it { should respond_to :right }
      end

      context 'with values' do
        include_context :words
        its(:value) { should eql 'value' }
        its(:up) { should eql 'up' }
        its(:left) { should eql 'left' }
        its(:right) { should eql 'right' }
      end
    end

    describe '#each' do
      include_context :numbers
      its('each.to_a') { should eq [3, 4, 5] }
    end

    describe '#each_node' do
      include_context :numbers
      its('each_node.to_a') { should eq [subject.left, subject, subject.right] }
    end

    describe '#nodes' do
      include_context :numbers
      its(:nodes) { should eq [subject.left, subject, subject.right] }
    end

    describe '#is_leaf?' do
      include_context :numbers
      its(:is_leaf?) { should be false }
      its('left.is_leaf?') { should be true }
      its('right.is_leaf?') { should be true }
      its('left.up.is_leaf?') { should be false }

    end

    describe "#<=>" do
      include_context :numbers
      it { expect(subject <=> Node.new(3)).to be 1 }
    end

    describe '#insert' do
      include_context :empty
      context '1 item' do
        before { subject.insert (5) }
        its(:value) { should be 5 }
      end
      context '2 items' do
        before do
          subject.insert(5)
          subject.insert(4)
        end
        its('left.value') { should be 4 }

      end


      it "should keep items sorted" do
        subject.insert(5).insert(4).insert(7).insert(6)

        expect(subject)

      end
    end


    describe 'enum methods' do
      include_context :numbers

      describe '#inject' do
        it { expect(subject.inject(0) { |memo, value| memo + value }).to be 12 }
      end

      describe '#max' do
        its(:max) { should be 5 }
      end
    end
  end
  describe EmptyNode do
    shared_context(:empty) { subject { EmptyNode.new } }
    describe '#initialize' do
      include_context :empty
      its(:value) { should be_nil }
      its(:up) { should be subject }
      its(:left) { should be subject }
      its(:right) { should be subject }
      its(:up?) { should be false }
      its(:left?) { should be false }
      its(:right?) { should be false }
      its(:insert) { should be false }
      its(:inspect) { should eql '{BinaryTree::EmptyNode}' }
      its(:to_s) { should eql '{BinaryTree::EmptyNode}' }
    end
  end
end
