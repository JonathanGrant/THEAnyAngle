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

class Node
    constructor: (point, gVal, hVal) ->
        @point = point
        @fVal = gVal + hVal
        @gVal = gVal
        @hVal = hVal
        
    getSuccessors: () ->
        successors = []
        if @point.North
            successors.push @point.North
        if @point.NorthWest
            successors.push @point.NorthWest
        if @point.NorthEast
            successors.push @point.NorthEast
        if @point.West
            successors.push @point.West
        if @point.East
            successors.push @point.East
        if @point.SouthWest
            successors.push @point.SouthWest
        if @point.SouthEast
            successors.push @point.SouthEast
        if @point.South
            successors.push @point.South
        return successors
        
class AStarSearch
    constructor: (heuristic) ->
        @Heuristic = heuristic
        @OpenList = []
        @ClosedList = []
        
    addToOpen: (node) ->
        @OpenList.push node
        #Now remove this point from ClosedList, and add all others to ClosedList
        indexToRemove = @ClosedList.indexOf node
        #Index is -1 for the first index, because nothing should be in closedList
        if !(indexToRemove < 0)
            #Remove!
            @ClosedList.splice indexToRemove, 1
        #Now add successors to list
        for point in node.getSuccessors()
            #If node is in openList, don't do anything
            for inListNode in @OpenList
                if inListNode.point is point
                    continue
            indexOfNode = -1
            num = 0
            for inListNode in @ClosedList
                if inListNode.point is point
                    #Save the index and break out!
                    indexOfNode = num
                    break
                num += 1
            if indexOfNode < 0
                #Not in ClosedList or OpenList. So we can add it!
                @ClosedList.push new Node(point, node.gVal + 1, EuclideanDistance(point, @GoalPoint))
            else
                #So the node is already in the ClosedList. Well, does ours have a better fVal?
                ourFval = node.gVal + 1 + EuclideanDistance(point, @GoalPoint)
                if ourFval < @ClosedList[indexOfNode]
                    #Yes, we should add!
                    #First remove the previous
                    @ClosedList.splice indexOfNode, 1
                    #And then we can add
                    @ClosedList.push new Node(point, node.gVal + 1, EuclideanDistance(point, @GoalPoint))
        
    search: (startPoint, goalPoint) ->
        @GoalPoint = goalPoint
        path = []
        if startPoint.x == goalPoint.x and startPoint.y == goalPoint.y
            return path
        #Make startPoint into a node
        startNode = new Node(startPoint, 0, EuclideanDistance(startPoint.x, startPoint.y))
        this.addToOpen startNode
        
        while (@ClosedList.length)
            #Get min from the ClosedList and add it to the OpenList
            minFval = 9999999999
            for node in
            currNode = @ClosedList.find(function(o){ return o.fVal == res; })
            #TODO - Smoothing? Ask Tansel for line by line of AStarSearch fxn in this location
            addToOpen currNode
            #If this is the goal, stop
            if currNode.point is goalPoint
                break
        #Fill in Path somehow
        return path
            
#Runner Code
#TODO add a timer
grid = new Grid(30, 20)
grid.createEmptyGrid()
start = {x:0, y:0}
goal = {x:14, y:11}
searchie = new AStarSearch("EuclideanDistance")
path = searchie.search(grid.Points[4][5], grid.Points[4][4])
console.log path
console.log searchie.OpenList
console.log searchie.ClosedList