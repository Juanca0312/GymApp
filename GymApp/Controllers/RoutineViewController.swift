//
//  RoutineViewController.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 30/07/23.
//

import UIKit

class RoutineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDateLabel.text = getCurrentDate()
        initWeekdayButtons()
        
        
    }
    
    func initWeekdayButtons() {
        let currentWeekday = getCurrentWeekday()
        resetAllButtons()
        
        switch currentWeekday {
        case .sunday:
            sundayButton.tintColor = .systemBlue
        case .monday:
            mondayButton.tintColor = .systemBlue
        case .tuesday:
            tuesdayButton.tintColor = .systemBlue
        case .wednesday:
            wednesdayButton.tintColor = .systemBlue
        case .thursday:
            thursdayButton.tintColor = .systemBlue
        case .friday:
            fridayButton.tintColor = .systemBlue
        case .saturday:
            saturdayButton.tintColor = .systemBlue
        default:
            print("No weekday")
        }
    }
    
    private func resetAllButtons() {
        mondayButton.tintColor = .gray
        tuesdayButton.tintColor = .gray
        wednesdayButton.tintColor = .gray
        thursdayButton.tintColor = .gray
        fridayButton.tintColor = .gray
        saturdayButton.tintColor = .gray
        sundayButton.tintColor = .gray
    }
    
    @IBAction func onWeekdayPressed(_ sender: UIButton) {
        resetAllButtons()
        
        sender.tintColor = .systemBlue
    }
    
    
    
    
    
}
