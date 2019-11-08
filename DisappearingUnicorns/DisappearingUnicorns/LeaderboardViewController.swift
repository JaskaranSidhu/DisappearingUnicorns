//
//  LeaderboardViewController.swift
//  DisappearingUnicorns
//
//  Created by Jaskaran Sidhu on 2019-09-30.
//  Copyright © 2019 Jaskaran Sidhu. All rights reserved.
//

import UIKit

class LeaderboardViewController: UITableViewController {
    
    let gameData = GameData()
    
    let playerDictionary = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameData.numberOfPlayers
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        let playerRank = indexPath.row
        let playerInfo = gameData.playerData(forRank: playerRank)
        
        cell.textLabel?.text = playerInfo.name
        cell.detailTextLabel?.text = String(playerInfo.points)
        
        
        cell.imageView?.image = playerInfo.photo

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let playerRank = indexPath.row
            let playerInfo = gameData.playerData(forRank: playerRank)
            gameData.deletePlayer(playerRank, for: playerInfo.name)
            print("playerRank: " + "\(playerRank)")
            print("playerInfo.name: " + "\(playerInfo.name)")
            print("indexPath: " + "\(indexPath)")
            //tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let playerRank = indexPath.row
        let playerInfo = gameData.playerData(forRank: playerRank)
        
        playerInfo.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
      }
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let playerRank = tableView.indexPathForSelectedRow!.row
        let playerDetails = gameData.playerData(forRank: playerRank)
        
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.playerInfo = playerDetails
    }
    

}
