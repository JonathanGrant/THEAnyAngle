#Classes
class Corner
    constructor: (x, y, cornerType) ->
        @x = x
        @y = y
        @cornerType = cornerType

class Cell
    constructor: (isObstacle) ->
        @isObstacle = isObstacle
        @northWest = null
        @northEast = null
        @southWest = null
        @southEast = null

#Convert 2d array of 1's and 0s to list of cells and list of corners
#First create the list of cells
createCells: (map) ->
    
    return 0