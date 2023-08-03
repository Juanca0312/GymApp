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
        
        self.exercises = self.exerciseManager.findByType(exerciseType: self.exerciseType!)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.CellIdentifier.exerciseCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifier.exerciseCell)
        
    }
    
    
    
    // MARK: - Add Exercise
    
    @IBAction func onAddExercisePressed(_ sender: Any) {
        let alert = alertSaveExerciseType()
        present(alert, animated: true)
    }
    
    func alertSaveExerciseType(_ exercise: Exercise? = nil) -> UIAlertController {
        
        var nameTextField = UITextField()
        var imageUrlTextField = UITextField()
        
        let alertTitle = exercise != nil ? "Update Exercise" : "Add Exercise"
        
        
        let alert =  UIAlertController(title:  alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let safeExercise = exercise {
                //update
                if let row = self.exercises.firstIndex(where: {$0.id == safeExercise.id}) {
                    self.exercises[row] = self.exerciseManager.update(exercise: safeExercise, newName: nameTextField.text!, newUrl: imageUrlTextField.text!)
                    self.showSuccessAlert(message: "Exercise updated successfully")
                }
                
                
            } else {
                //create
                self.exercises.append(self.exerciseManager.create(name: nameTextField.text!, imageUrl: imageUrlTextField.text!, exerciseType: self.exerciseType!))
                self.showSuccessAlert(message: "Exercise created successfully")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.exerciseCell, for: indexPath) as! ExerciseCell
        
        let exercise = exercises[indexPath.row] as Exercise
        cell.exerciseNameLabel.text = exercise.name
        
        //image from url
        if let exerciseImage = exercise.image_url, let imageURL = URL(string: exerciseImage) {
            cell.imageView?.load(url: imageURL) { result in
                if case .failure(_) = result {
                    cell.exerciseImage.image = UIImage(systemName: "dumbbell.fill")
                }
            }
        } else {
            cell.exerciseImage.image = UIImage(systemName: "dumbbell.fill")
        }
        
        
        return cell
    }
    
    
}

extension ExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //delete exercise
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this Exercise", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                let deletedExercise = self.exercises[indexPath.row]
                self.exerciseManager.delete(deletedExercise)
                self.exercises.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                completion(true)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
                completion(true)
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
            
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        
        //update exercise
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
            let exercise = self.exercises[indexPath.row]
            let alert = self.alertSaveExerciseType(exercise)
            
            self.present(alert, animated: true)
            completion(true)
            
        }
        updateAction.backgroundColor = .orange
        updateAction.image = UIImage(systemName: "pencil")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        return configuration
    }
}

