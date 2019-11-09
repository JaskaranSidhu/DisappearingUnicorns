import Foundation
import UIKit
import CoreData

/// A class used for managing all interactions with the CoreData leaderbaord for the game.
internal class GameData : NSObject {

    /// The CoreData context used for persisting leaderboard data
    private var context:NSManagedObjectContext!
    
    
    /// The number of players in the leaderboard
    internal var numberOfPlayers:Int {
        get{
            do {
                // Fetch all of the previously saved player data from CoreData
                let allPlayerData = try context.fetch(Player.fetchRequest()) as! [Player]
                return allPlayerData.count
                
            } catch {
                print("Unable to fetch player data from CoreData: " + error.localizedDescription)
                fatalError()
            }
        }
    }
    
    override init() {
        
        // Set up the CoreData context
        let container = NSPersistentContainer(name: "GameData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error with loading CoreData: " + error.localizedDescription)
            }
        })
        context = container.viewContext
    }
    
    internal func deletePlayer(_ rank: Int, for name: String) {
        
        do {
            let allPlayerData =  try context.fetch(Player.fetchRequest()) as! [Player]
        
            var i = 0
            while(allPlayerData[i].name != name) {
                i = i + 1
            }
            context.delete(allPlayerData[i])
            try context.save()
        } catch {
            print("Error in all player data")
        }
    }
    
    /**
        Updates and saves points to the leader board for a particular player. If the player is currently not in the leaderboard, they a new entry with their name will be added.
        - Parameters:
            - points: The number of points scored by the player
            - name: The name of the player to update on the leaderboard
         */
    internal func savePoints(_ points: Int, for name:String,_ img: Data){
        do {
            // Fetch all of the previously saved player data from CoreData
            let allPlayerData =  try context.fetch(Player.fetchRequest()) as! [Player]
            
            // Check if a player with that name has already been saved and update their high score
            if let savingPlayer = allPlayerData.filter({$0.name == name}).first{
                savingPlayer.photo = img
                if savingPlayer.points < points{
                    savingPlayer.points = Int64(points)
                }
            }
            // Otherwise, if the player is new, create a new entry in CoreData
            else{
                let savingPlayer = Player(context: context)
                savingPlayer.name = name
                savingPlayer.points = Int64(points)
                savingPlayer.photo = img
                
            }
        } catch {
            print("Unable to fetch player data from CoreData: " + error.localizedDescription)
        }
        
        // Save the changes made to Core Data
        do {
            try context.save()
        } catch {
            print("Unable to save data to CoreData: " + error.localizedDescription)
        }
    }
    
    /**
         Updates and saves points to the leader board for a particular player. If the player is currently not in the leaderboard, they a new entry with their name will be added.
         - Parameters:
            - rank: The rank of the player on the leaderboard to fetch
        - Returns:
            - playerData: The PlayerData representation of the player for that particular rank with name, points, rank, and photo data
        - Throws:  A fatal error will be thrown if the index of the rank is out of bounds
         */
    internal func playerData(forRank rank: Int) -> PlayerData{
        do {
            // Fetch all of the previously saved player data from CoreData and sort it in accending order by points scored
            var allPlayerData = try context.fetch(Player.fetchRequest()) as! [Player]
            allPlayerData.sort (by: { $0.points > $1.points })
            
            // Return a PlayerData representation of the player
            return PlayerData(player: allPlayerData[rank], rank: rank)
            
        } catch {
            print("Unable to fetch player data from CoreData: " + error.localizedDescription)
            fatalError()
        }
    }
}
