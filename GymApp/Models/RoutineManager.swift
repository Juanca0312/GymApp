//
//  RoutineManager.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 31/07/23.
//

import UIKit
import CoreData

class RoutineManager {
    static let shared = RoutineManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func create(reps: Int, sets: Int, weight: Float, weekday: DayOfWeek, exercise: Exercise) -> Routine {
        let newRoutine = Routine(context: context)
        newRoutine.dayweek = weekday.rawValue
        newRoutine.weight = weight
        newRoutine.parent = exercise
        newRoutine.sets = Int16(sets)
        
        self.saveContext()
        
        return newRoutine
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
}
