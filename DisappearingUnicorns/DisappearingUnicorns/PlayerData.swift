//
//  PlayerData.swift
//  DisappearingUnicorns
//
//  Created by Jaskaran Sidhu on 2019-09-30.
//  Copyright © 2019 Jaskaran Sidhu. All rights reserved.
//

import Foundation
import UIKit

/// A more accessible representation of player information stored in Core Data.
class PlayerData: NSObject {
    var name:String
    var points: Int
    var rank:Int
    var photo:UIImage?
    
    init(name:String, points:Int, rank:Int, photo:UIImage?) {
        self.name = name
        self.points = points
        self.rank = rank
        self.photo = photo
    }
    
    init(player:Player, rank:Int) {
        self.name = player.name!
        self.points = Int(player.points)
        self.rank = rank
        self.photo = UIImage(data: player.photo!)
    }
}
