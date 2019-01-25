//
//  ExampleView.swift
//  InteractiveLineGraphExample
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit
import InteractiveLineGraph

class ExampleView: UIView {
  
  // MARK: - Subviews
  let graphView = InteractiveLineGraphView()
  let textLabel = UILabel()
  
  // MARK: - Initialization
  convenience init() {
    self.init(frame: .zero)
    configureSubviews()
    configureTesting()
    configureLayout()
  }
  
  /// Set view/subviews appearances
  fileprivate func configureSubviews() {
    backgroundColor = .white
    
    graphView.lineWidth = 2
    graphView.lineColor = .red
    graphView.gridEnabled = false
    graphView.dotsEnabled = false
    graphView.interactionHighlightColor = .darkGray
    graphView.interactionHighlightAlpha = 0.25
    
    textLabel.font = UIFont.init(name: "Avenir", size: 32)
    textLabel.textAlignment = .center
    textLabel.textColor = .darkGray
  }
  
  /// Set AccessibilityIdentifiers for view/subviews
  fileprivate func configureTesting() {
    accessibilityIdentifier = "ExampleView"
  }
  
  /// Add subviews, set layoutMargins, initialize stored constraints, set layout priorities, activate constraints
  fileprivate func configureLayout() {
    
    addAutoLayoutSubview(graphView)
    addAutoLayoutSubview(textLabel)
    
    // Activate NSLayoutAnchors within this closure
    NSLayoutConstraint.activate([
      graphView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 60),
      graphView.centerXAnchor.constraint(equalTo: centerXAnchor),
      graphView.widthAnchor.constraint(equalToConstant: 375),
      graphView.heightAnchor.constraint(equalToConstant: 250),
      
      textLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 24),
      textLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
      ])
  }
}

