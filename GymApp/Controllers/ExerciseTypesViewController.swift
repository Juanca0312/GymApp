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
        exerciseTypes = exerciseTypeManager.fetch()
        
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
    
    // for swaping the row
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Add new Exercise Type
    
    @IBAction func onAddTypePressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Exercise Type", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            self.exerciseTypes.append(self.exerciseTypeManager.create(name: textField.text!))
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
    
    // MARK: - Delete Exercise Type
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedExerciseType = exerciseTypes[indexPath.row]
            exerciseTypeManager.delete(deletedExerciseType)
            exerciseTypes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    

    

    
    
}
