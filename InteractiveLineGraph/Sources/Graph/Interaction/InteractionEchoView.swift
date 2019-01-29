//
//  InteractionEchoView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/17/19.
//

import UIKit

class InteractionEchoView: UIView {
  
  // MARK: - Properties
  fileprivate var isAnimating: Bool = false
  fileprivate var animator: UIViewPropertyAnimator!
  
  var highlightColor: UIColor {
    get {
      return dot.backgroundColor ?? .clear
    }
    
    set {
      dot.backgroundColor = newValue
      echo.layer.borderColor = newValue.cgColor
      echo.backgroundColor = newValue
    }
  }
  
  // MARK: - Subviews
  fileprivate let dot = UIView()
  fileprivate var echo = UIView()
  
  // MARK: - Stored Constraints
  // (Store any constraints that might need to be changed or animated later)
  fileprivate var dotCenterY: NSLayoutConstraint!
  
  // MARK: - Initialization
  
  convenience init() {
    self.init(frame: .zero)
    configureSubviews()
    configureTesting()
    configureLayout()
  }
  
  /// Set view/subviews appearances
  fileprivate func configureSubviews() {
    clipsToBounds = false
    
    dot.layer.cornerRadius = 2.5
    
    echo.layer.cornerRadius = 2.5
    echo.layer.borderWidth = 1
    
    animator = UIViewPropertyAnimator.init(duration: 1, curve: .easeOut) {
      UIView.setAnimationRepeatCount(.infinity)
      self.echo.transform = CGAffineTransform.init(scaleX: 4, y: 4)
      self.echo.alpha = 0
    }
  }
  
  /// Set AccessibilityIdentifiers for view/subviews
  fileprivate func configureTesting() {
    accessibilityIdentifier = "InteractionLineView"
  }
  
  /// Add subviews, set layoutMargins, initialize stored constraints, set layout priorities, activate constraints
  fileprivate func configureLayout() {
    
    addAutoLayoutSubview(echo)
    addAutoLayoutSubview(dot)
    
    dotCenterY = dot.centerYAnchor.constraint(equalTo: topAnchor)
    
    // Activate NSLayoutAnchors within this closure
    NSLayoutConstraint.activate([
      dot.centerXAnchor.constraint(equalTo: centerXAnchor),
      dot.widthAnchor.constraint(equalToConstant: 5),
      dot.heightAnchor.constraint(equalToConstant: 5),
      dotCenterY,
      
      echo.centerXAnchor.constraint(equalTo: dot.centerXAnchor),
      echo.centerYAnchor.constraint(equalTo: dot.centerYAnchor),
      echo.widthAnchor.constraint(equalToConstant: 5),
      echo.heightAnchor.constraint(equalToConstant: 5),
      ])
  }
  
  public func setDotPosition(_ yPos: CGFloat) {
    dotCenterY.constant = yPos
    layoutIfNeeded()
    animator.startAnimation()
  }
  
}
