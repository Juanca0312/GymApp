//
//  ExerciseManager.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 26/07/23.
//

import UIKit
import CoreData

class ExerciseManager {
    static let shared = ExerciseManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func create(name: String,imageUrl: String, exerciseType: ExerciseType) -> Exercise {
        let newExercise = Exercise(context: context)
        newExercise.name = name
        newExercise.image_url = imageUrl
        newExercise.parent = exerciseType
        
        self.saveContext()
        
        return newExercise
    }
    
    public func findByType(exerciseType: ExerciseType) -> [Exercise] {
        
        do {
            let request = Exercise.fetchRequest()
            request.predicate = NSPredicate(format: "parent = %@", exerciseType)
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
