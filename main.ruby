
#TODO: ADD THE DOCUMENTATION!!!!!!!!!!!!!


class World 
    
    attr_accessor :players
    
    def initialize(numberOfPlayer, mapSize, numberOfShips)
        @players = []
        for player in 1..numberOfPlayer
            @players << Player.new(mapSize,numberOfShips)
        end
    end

    def totalShip
        @players.inject(0) {|shipSum,player| shipSum+player.shipsLeft}
    end

    
    def totalEnemyShip(selfN)
        enemy = @players.clone
        enemy.delete_at(selfN)
        return enemy.inject(0) {|shipSum,player| shipSum+player.shipsLeft}
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
            self.players[attackerPlayerN].addPoints
            self.players[receiverPlayerN].destroyShip(coordinates)
            puts "IT HITS"
        else
            puts "THAT DOESN'T HITS"
        end
    end

    def getStats
        i=0
        @players.each do |player|
           i += 1
           puts "*******************"
           puts "PLAYER #{i}"
           puts "*******************"
           puts "points: #{player.points}"
           puts "ships left: #{player.shipsLeft}"
           puts "*******************"
        end
    end
end

class Player
    
    attr_accessor :points, :map, :shipsLeft 
    
    def initialize(mapSize, numberOfShips)
        @points = 0
        @shipsLeft = numberOfShips
        @map = Map.new(mapSize)
    end

    def destroyShip(coordinates)
        @map.theMap[coordinates[0]][coordinates[1]] = "X"
        @shipsLeft -= 1
    end

    def addPoints
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

class Game
    def initialize
        self.createGame
        self.addShips
        self.attackSession        
    end

    def createGame
        #Creating the world 
        puts "How many are playing?"
        @nOfPlayer = STDIN.gets.to_i
        puts "How big is the map?"
        puts "X : "
        x = STDIN.gets.to_i
        puts "Y : "
        y = STDIN.gets.to_i
        @mapSize = [x,y]
        puts "Number of Ships"
        @nOfShips = STDIN.gets.to_i

        @gameWorld = World.new(@nOfPlayer,@mapSize, @nOfShips)
    end

    def getCoordinate
        begin 
            stringCoordinate = STDIN.gets
            coordinateParsed = stringCoordinate.split(",")
            if coordinateParsed.length != 2
                raise "coordinate is less/more than 2"
            end
            coordinate = coordinateParsed.map{|item| item.to_i}            
            return coordinate            
        rescue
            puts "Input The format as X,Y"
            getCoordinate
        end
    end

    
    def addShips
        #adding the ships
        for i in 0..@nOfPlayer-1
            puts "PLayer #{i+1} place your ship in x,y format"
            for j in 1..@nOfShips
                puts "Ships #{j}:"
                self.addingEachShips(i)
            end
        end
    end

    def addingEachShips(playerN)
        #adding individual ship
        #TODO: you cannot add if coordinates have ship inside
        coordinate = self.getCoordinate
        @gameWorld.addShip(playerN,[coordinate[0]-1,coordinate[1]-1])
    end


    def attackSession
        puts "Game Start"

        whoseTurn = -1


        while @gameWorld.totalEnemyShip(whoseTurn) > 0
            whoseTurn +=1            
    
            if whoseTurn>@nOfPlayer-1
                whoseTurn = 0
            end
    
            if @gameWorld.players[whoseTurn].shipsLeft <= 0
                puts "Player #{whoseTurn+1} have no more ships"
            else
                puts "************"
                puts "Player #{whoseTurn+1}"
                puts "************"

                #TODO: if player attack itself ask for confirmation
                #TODO: if player attack a losing player ask for confirmation
                #TODO: check if receiver loses and make an announcement
                #TODO: Create a loser status maybe?
        
                #restart player to 1 when everyone finished their turn
                
                puts "attack Who?"
                target = STDIN.gets
                target = target.to_i

                puts "coordinates?"
                launchCoordinates = self.getCoordinate

                puts "launching \n \n"
                @gameWorld.attack(whoseTurn,target-1,launchCoordinates.map{|where| where-1})

                puts "enemy left : #{@gameWorld.totalEnemyShip(whoseTurn)}"
                puts"Ship left : "
                playerCounter = 1
                @gameWorld.players.each do |player|
                    puts "Player #{playerCounter}: #{player.shipsLeft}"
                    playerCounter+=1
                end
            end
        end

        puts "*********************************"
        puts "PLAYER #{whoseTurn+1} WINS!!!!!!!!"
        puts "*********************************\n\n\n"

        
    end

end


Game.new()

