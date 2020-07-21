//
//  Reminder.swift
//  Reminder
//
//  Created by Aleksa on 20.07.2020.
//  Copyright © 2020 Aleksa. All rights reserved.
//

import Foundation

class Base {
    
    struct Reminder: Codable {
        var title: String
        var notes: String
        var guid: String
    }
    
    static let shared = Base()
    
    let defaults = UserDefaults.standard
    
    var info: [Reminder] {
        get {
            if let data = defaults.value(forKey: "info") as? Data {
                return try! PropertyListDecoder().decode([Reminder].self, from: data)
            } else {
                return [Reminder]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                print(data)
                defaults.set(data, forKey: "info")
            } else {
                // defaults.removeObject(forKey: "info")
            }
        }
    }
}
