//
//  CoreDataManager.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func fetchTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func addTask(from task: Task) {
        let context = persistentContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.id = Int64(task.id)
        entity.title = task.todo
        entity.taskDescription = "" // Можно оставить пустым или добавить поле
        entity.dateCreated = Date()
        entity.isCompleted = task.completed
        saveContext()
    }
    
    func deleteTask(_ task: TaskEntity) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
    
    func updateTask(_ task: TaskEntity, with taskData: Task) {
        task.title = taskData.todo
        task.isCompleted = taskData.completed
        saveContext()
    }
}
