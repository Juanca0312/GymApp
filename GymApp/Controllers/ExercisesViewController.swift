//
//  ExercisesViewController.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 26/07/23.
//

import UIKit
import CoreData

class ExercisesViewController: UIViewController {
    
    var exerciseType : ExerciseType? {
        didSet {
            DispatchQueue.main.async {
                self.exerciseTypeLabel.text = self.exerciseType!.name
            }
        }
    }

    @IBOutlet weak var exerciseTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
