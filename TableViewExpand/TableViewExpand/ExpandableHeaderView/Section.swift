//
//  Section.swift
//  TableViewExpand
//
//  Created by user on 01.04.18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

struct Section {
    var book : String!
    var chapter : [Int]!
    var expanded : Bool!
    var label : String!
    
    init(book: String, label: String, chapter: [Int], expanded: Bool) {
        self.book = book
        self.label = label
        self.chapter = chapter
        self.expanded = expanded
    }
}
