//
//  Task.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 31/05/22.
//

import Foundation

enum Priority: Int {
    case High = 1
    case Medium = 2
    case Low = 3
}

struct Task {
    let title:String
    let priority:Priority
}
