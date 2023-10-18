//
//  Constants.swift
//  drawApp
//
//  Created by sandeep on 2023-10-18.
//

import Foundation
import UIKit
enum DrawingColor {
    case red
    case blue
    case green
    case eraser
    
    var buttonColor: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .eraser:
            return .white
        }
    }
    
var drawingDelay: TimeInterval {
        switch self {
        case .red:
            return 1.0
        case .blue:
            return 3.0
        case .green:
            return 5.0
        case .eraser:
            return 2.0
        }
    }
}
