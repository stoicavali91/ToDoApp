//
//  Category.swift
//  ToDoApp
//
//  Created by Stoica Valentin on 07/03/2019.
//  Copyright © 2019 Stoica Valentin. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc var name : String = ""
    let items = List<Item>()
    
}
