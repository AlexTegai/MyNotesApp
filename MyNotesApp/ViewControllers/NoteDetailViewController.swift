//
//  NoteDetailViewController.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var textTextField: UITextView!

    var note: Note?
    var delegate: NoteDetailViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        noteDefaults()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let nameValue = nameTextField.text,
            let textValue = textTextField.text
        else { return }
        
        if let note = note {
            delegate.edit(note: note, name: nameValue, and: textValue)
        } else {
            delegate.save(name: nameValue, and: textValue)
        }
    }
    
    private func noteDefaults() {
        guard
            let newName = note?.name,
            let newText = note?.text
        else { return }
        
        nameTextField.text = newName
        textTextField.text = newText
    }
    
}
