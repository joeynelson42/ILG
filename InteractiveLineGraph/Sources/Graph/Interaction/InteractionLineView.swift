//
//  InteractionLineView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/17/19.
//

import UIKit

class InteractionLineView: UIView {
  
  // MARK: - Properties
  fileprivate var isAnimating: Bool = false
  fileprivate var animator: UIViewPropertyAnimator!
  
  // MARK: - Subviews
  fileprivate let line = UIView()
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
    
    addAutoLayoutSubview(line)
    addAutoLayoutSubview(echo)
    addAutoLayoutSubview(dot)
    
    dotCenterY = dot.centerYAnchor.constraint(equalTo: topAnchor)
    
    // Activate NSLayoutAnchors within this closure
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: topAnchor),
      line.bottomAnchor.constraint(equalTo: bottomAnchor),
      line.centerXAnchor.constraint(equalTo: centerXAnchor),
      line.widthAnchor.constraint(equalToConstant: 1.5),
      
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
  
  override var backgroundColor: UIColor? {
    didSet {
      line.backgroundColor = backgroundColor
      dot.backgroundColor = backgroundColor
      echo.layer.borderColor = backgroundColor?.cgColor
      echo.backgroundColor = backgroundColor
    }
  }
  
  public func setDotPosition(_ yPos: CGFloat) {
//    if animator.isRunning {
//      animator.stopAnimation(true)
//      animator.finishAnimation(at: .end)
//    }
    
    dotCenterY.constant = yPos
    layoutIfNeeded()
    
    animator.startAnimation()
  }
  
}
