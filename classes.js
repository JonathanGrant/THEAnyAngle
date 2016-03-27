var Cell, Corner;

Corner = (function() {
  function Corner(x, y, cornerType) {
    this.x = x;
    this.y = y;
    this.cornerType = cornerType;
  }

  return Corner;

})();

Cell = (function() {
  function Cell(isObstacle) {
    this.isObstacle = isObstacle;
    this.northWest = null;
    this.northEast = null;
    this.southWest = null;
    this.southEast = null;
  }

  return Cell;

})();