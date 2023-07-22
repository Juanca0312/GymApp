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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let newType = ExerciseType(context: self.context)
            newType.name = textField.text!
            self.exerciseTypes.append(newType)
            
            self.saveItems()
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
    
    // MARK: - CoreData methods
    
    func loadItems(_ request: NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()) {
        
        do {
            exerciseTypes = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}
