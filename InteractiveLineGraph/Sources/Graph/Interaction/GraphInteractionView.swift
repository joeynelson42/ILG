//
//  GraphInteractionView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/17/19.
//

import UIKit

class GraphInteractionView: UIView {
  
  // MARK: - Properties
  weak var dataProvider: InteractionDataProvider!
  
  var highlightColor: UIColor {
    get {
      return line.backgroundColor ?? .white
    }
    
    set {
      line.backgroundColor = newValue.withAlphaComponent(highlightAlpha)
    }
  }
  
  var highlightAlpha: CGFloat {
    get {
      return line.backgroundColor?.cgColor.alpha ?? 1
    }
    
    set {
      line.backgroundColor = highlightColor.withAlphaComponent(newValue)
    }
  }
  
  fileprivate var pan: UIPanGestureRecognizer!
  fileprivate var impactGenerator = UIImpactFeedbackGenerator.init(style: .light)
  fileprivate var lastPosition: CGPoint?
  
  // MARK: - Subviews
  fileprivate let line = InteractionLineView()
  
  // MARK: - Stored Constraints
  // (Store any constraints that might need to be changed or animated later)
  fileprivate var lineLeft: NSLayoutConstraint!
  
  // MARK: - Initialization
  
  convenience init() {
    self.init(frame: .zero)
    configureSubviews()
    configureTesting()
    configureLayout()
    
    pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(gestureRecognizer:)))
    addGestureRecognizer(pan)
  }
  
  /// Set view/subviews appearances
  fileprivate func configureSubviews() {
    line.alpha = 0
  }
  
  /// Set AccessibilityIdentifiers for view/subviews
  fileprivate func configureTesting() {
    accessibilityIdentifier = "GraphInteractionView"
  }
  
  /// Add subviews, set layoutMargins, initialize stored constraints, set layout priorities, activate constraints
  fileprivate func configureLayout() {
    
    addAutoLayoutSubview(line)
    
    lineLeft = line.centerXAnchor.constraint(equalTo: leftAnchor)
    
    // Activate NSLayoutAnchors within this closure
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: topAnchor),
      line.bottomAnchor.constraint(equalTo: bottomAnchor),
      line.widthAnchor.constraint(equalToConstant: 1.5),
      lineLeft
      ])
  }
  
  @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    guard let _ = dataProvider else { return }
    switch gestureRecognizer.state {
    case .began:
      self.line.alpha = 1
      impactGenerator.impactOccurred()
    case .changed:
      let currentTouchPoint = gestureRecognizer.location(in: self.superview)
      let dataPoint = dataProvider.position(nearest: currentTouchPoint)
      
      if let last = lastPosition, last != dataPoint {
        impactGenerator.impactOccurred()
      }
      
      lastPosition = dataPoint
      
      lineLeft.constant = dataPoint.x
      line.setDotPosition(dataPoint.y)
      layoutIfNeeded()
      
    case .cancelled, .ended, .failed:
      self.line.alpha = 0
    default:
      return
    }
  }
}
