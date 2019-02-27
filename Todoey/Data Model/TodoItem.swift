//
//  TodoItem.swift
//  Todoey
//
//  Created by Lavneesh Chandna on 2/26/19.
//  Copyright © 2019 Lavneesh Chandna. All rights reserved.
//

import Foundation

class TodoItem : Encodable, Decodable{
    
    var title: String = "";
    
    var done: Bool = false;
 
}
