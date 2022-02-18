//
//  StorageManager.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import RealmSwift

class StorageManager {

    static let shared = StorageManager()
    let realm = try! Realm()
    private init() {}

    // MARK: - Notes Lists
    
    func save(notesLists: [NotesList]) {
        write {
            realm.add(notesLists)
        }
    }
    
    func save(notesList: NotesList) {
        write {
            realm.add(notesList)
        }
    }
    
    func delete(notesList: NotesList) {
        write {
            realm.delete(notesList.notes)
            realm.delete(notesList)
        }
    }
    
    func edit(notesList: NotesList, newValue: String) {
        write {
            notesList.name = newValue
        }
    }
    
    // MARK: - Notes
    
    func save(note: Note, in notesList: NotesList) {
        write {
            notesList.notes.append(note)
        }
    }
    
    func delete(note: Note) {
        write {
            realm.delete(note)
        }
    }
    
    func edit(note: Note, with newName: String, and newText: String) {
        write {
            note.name = newName
            note.text = newText
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try realm.write { completion() }
        } catch let error {
            print(error)
        }
    }
    
}

