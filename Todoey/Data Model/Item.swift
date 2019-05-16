//
//  Item.swift
//  Todoey
//
//  Created by rodrigoftw on 15/05/2019.
//  Copyright © 2019 rodrigoftw. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
