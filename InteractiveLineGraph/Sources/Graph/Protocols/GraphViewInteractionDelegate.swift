//
//  GraphViewInteractionDelegate.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit

public protocol GraphViewInteractionDelegate:class {
  func graphViewInteraction(userInputDidChange currentIndex: Int, graphView: InteractiveLineGraphView, detailCardView: UIView?)
  
  func graphViewInteraction(userInputDidBeginOn graphView: InteractiveLineGraphView, detailCardView: UIView?)
  func graphViewInteraction(userInputDidEndOn graphView: InteractiveLineGraphView, detailCardView: UIView?)
}

public extension GraphViewInteractionDelegate {
  func graphViewInteraction(userInputDidChange currentIndex: Int, graphView: InteractiveLineGraphView, detailCardView: UIView?) {}
  func graphViewInteraction(userInputDidBeginOn graphView: InteractiveLineGraphView, detailCardView: UIView?) {}
  func graphViewInteraction(userInputDidEndOn graphView: InteractiveLineGraphView, detailCardView: UIView?) {}
}
