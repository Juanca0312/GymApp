//
//  ExerciseTypesViewController.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 21/07/23.
//

import UIKit
import CoreData

class ExerciseTypesViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var exerciseTypes = [ExerciseType]()
    let exerciseTypeManager = ExerciseTypeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTypes = exerciseTypeManager.findExerciseTypes()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.exerciseTypeCellIdentifier, for: indexPath)
        
        let type = exerciseTypes[indexPath.row] as ExerciseType
        cell.textLabel?.text = type.name
        
        return cell
    }
    
    // MARK: - Add new Exercise Type
    
    @IBAction func onAddTypePressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Exercise Type", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            self.exerciseTypes.append(self.exerciseTypeManager.addExerciseType(name: textField.text!))
            self.tableView.reloadData()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type name"
            textField = alertTextField
        }
        
        present(alert, animated: true)
        
    }
    

    

    
    
}
