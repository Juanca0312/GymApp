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
    
    
    // MARK: - Add new Exercise Type
    
    @IBAction func onAddTypePressed(_ sender: UIBarButtonItem) {
        
        let alert = alertUpdateOrCreateExerciseType()
        
        present(alert, animated: true)
        
    }
    
    
    // MARK: - Delete and Update Exercise Type
    
    // for swaping the row
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete exercise type
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this Exercise Type", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                let deletedExerciseType = self.exerciseTypes[indexPath.row]
                self.exerciseTypeManager.delete(deletedExerciseType)
                self.exerciseTypes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                completion(true)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(action)
            alert.addAction(cancelAction)
            
            
            
            self.present(alert, animated: true)
            
            
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        
        
        // update exercise type
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
            let exerciseType = self.exerciseTypes[indexPath.row]
            let alert = self.alertUpdateOrCreateExerciseType(exerciseType)
            
            self.present(alert, animated: true)
            completion(true)
        }
        
        updateAction.image = UIImage(systemName: "pencil")
        updateAction.backgroundColor = .orange
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        return configuration
    }
    
    
    func alertUpdateOrCreateExerciseType(_ exerciseType: ExerciseType? = nil) -> UIAlertController {
        
        var textField = UITextField()
        
        let alertTitle = exerciseType != nil ? "Update Exercise Type" : "Add Exercise Type"
        
        
        let alert =  UIAlertController(title:  alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let safeExerciseType = exerciseType {
                //update
                if let row = self.exerciseTypes.firstIndex(where: {$0.id == safeExerciseType.id}) {
                    self.exerciseTypes[row] = self.exerciseTypeManager.update(exerciseType: safeExerciseType, newName: textField.text!)
                }
                
            } else {
                //create
                self.exerciseTypes.append(self.exerciseTypeManager.create(name: textField.text!))
            }
            
            self.tableView.reloadData()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type name"
            alertTextField.text = exerciseType != nil ? exerciseType?.name : ""
            textField = alertTextField
        }
        
        return alert
        
    }
    
    
    
    // MARK: - Navigate to Exercises
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.typesToExercises, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ExercisesViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.exerciseType = exerciseTypes[indexPath.row]
        }
    }

    
    
}
