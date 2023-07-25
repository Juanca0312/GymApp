//
//  ExerciseTypeManager.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 24/07/23.
//

import Foundation
import CoreData
import UIKit

class ExerciseTypeManager {
    
    static let shared = ExerciseTypeManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func addExerciseType(name: String) -> ExerciseType {
        let newType = ExerciseType(context: context)
        newType.name = name
        self.saveItems()
        
        return newType
    }
    
    
    public func findExerciseTypes(_ request: NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()) -> [ExerciseType] {
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
            return []
        }
        
    }
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
    
    
}
