//
//  Category.swift
//  todoey
//
//  Created by Jonathan Rojas on 12/3/18.
//  Copyright © 2018 NovoPayment. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
