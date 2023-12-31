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
    
    var routineExercises = [Routine]()
    var exercises : [Exercise] {
        exerciseManager.findAll()
    }
    var weekdays : [DayOfWeek] {
        getWeekDays()
    }
    
    var exercisePicker = UIPickerView()
    var selectedExercise: Int = 0
    
    var weekdayPicker = UIPickerView()
    var selectedWeekday: Int = 0
    
    let routineManager = RoutineManager.shared
    let exerciseManager = ExerciseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisePicker.delegate = self
        exercisePicker.dataSource = self
        exercisePicker.tag = 1
        weekdayPicker.delegate = self
        weekdayPicker.dataSource = self
        weekdayPicker.tag = 2
        
        currentDateLabel.text = getCurrentDate()
        initWeekdayButtons()
        loadRoutine(weekday: getCurrentWeekday()!)
        
        mondayButton.tag = 1
        tuesdayButton.tag = 2
        wednesdayButton.tag = 3
        thursdayButton.tag = 4
        fridayButton.tag = 5
        saturdayButton.tag = 6
        sundayButton.tag = 7
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.CellIdentifier.routineCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifier.routineCell)
        
        
    }
    
    func loadRoutine(weekday: DayOfWeek) {
        routineExercises = routineManager.findByWeekday(weekday: weekday)
        tableView.reloadData()
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
        
        let tag = sender.tag
        
        if let weekday = DayOfWeek(tagValue: tag) {
            loadRoutine(weekday: weekday)
        }
        
        
    }
    
    //add routine exercise
    
    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        
        if exercises.isEmpty {
            let alert = UIAlertController(title: "No exercises created", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        let alert = alertSaveRoutineExercise()
        present(alert, animated: true)
    }
    
    
    func alertSaveRoutineExercise(_ routineExercise: Routine? = nil) -> UIAlertController {
        
        let alertTitle = routineExercise != nil ? "Update Routine Exercise" : "Add Routine Exercise"
        
        var weightTextField = UITextField()
        var setsTextField = UITextField()
        var repsTextField = UITextField()
        
        
        let alert =  UIAlertController(title:  alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let safeRoutineExercise = routineExercise {
                //update
                
                let selectedExercise = self.exercises[self.selectedExercise]
                let selectedWeekday = self.weekdays[self.selectedWeekday]
                let reps = Int(repsTextField.text!)!
                let sets = Int(setsTextField.text!)!
                let weight = Float(weightTextField.text!)!
                
                if let row = self.routineExercises.firstIndex(where: {$0.id == safeRoutineExercise.id}) {
                    self.routineExercises[row] = self.routineManager.update(routineExercise: safeRoutineExercise, reps: reps, sets: sets, weight: weight, weekday: selectedWeekday, exercise: selectedExercise)
                    self.resetPickers()
                    self.showSuccessAlert(message: "Routine exercise updated successfully")
                }
                
                
            } else {
                //create
                
                let selectedExercise = self.exercises[self.selectedExercise]
                let selectedWeekday = self.weekdays[self.selectedWeekday]
                let reps = Int(repsTextField.text!)!
                let sets = Int(setsTextField.text!)!
                let weight = Float(weightTextField.text!)!
                
                let createdRoutineExercise = self.routineManager.create(reps: reps, sets: sets, weight: weight, weekday: selectedWeekday , exercise: selectedExercise)
                
                print(createdRoutineExercise)
                
                if selectedWeekday == getCurrentWeekday() {
                    self.routineExercises.append(createdRoutineExercise)
                }
                
                self.resetPickers()
                self.showSuccessAlert(message: "Routine exercise created successfully")
                
                
            }
            self.tableView.reloadData()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        var selectedExercise = self.selectedExercise
        
        
        alert.addTextField { textField in
            
            if let safeRoutineExercise = routineExercise, let row = self.exercises.firstIndex(where: {$0.id == safeRoutineExercise.parent!.id}) {
                self.selectedExercise = row
                selectedExercise = row
                self.exercisePicker.selectRow(row, inComponent: 0, animated: true)
            }
            
            textField.inputView = self.exercisePicker
            textField.text = self.exercises[selectedExercise].name
        }
        
        alert.addTextField { textField in
            
            if let safeRoutineExercise = routineExercise, let row = self.weekdays.firstIndex(where: {$0.rawValue == safeRoutineExercise.dayweek}) {
                self.selectedWeekday = row
                selectedExercise = row
                self.weekdayPicker.selectRow(row, inComponent: 0, animated: true)
            }
            
            textField.inputView = self.weekdayPicker
            textField.text = self.weekdays[self.selectedWeekday].rawValue
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type sets"
            textField.keyboardType = .numberPad
            if let safeRoutineExercise = routineExercise {
                textField.text = "\(safeRoutineExercise.sets)"
            }
            setsTextField = textField
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type reps"
            textField.keyboardType = .numberPad
            if let safeRoutineExercise = routineExercise {
                textField.text = "\(safeRoutineExercise.reps)"
            }
            repsTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type weight (kg)"
            if let safeRoutineExercise = routineExercise {
                textField.text = "\(safeRoutineExercise.weight)"
            }
            textField.keyboardType = .decimalPad
            weightTextField = textField
        }
        
        return alert
        
    }
    
    
    
    
    
}

// MARK: - Table view data source

extension RoutineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.routineCell, for: indexPath) as! RoutineExerciseCell
        
        let routineExercise = routineExercises[indexPath.row] as Routine
        
        if let exerciseImage = routineExercise.parent?.image_url, let imageURL = URL(string: exerciseImage) {
            cell.exerciseImageView?.load(url: imageURL) { result in
                if case .failure(_) = result {
                    cell.exerciseImageView.image = UIImage(systemName: "dumbbell.fill")
                    
                }
            }
        } else {
            cell.exerciseImageView.image = UIImage(systemName: "dumbbell.fill")
        }
        
        
        
        cell.exerciseNameLabel.text = "\(routineExercise.parent?.name ?? "ejercicio" )"
        cell.seriesRepsLabel.text = "\(routineExercise.sets) sets x \(routineExercise.reps) reps"
        cell.weightLabel.text = "\(routineExercise.weight) kg."
        
        return cell
        
    }
}

