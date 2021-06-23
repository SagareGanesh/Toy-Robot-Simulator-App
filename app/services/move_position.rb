class MovePosition
  attr_reader :row_position, :column_position, :direction

  def initialize(params)
    @row_position = params[:row_position]
    @column_position = params[:column_position]
    @direction = params[:direction]
  end

  def call
    move_row_position, move_column_postion = move_positions
    return false, {} unless move_row_position || move_column_postion

    if valid_positions?(move_row_position, move_column_postion)
      return true, { row: move_row_position, column: move_column_postion }
    else
      return false, {}
    end

  end

  private

    def move_positions
      case direction
      when NORTH then [row_position + MOVE_STEPS, column_position]
      when SOUTH then [row_position - MOVE_STEPS, column_position]
      when EAST  then [row_position, column_position + MOVE_STEPS]
      when WEST  then [row_position, column_position - MOVE_STEPS]
      end
    end

    def valid_positions?(row_position, column_position)
      return false if row_position < 1
      return false if column_position < 1
      return false if row_position > TOTAL_ROWS
      return false if column_position > TOTAL_COLUMNS

      true
    end
end