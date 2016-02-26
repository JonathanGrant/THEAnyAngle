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
        console.log @Points
        #Now link the points together
        for point in @Points
            if point.x 
    
pt = new Point(15, 40)
console.log pt

grid = new Grid(15, 40)
console.log grid
grid.createEmptyGrid()