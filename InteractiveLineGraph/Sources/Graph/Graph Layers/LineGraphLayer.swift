//
//  LineGraphLayer.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/14/19.
//

import UIKit

class LineGraphLayer: CAShapeLayer {
  
  weak var dataProvider: GraphDataProvider!
  
  var linePath: UIBezierPath!
  var fullPath: UIBezierPath!
  var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 40.0, right: 44.0)
  
  // Layers
  private var graphLayer = CAShapeLayer()
  private var gradientLayer = CAGradientLayer()
  private var lineLayer = CAShapeLayer()
  
  override var strokeColor: CGColor? {
    get {
      return lineLayer.strokeColor
    }
    
    set {
      lineLayer.strokeColor = newValue
    }
  }
  
  override var lineWidth: CGFloat {
    get {
      return lineLayer.lineWidth
    }
    
    set {
      lineLayer.lineWidth = newValue
    }
  }
  
  override init() {
    super.init()
    addSublayer(graphLayer)
    gradientLayer.mask = graphLayer
    addSublayer(gradientLayer)
    addSublayer(lineLayer)
    
    lineLayer.strokeColor = UIColor.blue.cgColor
    lineLayer.fillColor = UIColor.clear.cgColor
    lineLayer.lineWidth = lineWidth
    
    graphLayer.fillColor = UIColor.blue.cgColor
    
    gradientLayer.colors = [UIColor.clear.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Update the paths for both the line layer and the graph mask layer
  func updatePaths(animated: Bool = false) {
    guard let _ = dataProvider else {
      print("No GraphDataProvider providing.")
      return
    }
    
    // Capture current state for potential animation
    let previousLine = linePath ?? UIBezierPath()
    let previousFullPath = fullPath ?? UIBezierPath()
    
    updateLinePath()
    updateFullPath()
    
    if animated {
      let animation = CABasicAnimation(keyPath: "path")
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
      animation.fromValue = previousFullPath.cgPath
      animation.toValue = fullPath.cgPath
      animation.duration = 0.4
      animation.fillMode = CAMediaTimingFillMode.forwards
      animation.isRemovedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
      graphLayer.add(animation, forKey: "path")
      
      let lineAnimation = CABasicAnimation(keyPath: "path")
      lineAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
      lineAnimation.fromValue = previousLine.cgPath
      lineAnimation.toValue = linePath.cgPath
      lineAnimation.duration = 0.4
      lineAnimation.fillMode = CAMediaTimingFillMode.forwards
      lineAnimation.isRemovedOnCompletion = false
      lineAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
      lineLayer.add(lineAnimation, forKey: "path")
    } else {
      displayIfNeeded()
    }
  }
  
  /// Updates the line path according the dataProvider's data
  private func updateLinePath() {
    linePath = UIBezierPath()
    
    for i in 0 ..< dataProvider.totalDataPoints() {
      let point = dataProvider.position(forColumn: i)
      if i == 0 {
        linePath.move(to: point)
      } else {
        linePath.addLine(to: point)
      }
    }
    
    lineLayer.path = linePath.cgPath
  }
  
  /// Takes the current linePath and creates a full polygon. Needed for the gradient.
  /// TODO: solve all gradient issues...
  private func updateFullPath() {
    // Clip to full polygon for fill. Connect to bottom right then bottom left, then close.
    let clippingPath = linePath.copy() as! UIBezierPath
    clippingPath.addLine(to: CGPoint(x: dataProvider.position(forColumn: dataProvider.totalDataPoints() - 1).x, y: bounds.height))
    clippingPath.addLine(to: CGPoint(x: dataProvider.position(forColumn: 0).x, y: bounds.height))
    clippingPath.close()
    fullPath = clippingPath
    
    graphLayer.path = clippingPath.cgPath
    gradientLayer.frame = bounds
  }
}
