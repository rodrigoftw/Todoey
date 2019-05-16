//
//  Category.swift
//  Todoey
//
//  Created by rodrigoftw on 15/05/2019.
//  Copyright © 2019 rodrigoftw. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
