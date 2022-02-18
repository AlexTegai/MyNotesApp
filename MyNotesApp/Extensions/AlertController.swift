//
//  AlertController.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import UIKit

extension UIAlertController {
    
    func action(notesList: NotesList?, completion: @escaping (String) -> Void) {
        let buttonName = notesList != nil ? "Edit" : "Save"
        let saveAction = UIAlertAction(title: buttonName, style: .default) { _ in
            guard
                let newValue = self.textFields?.first?.text,
                !newValue.isEmpty
            else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textFields in
            textFields.placeholder = "Notes List Name"
            textFields.text = notesList?.name
        }
    }
    
}
