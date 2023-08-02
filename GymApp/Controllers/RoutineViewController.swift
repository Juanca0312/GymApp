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
    
    var weekRoutine = [Routine]()
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
        
        tableView.dataSource = self
        
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
        
        tableView.register(UINib(nibName: K.CellIdentifier.routineCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifier.routineCell)
        
    }
    
    func loadRoutine(weekday: DayOfWeek) {
        weekRoutine = routineManager.findByWeekday(weekday: weekday)
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
                
                
                
            } else {
                //create
                
                let selectedExercise = self.exercises[self.selectedExercise]
                let selectedWeekday = self.weekdays[self.selectedWeekday]
                let reps = Int(repsTextField.text!)!
                let sets = Int(setsTextField.text!)!
                let weight = Float(weightTextField.text!)!
                
                let createdWeekDay = self.routineManager.create(reps: reps, sets: sets, weight: weight, weekday: selectedWeekday , exercise: selectedExercise)
                
                if selectedWeekday == getCurrentWeekday() {
                    self.weekRoutine.append(createdWeekDay)
                    self.tableView.reloadData()
                }
                
                self.showSuccessAlert(message: "Routine exercise created successfully")
                
                
            }
            
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        
        alert.addTextField { textField in
            textField.inputView = self.exercisePicker
            textField.placeholder = "Select exercise"
            textField.text = self.exercises[self.selectedExercise].name
        }
        
        alert.addTextField { textField in
            textField.inputView = self.weekdayPicker
            textField.placeholder = "Select a weekday"
            textField.text = self.weekdays[self.selectedWeekday].rawValue
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type sets"
            textField.keyboardType = .numberPad
            setsTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type reps"
            textField.keyboardType = .numberPad
            repsTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type weight (kg)"
            textField.keyboardType = .decimalPad
            weightTextField = textField
        }
        
        return alert
        
    }
    
    
    
    
    
}

// MARK: - Table view data source

extension RoutineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekRoutine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.routineCell, for: indexPath) as! RoutineExerciseCell
        
        let routineExercise = weekRoutine[indexPath.row] as Routine
        
        if let exerciseImage = routineExercise.parent?.image_url, let imageURL = URL(string: exerciseImage) {
            cell.exerciseImageView?.load(url: imageURL)
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

