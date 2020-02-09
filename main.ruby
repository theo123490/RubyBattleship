class World 
    
    attr_accessor :players
    
    def initialize(numberOfPlayer, mapSize)
        @players = []
        for player in 1..numberOfPlayer
            @players << Player.new(mapSize)
        end
    end

    #playerN is player Number id

    def addShip(playerN,coordinates)
        @players[playerN].map.addShip(coordinates)
    end

    def hit?(playerN,coordinates)
        @players[playerN].map.theMap[coordinates[0]][coordinates[1]] == "="
    end

    def attack(attackerPlayerN, receiverPlayerN, coordinates)
        if self.hit?(receiverPlayerN, coordinates)
            self.players[attackerPlayerN].addpoints
            self.players[receiverPlayerN].map.theMap[coordinates[0]][coordinates[1]] = "X"
            print "IT HITS"
        else
            print "That doesnt hit boys"
        end
    end


end

class Player
    
    attr_accessor :points, :map
    
    def initialize(mapSize)
        @points = 0
        @map = Map.new(mapSize)
    end

    def addpoints
        @points +=1
    end
end

class Map
    
    attr_accessor :theMap
    
    def initialize(mapSize)
        @theMap = Array.new(mapSize[0]){Array.new(mapSize[1],".")}
    end

    #Adding a singleship
    def addShip(coordinates)
        @theMap[coordinates[0]][coordinates[1]] = "="
    end
    
    #adding multiple ships
    #where coordinates is an array of multiple array coordinates coordinates
    def addMultipleShips(multiCoordinates)
        for ships in 0..multiCoordinates.length-1
            self.addShip(multiCoordinates[ships])
        end
    end

end

game = World.new(3,[5,5])
p1ShipCoordinates = [[1,2],[2,2],[1,1]]
for n_coordinates in 0..p1ShipCoordinates.length-1
    game.addShip(0,p1ShipCoordinates[n_coordinates])
end
game.attack(1,0,[2,2])
