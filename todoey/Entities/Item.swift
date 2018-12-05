//
//  Item.swift
//  todoey
//
//  Created by Jonathan Rojas on 12/3/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
