//
//  GraphDataProvider.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit

// TODO: Spice these up/Format them correctly/Don't be so lazy.

internal protocol LineGraphDataProvider:class {
  func position(forColumn column: Int) -> CGPoint
  func totalDataPoints() -> Int
}

internal protocol InteractionDataProvider:class {
  func position(nearest point: CGPoint) -> CGPoint
  func interactionDidBegin()
  func interactionDidEnd()
}
