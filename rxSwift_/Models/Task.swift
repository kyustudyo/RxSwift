//
//  Task.swift
//  rxSwift_
//
//  Created by 이한규 on 2022/01/15.
//

import Foundation
enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
