require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "#dashboard" do
    get games_dashboard_url
    assert_response :success
  end

  test "#rotate_direction with missing params" do
    get games_rotate_direction_url, params: {}
    assert_response :success
    assert_equal I18n.t('games.invalid_direction'), JSON.parse(@response.body)["error"]
  end

  test "#rotate_direction with invalid params" do
    # with invalid signal and current direction
    get games_rotate_direction_url, params: { signal: "invalid", current_direction: "invalid" }
    assert_response :success
    assert_equal I18n.t('games.invalid_direction'), JSON.parse(@response.body)["error"]

    # with invalid signal
    get games_rotate_direction_url, params: { signal: "invalid", current_direction: SOUTH }
    assert_response :success
    assert_equal I18n.t('games.invalid_direction'), JSON.parse(@response.body)["error"]

    # with invalid current direction
    get games_rotate_direction_url, params: { signal: ROTATE_LEFT_SIGNAL, current_direction: "invalid" }
    assert_response :success
    assert_equal I18n.t('games.invalid_direction'), JSON.parse(@response.body)["error"]
  end

  test "#rotate_direction with valid params" do
    # signal = left, current_direction = east
    get games_rotate_direction_url, params: { signal: ROTATE_LEFT_SIGNAL, current_direction: EAST }
    assert_response :success
    assert_equal NORTH, JSON.parse(@response.body)["rotate_direction"]

    # signal = left, current_direction = west
    get games_rotate_direction_url, params: { signal: ROTATE_LEFT_SIGNAL, current_direction: WEST }
    assert_response :success
    assert_equal SOUTH, JSON.parse(@response.body)["rotate_direction"]

    # signal = left, current_direction = south
    get games_rotate_direction_url, params: { signal: ROTATE_LEFT_SIGNAL, current_direction: SOUTH }
    assert_response :success
    assert_equal EAST, JSON.parse(@response.body)["rotate_direction"]

    # signal = left, current_direction = north
    get games_rotate_direction_url, params: { signal: ROTATE_LEFT_SIGNAL, current_direction: NORTH }
    assert_response :success
    assert_equal WEST, JSON.parse(@response.body)["rotate_direction"]

    # signal = right, current_direction = east
    get games_rotate_direction_url, params: { signal: ROTATE_RIGHT_SIGNAL, current_direction: EAST }
    assert_response :success
    assert_equal SOUTH, JSON.parse(@response.body)["rotate_direction"]

    # signal = right, current_direction = west
    get games_rotate_direction_url, params: { signal: ROTATE_RIGHT_SIGNAL, current_direction: WEST }
    assert_response :success
    assert_equal NORTH, JSON.parse(@response.body)["rotate_direction"]

    # signal = right, current_direction = south
    get games_rotate_direction_url, params: { signal: ROTATE_RIGHT_SIGNAL, current_direction: SOUTH }
    assert_response :success
    assert_equal WEST, JSON.parse(@response.body)["rotate_direction"]

    # signal = right, current_direction = north
    get games_rotate_direction_url, params: { signal: ROTATE_RIGHT_SIGNAL, current_direction: NORTH }
    assert_response :success
    assert_equal EAST, JSON.parse(@response.body)["rotate_direction"]
  end

  test "#move_direction with missing params" do
    get games_move_direction_url, params: {}
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]
  end

  test "#move_direction with invalid params" do
    # with invalid row_position, column_position and direction
    get games_move_direction_url,
      params: { row_position: "invalid", column_position: "invalid", direction: "invalid" }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # with invalid row_position
    get games_move_direction_url,
      params: { row_position: "invalid", column_position: TOTAL_COLUMNS, direction: EAST }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # with invalid column_position
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: "invalid", direction: EAST }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # with invalid direction
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS, direction: "invalid" }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]
  end

  test "#move_direction with valid params and invalid moves" do
    # invalid south move
    get games_move_direction_url,
      params: { row_position: 1, column_position: 1, direction: SOUTH }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # invalid west move
    get games_move_direction_url,
      params: { row_position: 1, column_position: 1, direction: WEST }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # invalid east move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS, direction: EAST }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]

    # invalid north move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS, direction: NORTH }
    assert_response :success
    assert_equal I18n.t('games.invalid_move'), JSON.parse(@response.body)["error"]
  end

  test "#move_direction with valid params and valid moves" do
    # valid north move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS - MOVE_STEPS, column_position: TOTAL_COLUMNS, direction: NORTH }
    assert_response :success
    assert_equal TOTAL_ROWS, JSON.parse(@response.body)["row_position"]
    assert_equal TOTAL_COLUMNS, JSON.parse(@response.body)["column_position"]

    # valid east move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS - MOVE_STEPS, direction: EAST }
    assert_response :success
    assert_equal TOTAL_ROWS, JSON.parse(@response.body)["row_position"]
    assert_equal TOTAL_COLUMNS, JSON.parse(@response.body)["column_position"]

    # valid south move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS, direction: SOUTH }
    assert_response :success
    assert_equal TOTAL_ROWS - MOVE_STEPS, JSON.parse(@response.body)["row_position"]
    assert_equal TOTAL_COLUMNS, JSON.parse(@response.body)["column_position"]

    # valid west move
    get games_move_direction_url,
      params: { row_position: TOTAL_ROWS, column_position: TOTAL_COLUMNS, direction: WEST }
    assert_response :success
    assert_equal TOTAL_ROWS, JSON.parse(@response.body)["row_position"]
    assert_equal TOTAL_COLUMNS - MOVE_STEPS, JSON.parse(@response.body)["column_position"]
  end
end
