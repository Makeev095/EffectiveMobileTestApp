//
//  TaskDetailViewControllerDelegate.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
    func didSaveTask()
}

class TaskDetailViewController: UIViewController {
    weak var delegate: TaskDetailViewControllerDelegate?
    var taskEntity: TaskEntity?
    
    // UI элементы
    let titleField = UITextField()
    let descriptionField = UITextView()
    let completedSwitch = UISwitch()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        populateData()
    }
    
    func setupUI() {
        title = taskEntity == nil ? "Добавить задачу" : "Редактировать задачу"
        
        titleField.placeholder = "Название"
        titleField.borderStyle = .roundedRect
        descriptionField.layer.borderColor = UIColor.gray.cgColor
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.cornerRadius = 5
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        // Расположение элементов
        let stack = UIStackView(arrangedSubviews: [titleField, descriptionField, completedSwitch, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func populateData() {
        if let task = taskEntity {
            titleField.text = task.title
            descriptionField.text = task.taskDescription
            completedSwitch.isOn = task.isCompleted
        }
    }
    
    @objc func saveTask() {
        guard let titleText = titleField.text, !titleText.isEmpty else { return }
        let descriptionText = descriptionField.text ?? ""
        let isCompleted = completedSwitch.isOn
        let dateCreated = taskEntity?.dateCreated ?? Date()
        let id = taskEntity?.id ?? Int64(Date().timeIntervalSince1970)
        
        let task = Task(id: Int(id), todo: titleText, completed: isCompleted, userId: 1)
        
        if let taskEntity = taskEntity {
            // Обновление
            CoreDataManager.shared.updateTask(taskEntity, with: task)
        } else {
            // Добавление
            CoreDataManager.shared.addTask(from: task)
        }
        delegate?.didSaveTask()
        navigationController?.popViewController(animated: true)
    }
}
