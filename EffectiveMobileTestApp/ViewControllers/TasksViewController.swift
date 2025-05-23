//
//  TasksViewController.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import UIKit
import CoreData

class TasksViewController: UITableViewController {
    var tasks: [TaskEntity] = []
    var filteredTasks: [TaskEntity] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список задач"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        setupSearchController()
        loadTasks()
        fetchAndSyncFromAPI()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func loadTasks() {
        tasks = CoreDataManager.shared.fetchTasks()
        tableView.reloadData()
    }
    
    func fetchAndSyncFromAPI() {
        APIService.shared.fetchTodos { [weak self] apiTasks in
            guard let self = self else { return }
            // Добавляем новые задачи из API
            for task in apiTasks {
                if !self.tasks.contains(where: { $0.id == Int64(task.id) }) {
                    CoreDataManager.shared.addTask(from: task)
                }
            }
            self.loadTasks()
        }
    }
    
    @objc func addTask() {
        let detailVC = TaskDetailViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredTasks.count : tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TaskCell")
        let task = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.taskDescription
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskEntity = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        let detailVC = TaskDetailViewController()
        detailVC.taskEntity = taskEntity
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = isFiltering() ? filteredTasks[indexPath.row] : tasks[indexPath.row]
            CoreDataManager.shared.deleteTask(task)
            loadTasks()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTasks = tasks.filter { task in
            (task.title?.lowercased().contains(searchText.lowercased()))! ||
            ((task.taskDescription?.lowercased().contains(searchText.lowercased())) != nil)
        }
        tableView.reloadData()
    }
}

extension TasksViewController: TaskDetailViewControllerDelegate {
    func didSaveTask() {
        loadTasks()
    }
}

extension TasksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}

