//
//  GraphDataProvider.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit

public protocol InteractiveLineGraphDataProvider:class {
  func dataPoints() -> [Double]
}

internal protocol LineGraphDataProvider:class {
  func position(forColumn column: Int) -> CGPoint
  func totalDataPoints() -> Int
}

internal protocol InteractionDataProvider:class {
  func position(nearest point: CGPoint) -> CGPoint
}
