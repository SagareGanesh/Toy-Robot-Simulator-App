require "test_helper"

class MovePositionMovePositionTest < ActiveSupport::TestCase
  test "with invalid params" do
    params = {
      row_position: 0,
      column_position: 0,
      direction: "invalid"
    }

    result, move_positions = MovePosition.new(params).call
    assert_equal result, false
    assert_equal move_positions, {}
  end

  test "with valid params" do
    params = {
      row_position: 1,
      column_position: 1,
      direction: "EAST"
    }

    result, move_positions = MovePosition.new(params).call
    assert_equal result, true
    assert_equal move_positions, {:row=>1, :column=>2}
  end
end