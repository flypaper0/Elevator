//
//  ElevatorService.swift
//  Elevator
//
//  Created by Artur Guseinov on 13/07/2017.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

import UIKit

protocol ElevatorServiceDelegate: class {
    func elevatorOutput(description: String)
}

class ElevatorService {
    
    enum Action {
        case noTasks
        case doorClosing
        case doorOpening
        case routeCompleted
        case passes(floor: Int)
        case arrived(floor: Int)
        
        var descriprion: String {
            switch self {
            case .noTasks:
                return "Нет задач"
            case .doorClosing:
                return "Двери закрываются"
            case .doorOpening:
                return "Двери открываются"
            case .routeCompleted:
                return "Маневр завершен"
            case .passes(let floor):
                return "Проезжаем \(floor) этаж"
            case .arrived(let floor):
                return "Прибыли на \(floor) этаж"
            }
        }
    }
    
    typealias Task = (isOutside: Bool, floor: Float)
    
    fileprivate weak var delegate: ElevatorServiceDelegate?
    
    fileprivate var elevator: Elevator
    fileprivate var tasks = [Task]()
    fileprivate var timer: Timer!
    
    fileprivate var counter: Float = 0
    
    init(elevator: Elevator, delegate: ElevatorServiceDelegate) {
        self.elevator = elevator
        self.delegate = delegate
    }
    
    func stop() {
        timer.invalidate()
        timer = nil
    }
    
    func start() {
        
        if !elevator.isDoorClosed {
            counter = -elevator.settings.doorInterval
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.timerUpdateInterval), repeats: true) { timer in
            self.delegate?.elevatorOutput(description: self.timeFunction().descriprion)
        }

    }
    
    func addTask(isOutside: Bool, floor: Float) {
        tasks.append((isOutside, floor))
    }

}


// MARK: - Private Methods

extension ElevatorService {
    
    fileprivate func timeFunction() -> Action {
        
        guard let task = tasks.first else {
            return .noTasks
        }
        
        guard task.floor != elevator.currentFloor else {
            tasks.remove(at: 0)
            return .noTasks
        }
        
        counter = counter + Constants.timerUpdateInterval
        
        let delta = abs(elevator.currentFloor - task.floor)
        let path = delta * elevator.settings.floorHeight
        let pathTime = path / elevator.settings.speed
        
        guard counter < pathTime + elevator.settings.doorInterval else {
            counter = -elevator.settings.doorInterval
            elevator.currentFloor = task.floor
            tasks.remove(at: 0)
            return .routeCompleted
        }
        
        if counter < 0 {
            return .doorClosing
        }
        
        if counter > pathTime {
            return .doorOpening
        }
        
        let s = counter * elevator.settings.speed
        
        // -1: down; 1: up
        let direction: Float = elevator.currentFloor - task.floor > 0 ? -1 : 1
        let currentFloor = elevator.currentFloor + direction * s / elevator.settings.floorHeight
        
        if direction * currentFloor >= direction * task.floor {
            return .arrived(floor: Int(task.floor))
        }
        
        return .passes(floor: Int(currentFloor))
        
    }
    
}
