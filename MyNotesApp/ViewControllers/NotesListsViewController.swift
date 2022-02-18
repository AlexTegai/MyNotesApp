//
//  NotesListsViewController.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import RealmSwift

class NotesListsViewController: UITableViewController {

    private var notesLists: Results<NotesList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesLists = StorageManager.shared.realm.objects(NotesList.self)
        createTestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesListCell", for: indexPath)
        let notesList = notesLists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = notesList.name
        content.secondaryText = "\(notesList.notes.count)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let notesList = notesLists[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            StorageManager.shared.delete(notesList: notesList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "edit") { _, _, isDone in
            self.showAlert(with: notesList) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let notesListVC = segue.destination as? NotesListViewController
        else { return }
        let notesList = notesLists[indexPath.row]
        
        notesListVC.notesList = notesList
    }
    
    @IBAction func addNewNotesList(_ sender: Any) {
        showAlert()
    }
    
    private func createTestData() {
        DataManager.shared.createTestData {
            self.tableView.reloadData()
        }
    }

}

// MARK: - Alert Settings

extension NotesListsViewController {

    private func showAlert(with notesList: NotesList? = nil, completion: (() -> Void)? = nil) {
        let title = notesList != nil ? "Edit Notes List" : "New Notes List"
        let alert = UIAlertController(title: title, message: "Please set title", preferredStyle: .alert)
        
        alert.action(notesList: notesList) { newValue in
            if let notesList = notesList, let completion = completion  {
                StorageManager.shared.edit(notesList: notesList, newValue: newValue)
                completion()
            } else {
                self.save(notesListName: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(notesListName: String) {
        let notesList = NotesList(value: [notesListName])
        StorageManager.shared.save(notesList: notesList)
        let indexRow = IndexPath(row: notesLists.count - 1, section: 0)
        tableView.insertRows(at: [indexRow], with: .automatic)
    }
    
}
