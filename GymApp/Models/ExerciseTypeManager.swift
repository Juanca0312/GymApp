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
    
    public func create(name: String) -> ExerciseType {
        let newType = ExerciseType(context: context)
        newType.name = name
        self.saveContext()
        
        return newType
    }
    
    public func update(exerciseType: ExerciseType, newName: String) -> ExerciseType {
        exerciseType.name = newName
        self.saveContext()
        return exerciseType
    }
    
    
    public func fetch(_ request: NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()) -> [ExerciseType] {
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
            return []
        }
        
    }
    
    public func delete(_ exerciseType: ExerciseType) {
        context.delete(exerciseType)
        self.saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
    
    
}
