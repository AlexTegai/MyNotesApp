//
//  DataManager.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import RealmSwift

class DataManager {

    static let shared = DataManager()
    private init() {}

    func createTestData(_ completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            UserDefaults.standard.set(true, forKey: "done")
            
            let shoppingList = NotesList()
            shoppingList.name = "Shopping List"
            
            let milk = Note(value: ["name": "Milk", "text": "2l"])
            let bread = Note(value: ["name": "Bread", "text": "2p"])
            
            let moviesList = NotesList()
            moviesList.name = "Movies List"
            
            let drama = Note(value: ["name": "Forest Gam", "text": "Description"])
            let comedy = Note(value: ["name": "God's armor", "text": "Description"])
            
            shoppingList.notes.append(objectsIn: [milk, bread])
            moviesList.notes.insert(contentsOf: [drama, comedy], at: 0)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(notesLists: [shoppingList, moviesList])
                completion()
            }
        }
    }
    
}

