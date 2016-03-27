#Classes
class Corner
    constructor: (x, y, cornerType, cell) ->
        @x = x
        @y = y
        @cornerType = cornerType
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

class Cell
    constructor: (isObstacle) ->
        @isObstacle = isObstacle
        @northWest = null
        @northEast = null
        @southWest = null
        @southEast = null

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
        
    search: (startCorner, goalCorner) ->
        @GoalCorner = goalCorner
        path = []
        if startCorner is goalCorner
            console.log "Start is Goal"
            return path
        #Init values of startCorner
        startCorner.gVal = 0
        startCorner.hVal = EuclideanDistance(startCorner, goalCorner)
        startCorner.fVal = startCorner.hVal
        this.addToOpen startCorner
        
        reachedGoal = false
        
        while (@ClosedList.length)
            #Get min from the ClosedList and add it to the OpenList
            minFval = 9999999999
            currNode = null
            for node in @ClosedList
                if node.fVal < minFval
                    minFval = node.fVal
                    currNode = node
            if currNode
                this.addToOpen currNode
                #If this is the goal, stop
                if currNode is goalCorner
                    console.log "Reached goal!"
                    reachedGoal = true
                    break
            else
                console.log "Closed list empty"
                break
        #TODO Smoothing
        #Now Fill in Path
        #Basically as you are searching, set the parent. Then load the Goal Point. If it costed less than infinity, then a path was found. Basically keep going back until you have reached parent.
        if reachedGoal
            curr = goalPoint
            while curr != startPoint
                path.push curr
                curr = curr.Parent
            path.push startPoint
        return path.reverse()