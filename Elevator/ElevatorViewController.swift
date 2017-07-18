//
//  ElevatorViewController.swift
//  Elevator
//
//  Created by Artur Guseinov on 13/07/2017.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

import UIKit

class ElevatorViewController: UIViewController {
    
    @IBOutlet weak var inputSegmenged: UISegmentedControl!
    @IBOutlet weak var outputLabel: UILabel!
    
    lazy var service: ElevatorService = ElevatorService(elevator: self.elevator, delegate: self)
    
    var elevator: Elevator!
    var isOutside: Bool {
        return inputSegmenged.selectedSegmentIndex == 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        service.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        service.stop()
    }
}

// MARK: - ElevatorServiceDelegate

extension ElevatorViewController: ElevatorServiceDelegate {

    func elevatorOutput(description: String) {
        outputLabel.text = description
    }
}


// MARK: - UICollectionView

extension ElevatorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        cell.label.text = "\(indexPath.row + 1)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(elevator.settings.floorCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.width / CGFloat(3)
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        service.addTask(isOutside: isOutside, floor: Float(indexPath.row + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize()
    }
    
}
