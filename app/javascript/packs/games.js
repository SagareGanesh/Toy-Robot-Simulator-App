$(document).ready(function() {

  $direction = null
  $rowPosition = null
  $columnPosition = null
  $directionSymbol = null

  $southDirectionSymbol = "&#8681" // ⇩
  $northDirectionSymbol = "&#8679" // ⇧
  $westDirectionSymbol = "&#8678"  // ⇦
  $eastDirectionSymbol = "&#8680"  // ⇨

  $east = "EAST"
  $west = "WEST"
  $south = "SOUTH"
  $north = "NORTH"

  $rotateLeftSignal = "LEFT"
  $rotateRightSignal = "RIGHT"

  $emptyRowColumnValue = ""

  // Rotate Left
  //
  $("#left").click(function(){
    if($direction) {
      rotate($rotateLeftSignal)
    }
  });

  // Rotate Right
  //
  $("#right").click(function(){
    if($direction) {
      rotate($rotateRightSignal)
    }
  });

  // Get Direction Symbol
  //
  getDirectionSymbol = (direction) => {
    switch(direction) {
      case $south: return $southDirectionSymbol;
      case $north: return $northDirectionSymbol;
      case $east:  return $eastDirectionSymbol;
      case $west: return $westDirectionSymbol;
    }
  };

  // Rotate
  //
  rotate = (signal) => {
    $.ajax({
      url: `rotate_direction?signal=${signal}&current_direction=${$direction}`,
      type: "GET"
    }).done(function(result){
      rotate_direction = result["rotate_direction"]
      if(rotate_direction) {
        unfillRowColumnValue()
        updateDirection(rotate_direction)
        updateDirectionSymbol()
        fillRowColumnValue()
      } else {
        // alert(result["error"])
      }
    });
  };

  // Move
  //
  $("#move").click(function(){
    if($rowPosition && $columnPosition && direction) {
      $.ajax({
        url: `move_direction?direction=${$direction}&row_position=${$rowPosition}&column_position=${$columnPosition}`,
        type: "GET"
      }).done(function(result){
        moveRowPosition = result["row_position"]
        moveColumnPostion = result["column_position"]

        if(moveRowPosition != null && moveColumnPostion != null){
          unfillRowColumnValue()
          updateRowColoumnPositions(moveRowPosition, moveColumnPostion)
          fillRowColumnValue()
        } else {
          // alert(result["error"])
        }
      });
    }
  });

  // Place
  //
  $("#place").click(function(){
    placeRowPosition = $("#row-position").val()
    placeColumnPosition = $("#column-position").val()
    plcaeDirection = $("#direction").val()

    if(placeRowPosition != "" && placeColumnPosition != "" && plcaeDirection != "") {
      unfillRowColumnValue()
      updateDirection(plcaeDirection)
      updateDirectionSymbol()
      updateRowColoumnPositions(placeRowPosition, placeColumnPosition)
      fillRowColumnValue()
      clearSelection()
    } else {
      alert("Please select Row, Column and Direction!!!")
    }
  });

  // Report
  //
  $("#report").click(function(){
    if($rowPosition && $columnPosition && $direction) {
      alert(`${$rowPosition}, ${$columnPosition}, ${$direction}`)
    }
  });

  // Clear Selection
  //
  clearSelection = () => {
    $("#row-position").prop("value", "")
    $("#column-position").prop("value", "")
    $("#direction").prop("value", "")
  }

  // Fill Row Colum Value
  //
  fillRowColumnValue = () => {
    $(`#${$rowPosition}-${$columnPosition}`).html($directionSymbol);
  }

  // Unfill Row Colum Value
  //
  unfillRowColumnValue = () => {
    $(`#${$rowPosition}-${$columnPosition}`).html($emptyRowColumnValue);
  }

  // Update Row Column Positions
  //
  updateRowColoumnPositions = (rowPosition, columnPosition) => {
    $rowPosition = rowPosition
    $columnPosition = columnPosition
  }

  // Update Direction
  //
  updateDirection = direction => {
    $direction = direction
  }

  // Update Direction Symbol
  //
  updateDirectionSymbol = () => {
    $directionSymbol = getDirectionSymbol($direction)
  }

});
