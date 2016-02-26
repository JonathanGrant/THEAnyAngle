#Create a Point class
#It stores a x,y location, and pointers to each of the points around it
class Point
    constructor: (x, y) ->
        @x = x
        @y = y
        
    @North: null
    @NorthWest: null
    @NorthEast: null
    @East: null
    @West: null
    @South: null
    @SouthWest: null
    @SouthEast: null
    
#Create a Grid Class
#The class should hold all the points of the grid, given an input of size
class Grid
    constructor: (width, height) ->
        @Width = width
        @Height = height
        @Points = []
        
    createEmptyGrid: () ->
        for row in [0...@Width]
            Row = []
            for col in [0...@Height]
                Row.push new Point(row, col)
            @Points.push Row
        console.log "Done creating points array."
        #Now link the points together
        for points in @Points
            for point in points
                if point.y > 0
                    point.North = @Points[point.x][point.y-1]
                    if point.x > 0
                        point.NorthWest = @Points[point.x-1][point.y-1]
                    if point.x < @Width - 1
                        point.NorthEast = @Points[point.x+1][point.y-1]
                if point.y < @Height - 1
                    point.South = @Points[point.x][point.y-1]
                    if point.x > 0
                        point.SouthWest = @Points[point.x-1][point.y+1]
                    if point.x < @Width - 1
                        point.SouthEast = @Points[point.x+1][point.y+1]
                if point.x > 0
                    point.West = @Points[point.x-1][point.y]
                if point.x < @Width - 1
                    point.East = @Points[point.x+1][point.y]
        console.log "Done linking points together."
        
#Square Fxn ya know, like x^2
square = (x) -> x * x
#Euclidean Distance for the first Heuristic. Pretty basic
EuclideanDistance = (startPoint, goalPoint) ->
    return Math.sqrt((square (startPoint.x - goalPoint.x)) + (square (startPoint.y - goalPoint.y)))
        
class AStarSearch
    constructor: (heuristic) ->
        @Heuristic = heuristic
        @OpenList = []
        @ClosedList = []
        
    
            
#Runner Code
grid = new Grid(30, 20)
grid.createEmptyGrid()
start = {x:0, y:0}
goal = {x:14, y:11}