// MARK: - PickerView para Exercises Picker

extension RoutineViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return exercises.count
        case 2:
            return weekdays.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return exercises[row].name
        case 2:
            return weekdays[row].rawValue
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch pickerView.tag {
        case 1:
            if let alert = presentedViewController as? UIAlertController,
               let textField = alert.textFields?.first {
                textField.text = exercises[row].name
                textField.resignFirstResponder()
                selectedExercise = row
            }
        case 2:
            if let alert = presentedViewController as? UIAlertController,
               let textField = alert.textFields?[1] {
                textField.text = weekdays[row].rawValue
                textField.resignFirstResponder()
                selectedWeekday = row
            }
        default:
            print("Picker not found")
        }
        
    }
}

// MARK: - Table view delegate
extension RoutineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //delete routine exercise
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let alert = UIAlertController(title: "Are you sure you want to remove this exercise from your routine?", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                let deletedExercise = self.routineExercises[indexPath.row]
                self.routineManager.delete(deletedExercise)
                self.routineExercises.remove(at: indexPath.row)
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
        
        //update routine exercise
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
            let routineExercise = self.routineExercises[indexPath.row]
            let alert = self.alertSaveRoutineExercise(routineExercise)
            
            self.present(alert, animated: true)
            completion(true)
        }
        updateAction.backgroundColor = .orange
        updateAction.image = UIImage(systemName: "pencil")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        return configuration
        
    }
    
    private func resetPickers() {
        selectedExercise = 0
        selectedWeekday = 0
        
        exercisePicker.selectRow(0, inComponent: 0, animated: false)
        weekdayPicker.selectRow(0, inComponent: 0, animated: false)
    }
}


