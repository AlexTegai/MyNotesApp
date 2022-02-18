//
//  NotesListViewController.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import RealmSwift

protocol NoteDetailViewControllerDelegate {
    func save(name: String, and text: String)
    func edit(note: Note, name: String, and text: String)
}

class NotesListViewController: UITableViewController {
    
    var notesList: NotesList!
    
    private var notes: List<Note>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = notesList.name
        notes = notesList.notes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note = notes[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = note.name
        content.secondaryText = note.text
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if editingStyle == .delete {
            StorageManager.shared.delete(note: note)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        print(note)
        performSegue(withIdentifier: "edit", sender: note)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let noteDetailVC = segue.destination as? NoteDetailViewController else { return }
        
        noteDetailVC.delegate = self
        
        let note = sender as? Note
        noteDetailVC.note = note
    }
    
}

// MARK: - Protocol's delegate

extension NotesListViewController: NoteDetailViewControllerDelegate {

    func save(name: String, and text: String) {
        guard name != "" || text != "" else { return }
        let note = Note(value: [name, text])
        StorageManager.shared.save(note: note, in: notesList)
        let indexRow = IndexPath(row: notes.count - 1, section: 0)
        tableView.insertRows(at: [indexRow], with: .automatic)
    }
    
    func edit(note: Note, name: String, and text: String) {
        guard name != "" || text != "" else { return }
//        let note = Note(value: [name, text])
        StorageManager.shared.edit(note: note, with: name, and: text)
    }
    
}
