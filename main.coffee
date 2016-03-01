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
    
    #I decided to add Node variables as well
    @fVal = 999999999999999999
    @gVal = 999999999999999999
    @hVal = 999999999999999999
    @Parent = null
    
    getSuccessors: () ->
        successors = []
        if @North
            successors.push @North
        if @NorthWest
            successors.push @NorthWest
        if @NorthEast
            successors.push @NorthEast
        if @West
            successors.push @West
        if @East
            successors.push @East
        if @SouthWest
            successors.push @SouthWest
        if @SouthEast
            successors.push @SouthEast
        if @South
            successors.push @South
        return successors
    
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
                    point.South = @Points[point.x][point.y+1]
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
        
    addToOpen: (node) ->
        @OpenList.push node
        #Now remove this point from ClosedList, and add all others to ClosedList
        indexToRemove = @ClosedList.indexOf node
        #Index is -1 for the first index, because nothing should be in closedList
        if !(indexToRemove < 0)
            #Remove!
            @ClosedList.splice indexToRemove, 1
        #Now add successors to Closed List
        for point in node.getSuccessors()
            #If node is in openList, don't do anything
            inOpen = false
            for inListNode in @OpenList
                if inListNode.x is point.x
                    if inListNode.y is point.y
                        inOpen = true
                        break
            if inOpen
                continue
            indexOfNode = -1
            num = 0
            for inListNode in @ClosedList
                if inListNode.x is point.x
                    if inListNode.y is point.y
                        #Save the index and break out!
                        indexOfNode = num
                        break
                num += 1
            if indexOfNode < 0
                #Not in ClosedList or OpenList. So we can add it!
                point.gVal = node.gVal + 1
                point.hVal = EuclideanDistance(point, @GoalPoint)
                point.fVal = point.gVal + point.hVal
                point.Parent = node
                @ClosedList.push point
            else
                #So the node is already in the ClosedList. Well, does ours have a better fVal?
                ourFval = node.gVal + 1 + EuclideanDistance(point, @GoalPoint)
                if ourFval < @ClosedList[indexOfNode]
                    #Yes, we should add!
                    #First remove the previous
                    @ClosedList.splice indexOfNode, 1
                    #And then we can add
                    point.gVal = node.gVal + 1
                    point.hVal = EuclideanDistance(point, @GoalPoint)
                    point.fVal = point.gVal + point.hVal
                    point.Parent = node
                    @ClosedList.push point
        
    search: (startPoint, goalPoint) ->
        @GoalPoint = goalPoint
        path = []
        if startPoint is goalPoint
            console.log "Start is Goal"
            return path
        #Make startPoint into a node
        startPoint.gVal = 0
        startPoint.hVal = EuclideanDistance(startPoint, goalPoint)
        startPoint.fVal = EuclideanDistance(startPoint, goalPoint)
        this.addToOpen startPoint
        
        reachedGoal = false
        
        while (@ClosedList.length)
            #Get min from the ClosedList and add it to the OpenList
            minFval = 9999999999
            currNode = null
            for node in @ClosedList
                if node.fVal < minFval
                    minFval = node.fVal
                    currNode = node
            #TODO - Smoothing? Ask Tansel for line by line of AStarSearch fxn in this location
            if currNode
                this.addToOpen currNode
                #If this is the goal, stop
                if currNode is goalPoint
                    console.log "Reached goal!"
                    reachedGoal = true
                    break
            else
                console.log "Closed list empty"
                break
        #Fill in Path somehow
        #Basically as you are searching, set the parent. Then load the Goal Point. If it costed less than infinity, then a path was found. Basically keep going back until you have reached parent.
        #Right now path isn't working because the search isn't working 100%
        if reachedGoal
            curr = goalPoint
            while curr != startPoint
                path.push curr
                curr = curr.Parent
            path.push startPoint
        return path
            
#Runner Code
#TODO add a timer
grid = new Grid(30, 20)
grid.createEmptyGrid()
start = {x:0, y:0}
goal = {x:14, y:11}
searchie = new AStarSearch("EuclideanDistance")
path = searchie.search(grid.Points[4][4], grid.Points[0][9])
console.log "Pathie"

#Print Path
for point in path
    console.log point.x, point.y

#console.log path
#console.log "Openie"
#console.log searchie.OpenList
#console.log "Closedie"
#console.log searchie.ClosedList