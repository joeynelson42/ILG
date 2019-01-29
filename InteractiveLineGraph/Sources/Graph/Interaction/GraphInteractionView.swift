//
//  GraphInteractionView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/17/19.
//

import UIKit

class GraphInteractionView: UIView {
  
  // MARK: - Public Properties
  weak var dataProvider: InteractionDataProvider!
  
  var highlightColor: UIColor {
    get {
      return echo.highlightColor
    }
    
    set {
      echo.highlightColor = newValue.withAlphaComponent(highlightAlpha)
      ghostLine.backgroundColor = newValue.withAlphaComponent(0.1)
    }
  }
  
  var highlightAlpha: CGFloat {
    get {
      return echo.highlightColor.cgColor.alpha
    }
    
    set {
      echo.highlightColor = highlightColor.withAlphaComponent(newValue)
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
  fileprivate let echo = InteractionEchoView()
  fileprivate var detailCard: UIView?
  fileprivate var guideLine = UIView()
  fileprivate let ghostLine = UIView()
  
  // MARK: - Stored Constraints
  // (Store any constraints that might need to be changed or animated later)
  fileprivate var echoLeft: NSLayoutConstraint!
  fileprivate var ghostLineLeft: NSLayoutConstraint!
  fileprivate var guideLineLeft: NSLayoutConstraint!
  fileprivate var cardLeft: NSLayoutConstraint!
  fileprivate var cardRight: NSLayoutConstraint!
  fileprivate var cardCenterY: NSLayoutConstraint!
  
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
    
    addAutoLayoutSubview(echo)
    addAutoLayoutSubview(ghostLine)
    addAutoLayoutSubview(guideLine)
    
    echoLeft = echo.centerXAnchor.constraint(equalTo: leftAnchor)
    ghostLineLeft = ghostLine.centerXAnchor.constraint(equalTo: leftAnchor)
    guideLineLeft = guideLine.centerXAnchor.constraint(equalTo: leftAnchor)
    
    NSLayoutConstraint.activate([
      echo.topAnchor.constraint(equalTo: topAnchor),
      echo.bottomAnchor.constraint(equalTo: bottomAnchor),
      echo.widthAnchor.constraint(equalToConstant: 1.5),
      echoLeft,
      
      guideLine.topAnchor.constraint(equalTo: topAnchor),
      guideLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      guideLine.widthAnchor.constraint(equalToConstant: 1.5),
      guideLineLeft,
      
      ghostLine.topAnchor.constraint(equalTo: topAnchor),
      ghostLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      ghostLine.widthAnchor.constraint(equalToConstant: 1.5),
      ghostLineLeft,
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
      
      cardLeft = detailCard!.leftAnchor.constraint(equalTo: guideLine.rightAnchor, constant: 12)
      cardRight = detailCard!.rightAnchor.constraint(equalTo: guideLine.leftAnchor, constant: -12)
      cardCenterY = detailCard!.centerYAnchor.constraint(equalTo: topAnchor)
    
      NSLayoutConstraint.activate([
        cardCenterY,
        cardLeft
        ])
  }
  
  /// Fade out. Animation optional.
  private func hide(animated: Bool) {
    let block = {
      self.echo.alpha = 0
      self.detailCard?.alpha = 0
      self.ghostLine.alpha = 0
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
      self.echo.alpha = 1
      self.detailCard?.alpha = 1
      self.ghostLine.alpha = 1
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
      
    // On begin: Simply reveal the echo/card and trigger impact.
    case .began:
      show(animated: true)
      impactGenerator.impactOccurred()
      
    // On changed: Find the touch location, get nearest dataPoint from dataProvider and move echo to it if needed.
    case .changed:
      let currentTouchPoint = gestureRecognizer.location(in: self.superview)
      let dataPoint = dataProvider.position(nearest: currentTouchPoint)
      
      if let last = lastPosition, last != dataPoint {
        impactGenerator.impactOccurred()
        updateEcho(withDataPoint: dataPoint)
      }
      lastPosition = dataPoint
      
      updateCard(withDataPoint: dataPoint)
      updateGhostLine(withTouchPoint: currentTouchPoint)
      
      UIView.animate(withDuration: 0.25) {
        self.layoutIfNeeded()
      }
      
    // On end: Hide echo/card.
    case .cancelled, .ended, .failed:
      hide(animated: true)
    default:
      return
    }
  }
  
}

// MARK: Update methods
extension GraphInteractionView {
  fileprivate func updateGhostLine(withTouchPoint point: CGPoint) {
    ghostLineLeft.constant = point.x
  }
  
  fileprivate func updateEcho(withDataPoint point: CGPoint) {
    echoLeft.constant = point.x
    echo.setDotPosition(point.y)
    UIView.performWithoutAnimation(layoutIfNeeded)
  }
  
  fileprivate func updateCard(withDataPoint point: CGPoint) {
    guard let _ = detailCard else { return }
    guideLineLeft.constant = point.x
    cardCenterY.constant = point.y
    
    if let newPlacement = recommendedCardPlacement() {
      set(cardPlacement: newPlacement, animated: true)
    }
  }
}

// MARK: Card Placement

fileprivate enum CardPlacement {
  case right, left
  
  var opposite: CardPlacement {
    switch self {
    case .left:
      return .right
    case .right:
      return .left
    }
  }
}

extension GraphInteractionView {
  /// Checks if card's frame is outside frame, returns new placement if needed.
  ///
  /// - Returns: Recommended card placement if card is out of frame, otherwise nil.
  fileprivate func recommendedCardPlacement() -> CardPlacement? {
    guard let card = detailCard else { return nil }
    
    var extremity: CGPoint!
    switch currentCardPlacement {
    case .left:
      extremity = CGPoint.init(x: card.frame.origin.x, y: card.frame.maxY / 2)
    case .right:
      extremity = CGPoint.init(x: card.frame.maxX, y: card.frame.maxY / 2)
    }
    
    if frame.contains(extremity) {
      return nil
    } else {
      return currentCardPlacement.opposite
    }
  }
  
  /// Sets the card's placement, either to the right or left of the echo.
  fileprivate func set(cardPlacement: CardPlacement, animated: Bool) {
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
