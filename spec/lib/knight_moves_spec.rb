require 'knight_moves'

describe 'Knight Moves' do
  xdescribe Board do
    context "New Board" do
      subject { Board.new }
      it { is_expected.to be true }
    end
  end

  describe Cell do
    context "#initialize" do
      subject { Cell.new }
      its(:value) { should be_nil }
      it { should respond_to :up, :down, :left, :right }
    end
  end
end

