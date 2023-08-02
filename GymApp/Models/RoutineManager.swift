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
        newRoutine.reps = Int16(reps)
        
        self.saveContext()
        
        return newRoutine
    }
    
    public func findByWeekday(weekday: DayOfWeek) -> [Routine] {
        
        
        let request = Routine.fetchRequest()
        request.predicate = NSPredicate(format: "dayweek MATCHES %@", weekday.rawValue)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
            return []
        }
        
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
}
