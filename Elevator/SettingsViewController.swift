//
//  SettingsViewController.swift
//  Elevator
//
//  Created by Artur Guseinov on 12/07/2017.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var floorCountSlider:        UISlider!
    @IBOutlet weak var floorCountCurrentLabel:  UILabel!
    @IBOutlet weak var floorCountMaxLabel:      UILabel!
    
    @IBOutlet weak var floorHeightSlider:       UISlider!
    @IBOutlet weak var floorHeightCurrentLabel: UILabel!
    @IBOutlet weak var floorHeightMaxLabel:     UILabel!
    
    @IBOutlet weak var speedTextField:          UITextField!
    @IBOutlet weak var doorIntervalTextField:   UITextField!
    
    var settings = Settings() {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedTextField.delegate = self
        doorIntervalTextField.delegate = self
        
        floorCountSlider.minimumValue = Float(Constants.minFloorCount)
        floorCountSlider.maximumValue = Float(Constants.maxFloorCount)
        
        floorHeightSlider.minimumValue = Constants.minFloorHeight
        floorHeightSlider.maximumValue = Constants.maxFloorHeight
        
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ElevatorViewController else { return }
        
        destination.elevator = Elevator(settings: settings)
    }
    
    @IBAction func floorCountChanged(_ sender: UISlider) {
        settings.floorCount = Int(sender.value)
    }
    
    @IBAction func floorHeightChanged(_ sender: UISlider) {
        settings.floorHeight = sender.value
    }
    
    @IBAction func speedChanged(_ sender: UITextField) {
        guard let text = sender.text, let intValue = Float(text) else {
            sender.text = "\(settings.speed)"
            return
        }
        
        settings.speed = intValue
    }
    
    @IBAction func doorIntervalChanged(_ sender: UITextField) {
        guard let text = sender.text, let intValue = Float(text) else {
            sender.text = "\(settings.doorInterval)"
            return
        }
        
        settings.doorInterval = intValue
    }
    
    func updateView() {
        floorCountCurrentLabel.text  = "\(settings.floorCount)"
        floorHeightCurrentLabel.text = "\(settings.floorHeight) м"
        doorIntervalTextField.text   = "\(settings.doorInterval)"
        speedTextField.text          = "\(settings.speed)"
    }
}


// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
}
