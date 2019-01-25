//
//  GraphViewInteractionDelegate.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/23/19.
//

import Foundation

public protocol GraphViewInteractionDelegate:class {
  func graphViewInteraction(userInputDidChange currentIndex: Int)
}

public extension GraphViewInteractionDelegate {
  func graphViewInteraction(userInputDidChange currentIndex: Int) {}
}
