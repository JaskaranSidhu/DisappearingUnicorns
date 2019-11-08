//
//  SettingsViewController.swift
//  DisappearingUnicorns
//
//  Created by Jaskaran Sidhu on 2019-10-04.
//  Copyright © 2019 Jaskaran Sidhu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var changeImage: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var backgroundSwitch: UISwitch!
    @IBOutlet weak var backgroundSegmentedControl: UISegmentedControl!
    @IBOutlet weak var gameSpeedSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var gameSpeedLabel: UILabel!
    @IBOutlet weak var bgColorCircle: UIImageView!
    @IBOutlet weak var outlineCircle: UIImageView!
    
    let playerDictionary = UserDefaults.standard
    let imagePicker = UIImagePickerController()
    
    var playerInfo: PlayerData?
    let gameData = GameData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.layer.cornerRadius = 5
        updateButton.layer.borderWidth = 1
        
        nameTextfield.text = playerDictionary.string(forKey: "Name")
        ageLabel.text = "Age: " + "\(playerDictionary.string(forKey: "Age") ?? "Enter age")"
        
        if(playerDictionary.string(forKey: "Color") == "Blue") {
            backgroundSegmentedControl.selectedSegmentIndex = 1
            bgColorCircle.tintColor = .blue
        } else if(playerDictionary.string(forKey: "Color") == "Green") {
            backgroundSegmentedControl.selectedSegmentIndex = 2
            bgColorCircle.tintColor = .green
        } else if(playerDictionary.string(forKey: "Color") == "Yellow") {
            backgroundSegmentedControl.selectedSegmentIndex = 3
            bgColorCircle.tintColor = .yellow
        } else {
            backgroundSegmentedControl.selectedSegmentIndex = 0
            bgColorCircle.tintColor = .red
        }
        
        if (playerDictionary.string(forKey: "BGSwitch") == "Off") {
            backgroundSwitch.isOn = false
            bgColorCircle.isHidden = true
            outlineCircle.isHidden = false
        } else {
            backgroundSwitch.isOn = true
            bgColorCircle.isHidden = false
            outlineCircle.isHidden = true
        }
        
        imagePicker.delegate = self
        
        
        if(playerDictionary.data(forKey: "Image") != nil) {
            myImage.image = UIImage(data: playerDictionary.data(forKey: "Image")!)
        } else {
            myImage.image = UIImage(named: "person")
        }
        
        gameSpeedLabel.text = "(" + "\(playerDictionary.string(forKey: "gameSpeed") ?? "1.00s / Round")" + "s / Round)"
    }
    
    @IBAction func getName() {
        let nameEntered: String = nameTextfield.text ?? "Please enter name"
        playerDictionary.set(nameEntered, forKey: "Name")
        
        
    }
    
    @IBAction func updateAge(_ sender: Any) {
        let ageEntered: String = ageTextfield.text ?? "Please enter age"
        
        let alert = UIAlertController(title: "Update Age", message: "Are you sure you want to update the age to " + ageEntered, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {action in
            self.playerDictionary.set(ageEntered, forKey: "Age")
            self.ageLabel.text = "Age: " + "\(self.playerDictionary.string(forKey: "Age") ?? "Enter age")"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("Updating age canceled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func BGSegmentedControl(_ sender: Any) {
        if(backgroundSegmentedControl.selectedSegmentIndex
            == 0) {
            playerDictionary.set("Red", forKey: "Color")
            bgColorCircle.tintColor = .red
        } else if(backgroundSegmentedControl.selectedSegmentIndex == 1) {
            playerDictionary.set("Blue", forKey: "Color")
            bgColorCircle.tintColor = .blue
        } else if(backgroundSegmentedControl.selectedSegmentIndex == 2) {
            playerDictionary.set("Green", forKey: "Color")
            bgColorCircle.tintColor = .green
        } else if(backgroundSegmentedControl.selectedSegmentIndex == 3) {
            playerDictionary.set("Yellow", forKey: "Color")
            bgColorCircle.tintColor = .yellow
        }
    }
    
    
    @IBAction func BGSwitch(_ sender: Any) {
        if(backgroundSwitch.isOn) {
            playerDictionary.set("On", forKey: "BGSwitch")
            bgColorCircle.isHidden = false
            outlineCircle.isHidden = true
        } else {
            playerDictionary.set("Off", forKey: "BGSwitch")
            bgColorCircle.isHidden = true
            outlineCircle.isHidden = false
        }
    }
    
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func changeGameSpeed(_ sender: Any) {
        playerDictionary.set(String(format: "%.2f", (Float(gameSpeedSlider.value))), forKey: "gameSpeed")
        
        
        gameSpeedLabel.text = "(" + "\(playerDictionary.string(forKey: "gameSpeed") ?? "1.00s / Round")" + "s / Round)"
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            myImage.image = image
            
            let pngImage = image.pngData()
            
            playerDictionary.set(pngImage, forKey: "Image")
            
            gameData.savePoints(0, for: playerDictionary.string(forKey: "Name") ?? "Guest Player", playerDictionary.data(forKey: "Image") ?? UIImage(named: "person")!.pngData()!)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
