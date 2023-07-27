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
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
}
