//
//  ViewController.swift
//  DisappearingUnicorns
//
//  Created by Jaskaran Sidhu on 2019-09-29.
//  Copyright © 2019 Jaskaran Sidhu. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var gameButtons = [UIButton]()
    var gamePoints = 0
    var timer:Timer?
    var currentButton:UIButton!
    var state = GameState.gameOver // IS THIS THE ISSUE C - "var state: gameState? "
    
    let playerDictionary = UserDefaults.standard
    
    
    enum GameState {
        case gameOver
        case playing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if(playerDictionary.string(forKey: "BGSwitch") == "Off") {
            self.view.backgroundColor = .white
        } else {
            if(playerDictionary.string(forKey: "Color") == "Blue") {
                self.view.backgroundColor = .blue
            } else if(playerDictionary.string(forKey: "Color") == "Green") {
                self.view.backgroundColor = .green
            } else if(playerDictionary.string(forKey: "Color") == "Yellow") {
                self.view.backgroundColor = .yellow
            } else {
                self.view.backgroundColor = .red
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pointsLabel.isHidden = true
        
        gameButtons = [goodButton, badButton]
        
        if(playerDictionary.string(forKey: "BGSwitch") == "Off") {
            self.view.backgroundColor = .white
        } else {
            if(playerDictionary.string(forKey: "Color") == "Blue") {
                self.view.backgroundColor = .blue
            } else if(playerDictionary.string(forKey: "Color") == "Green") {
                self.view.backgroundColor = .green
            } else if(playerDictionary.string(forKey: "Color") == "Yellow") {
                self.view.backgroundColor = .yellow
            } else {
                self.view.backgroundColor = .red
            }
        }
        
        setupFreshGameState()
    }
    
    @IBAction func clicksettings(_ sender: UIBarButtonItem) {
        print("test")
    }
    
    func startNewGame() {
        startGameButton.isHidden = true
        leaderboardButton.isHidden = true
        gamePoints = 0
        updatePointsLabel(gamePoints)
        pointsLabel.textColor = .black
        pointsLabel.isHidden = false
        oneGameRound()
    }
    
    func oneGameRound() {
        updatePointsLabel(gamePoints)
        displayRandomButton()
        if(playerDictionary.data(forKey: "gameSpeed") == nil) {
            playerDictionary.set(1.00, forKey: "gameSpeed")
        }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(playerDictionary.float(forKey: "gameSpeed")), repeats: false) { _ in
            if self.state == GameState.playing {
                if self.currentButton == self.goodButton {
                    self.gameOver()
                } else {
                    self.oneGameRound()
                }
            }
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        print("Start game button was pressed")
        state = GameState.playing
        startNewGame()
    }
    
    @IBAction func goodPressed(_ sender: Any) {
        gamePoints = gamePoints + 1
        updatePointsLabel(gamePoints)
        goodButton.isHidden = true
        timer?.invalidate()
        oneGameRound()
    }
    
    @IBAction func badPressed(_ sender: Any) {
        badButton.isHidden = true
        timer?.invalidate()
        gameOver()
    }
    
    func displayRandomButton(){
        for myButton in gameButtons{
            myButton.isHidden = true
        }
        let buttonIndex = Int.random(in: 0..<gameButtons.count)
        currentButton = gameButtons[buttonIndex]
        currentButton.center = CGPoint(x: randomXCoordinate(), y: randomYCoordinate())
        currentButton.isHidden = false
    }
    
    func gameOver() {
        state = GameState.gameOver
        pointsLabel.textColor = .brown
        setupFreshGameState()
        let gameData = GameData()
        
        gameData.savePoints(gamePoints, for: playerDictionary.string(forKey: "Name") ?? "Guest Player", playerDictionary.data(forKey: "Image") ?? UIImage(named: "person")!.pngData()!)
    
    }
    
    func setupFreshGameState() {
        startGameButton.isHidden = false
        leaderboardButton.isHidden = false
        
        for mybutton in gameButtons {
            mybutton.isHidden = true
        }
        pointsLabel.alpha = 0.15
        currentButton = goodButton
        state = GameState.gameOver
        
    }
    func randCGFloat(_ min: CGFloat, _ max: CGFloat) -> CGFloat{
        return CGFloat.random(in: min..<max)
    }
    
    func randomXCoordinate() -> CGFloat {
        let left = view.safeAreaInsets.left + currentButton.bounds.width
        let right = view.bounds.width - view.safeAreaInsets.right - currentButton.bounds.width
        return randCGFloat(left, right)
    }
    func randomYCoordinate() -> CGFloat {
        let top = view.safeAreaInsets.top + currentButton.bounds.height
        let bottom = view.bounds.height - view.safeAreaInsets.bottom - currentButton.bounds.height
        return randCGFloat(top,bottom)
    }
    func updatePointsLabel(_ newValue: Int) {
        pointsLabel.text = "\(newValue)"
    }
    
}

