//
//  NotesList.swift
//  MyNotesApp
//
//  Created by Alex Tegai on 18.02.2022.
//

import RealmSwift

class NotesList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var notes = List<Note>()
}

class Note: Object {
    @Persisted var name = ""
    @Persisted var text = ""
    @Persisted var date = Date()
}

