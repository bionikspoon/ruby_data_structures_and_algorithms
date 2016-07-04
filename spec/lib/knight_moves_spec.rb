require 'knight_moves'

describe 'Knight Moves' do
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
end

