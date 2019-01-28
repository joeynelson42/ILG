//
//  GraphInteractionView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/17/19.
//

import UIKit

enum CardPlacement {
  case right, left
}

class GraphInteractionView: UIView {
  
  // MARK: - Public Properties
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
  
  // MARK: - Private Properties
  fileprivate var pan: UIPanGestureRecognizer!
  fileprivate var impactGenerator = UIImpactFeedbackGenerator.init(style: .light)
  fileprivate var lastPosition: CGPoint?
  
  fileprivate var currentCardPlacement: CardPlacement {
    guard let _ = cardRight, let _ = cardLeft else { return .right }
    if cardRight.isActive {
      return .left
    } else {
      return .right
    }
  }
  
  // MARK: - Subviews
  fileprivate let line = InteractionLineView()
  fileprivate var detailCard: UIView?
  
  // MARK: - Stored Constraints
  // (Store any constraints that might need to be changed or animated later)
  fileprivate var lineLeft: NSLayoutConstraint!
  
  fileprivate var cardLeft: NSLayoutConstraint!
  fileprivate var cardRight: NSLayoutConstraint!
  
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
    hide(animated: false)
  }
  
  /// Set AccessibilityIdentifiers for view/subviews
  fileprivate func configureTesting() {
    accessibilityIdentifier = "GraphInteractionView"
  }
  
  /// Add subviews, set layoutMargins, initialize stored constraints, set layout priorities, activate constraints
  fileprivate func configureLayout() {
    
    addAutoLayoutSubview(line)
    
    lineLeft = line.centerXAnchor.constraint(equalTo: leftAnchor)
    
    NSLayoutConstraint.activate([
      line.topAnchor.constraint(equalTo: topAnchor),
      line.bottomAnchor.constraint(equalTo: bottomAnchor),
      line.widthAnchor.constraint(equalToConstant: 1.5),
      lineLeft
      ])
  }
  
  /// Reconfigure card if it exists.
  func set(newDetailCard: UIView) {
    if let card = detailCard {
      card.removeFromSuperview()
    }
    
    self.detailCard = newDetailCard
      hide(animated: false)
      
      addAutoLayoutSubview(detailCard!)
      
      cardLeft = detailCard!.leftAnchor.constraint(equalTo: line.rightAnchor, constant: 12)
      cardRight = detailCard!.rightAnchor.constraint(equalTo: line.leftAnchor, constant: -12)
      
      NSLayoutConstraint.activate([
        detailCard!.topAnchor.constraint(equalTo: line.topAnchor, constant: 12),
        cardLeft
        ])
  }
  
  /// Fade out. Animation optional.
  private func hide(animated: Bool) {
    let block = {
      self.line.alpha = 0
      self.detailCard?.alpha = 0
    }
    if animated {
      UIView.animate(withDuration: 0.12, animations: block)
    } else {
      UIView.performWithoutAnimation(block)
    }
  }
  
  /// Fade in. Animation optional.
  private func show(animated: Bool) {
    let block = {
      self.line.alpha = 1
      self.detailCard?.alpha = 1
    }
    if animated {
      UIView.animate(withDuration: 0.12, animations: block)
    } else {
      UIView.performWithoutAnimation(block)
    }
  }
  
  @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    guard let _ = dataProvider else { return }
    switch gestureRecognizer.state {
      
    // On begin: Simply reveal the line/card and trigger impact.
    case .began:
      show(animated: true)
      impactGenerator.impactOccurred()
      
    // On changed: Find the touch location, get nearest dataPoint from dataProvider and move line to it if needed.
    case .changed:
      let currentTouchPoint = gestureRecognizer.location(in: self.superview)
      let dataPoint = dataProvider.position(nearest: currentTouchPoint)
      
      if let last = lastPosition, last != dataPoint {
        impactGenerator.impactOccurred()
      }
      
      updateCard()
      
      lastPosition = dataPoint
      
      lineLeft.constant = dataPoint.x
      line.setDotPosition(dataPoint.y)
      layoutIfNeeded()
      
    // On end: Hide line/card.
    case .cancelled, .ended, .failed:
      hide(animated: true)
    default:
      return
    }
  }
  
  private func updateCard() {
    guard let _ = detailCard else { return }
    
    if let newPlacement = recommendedCardPlacement() {
      set(cardPlacement: newPlacement, animated: true)
    }
  }
  
  // TODO: Make this smarter?
  /// Checks if card's frame is outside frame.
  ///
  /// - Returns: Recommended card placement if card is out of frame, otherwise nil.
  private func recommendedCardPlacement() -> CardPlacement? {
    guard let card = detailCard else { return nil }
    
    if frame.contains(card.frame) {
      return nil
    } else if currentCardPlacement == .left {
      return .right
    } else {
      return .left
    }
  }
  
  /// Sets the card's placement, either to the right or left of the line.
  private func set(cardPlacement: CardPlacement, animated: Bool) {
    guard let _ = cardRight, let _ = cardLeft else { return }
    
    switch cardPlacement {
    case .right:
      cardRight.isActive = false
      cardLeft.isActive = true
    case .left:
      cardLeft.isActive = false
      cardRight.isActive = true
    }
    
    if animated {
      UIView.animate(withDuration: 0.25) {
        self.layoutIfNeeded()
      }
    } else {
      UIView.performWithoutAnimation(layoutIfNeeded)
    }
  }
  
}
