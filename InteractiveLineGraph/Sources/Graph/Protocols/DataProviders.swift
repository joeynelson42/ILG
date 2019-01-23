//
//  GraphDataProvider.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit

protocol GraphDataProvider:class {
    func position(forColumn column: Int) -> CGPoint
    func totalDataPoints() -> Int
}

protocol InteractionDataProvider:class {
    func position(nearest point: CGPoint) -> CGPoint
}
