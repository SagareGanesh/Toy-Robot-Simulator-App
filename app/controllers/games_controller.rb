class GamesController < ApplicationController
  ## GET dashboard
  #
  def dashboard
  end

  ## GET rotate_direction
  #
  # params = {
  #   signal: "LEFT",
  #   current_direction: "NORTH"
  # }
  #
  def rotate_direction
    rotate_direction = ROTATE_DIRECTIONS.dig(params[:signal], params[:current_direction])
    return render json: { rotate_direction: rotate_direction } if rotate_direction

    render json: { error: I18n.t('games.invalid_direction') }
  end

  ## GET move_direction
  #
  # params = {
  #   row_position: "1",
  #   column_position: "1"
  #   direction: "EAST"
  # }
  #
  def move_direction
    return render json: { error: I18n.t('games.invalid_move') } unless valid_move_params?

    result, move_positions = MovePosition.new(
      row_position: params[:row_position].to_i,
      column_position: params[:column_position].to_i,
      direction: params[:direction]
    ).call

    return render json: { error: I18n.t('games.invalid_move') } unless result

    render json: {
      row_position: move_positions[:row],
      column_position: move_positions[:column]
    }
  end

  private

    def valid_move_params?
      return false unless params[:row_position] || params[:column_position] || params[:direction]
      return false unless Integer(params[:row_position]) && Integer(params[:column_position])
      return false unless ALL_DIRECTIONS.include?(params[:direction])

      true
    rescue ArgumentError, TypeError
      false
    end
end
