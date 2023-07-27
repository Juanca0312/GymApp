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
    var exercises = [Exercise]()
    let exerciseManager = ExerciseManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Add Exercise
    
    @IBAction func onAddExercisePressed(_ sender: Any) {
        let alert = alertUpdateOrCreateExerciseType()
        present(alert, animated: true)
    }
    
    func alertUpdateOrCreateExerciseType(_ exercise: Exercise? = nil) -> UIAlertController {
        
        var nameTextField = UITextField()
        var imageUrlTextField = UITextField()
        
        let alertTitle = exercise != nil ? "Update Exercise" : "Add Exercise"
        
        
        let alert =  UIAlertController(title:  alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let safeExerciseType = exercise {
                //update
                
                
            } else {
                //create
                self.exercises.append(self.exerciseManager.create(name: nameTextField.text!, imageUrl: imageUrlTextField.text!, exerciseType: self.exerciseType!))
            }
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type name"
            alertTextField.text = exercise != nil ? exercise?.name : ""
            nameTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type image url"
            alertTextField.text = exercise != nil ? exercise?.image_url : ""
            imageUrlTextField = alertTextField
        }
        
        return alert
        
    }
    

}

// MARK: - Table view data source


extension ExercisesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.exerciseCell, for: indexPath)
        
        let type = exercises[indexPath.row] as Exercise
        cell.textLabel?.text = type.name
        
        return cell
    }
    
}
