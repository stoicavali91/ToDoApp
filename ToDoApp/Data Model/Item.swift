//
//  Item.swift
//  ToDoApp
//
//  Created by Stoica Valentin on 07/03/2019.
//  Copyright © 2019 Stoica Valentin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
