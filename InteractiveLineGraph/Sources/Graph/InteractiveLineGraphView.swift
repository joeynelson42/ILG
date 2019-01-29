//
//  InteractiveLineGraphView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/14/19.
//

import UIKit

open class InteractiveLineGraphView: UIView {
  
  // MARK: Public Properties
  
  // MARK: Interaction
  weak public var interactionDelegate: GraphViewInteractionDelegate?
  
  public var interactionHighlightColor: UIColor {
    get {
      return interactionView.highlightColor
    }
    
    set {
      interactionView.highlightColor = newValue
    }
  }
  
  public var interactionHighlightAlpha: CGFloat {
    get {
      return interactionView.highlightAlpha
    }
    
    set {
      interactionView.highlightAlpha = newValue
    }
  }
  
  public var interactionDetailCard: UIView? {
    get {
      return nil
    }
    
    set {
      guard let _ = newValue else { return }
      interactionView.set(newDetailCard: newValue!)
    }
  }
  
  // MARK: Line Attributes
  public var lineMinY: CGFloat?
  public var lineMaxY: CGFloat?
  
  public var lineColor: UIColor {
    get {
      if let color = graphLayer.strokeColor {
        return UIColor.init(cgColor: color)
      } else {
        return .white
      }
    }
    
    set {
      graphLayer.strokeColor = newValue.cgColor
    }
  }
  
  public var lineWidth: CGFloat {
    get {
      return graphLayer.lineWidth
    }
    
    set {
      graphLayer.lineWidth = newValue
    }
  }
  
  // MARK: Grid Attributes
  public var gridEnabled = true
  
  public var gridColor: UIColor {
    get {
      if let color = gridLayer.strokeColor {
        return UIColor.init(cgColor: color)
      } else {
        return .white
      }
    }
    
    set {
      gridLayer.strokeColor = newValue.withAlphaComponent(gridAlpha).cgColor
    }
  }
  
  public var gridAlpha: CGFloat {
    get {
      return gridLayer.strokeColor?.alpha ?? 1.0
    }
    
    set {
      gridLayer.strokeColor = gridColor.withAlphaComponent(newValue).cgColor
    }
  }
  
  public var gridLineWidth: CGFloat {
    get {
      return gridLayer.lineWidth
    }
    
    set {
      gridLayer.lineWidth = newValue
    }
  }
  
  public var horizontalLines: Int {
    get {
      return gridLayer.horizontalLines
    }
    
    set {
      gridLayer.horizontalLines = newValue
    }
  }
  
  public var verticalLines: Int {
    get {
      return gridLayer.verticalLines
    }
    
    set {
      gridLayer.verticalLines = newValue
    }
  }
  
  // MARK: Dot Attributes
  public var dotsEnabled = true
  
  public var dotColor: UIColor {
    get {
      if let color = dotsLayer.strokeColor {
        return UIColor.init(cgColor: color)
      } else {
        return .white
      }
    }
    
    set {
      dotsLayer.strokeColor = newValue.cgColor
    }
  }
  
  public var dotSize: CGFloat {
    get {
      return dotsLayer.lineWidth
    }
    
    set {
      dotsLayer.lineWidth = newValue
    }
  }
  
  // MARK: Private Properties
  
  // MARK: Data
  fileprivate var dataPoints = [Double]() {
    didSet {
      updateGraphPoints()
    }
  }
  
  fileprivate let graphPadding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
  fileprivate var graphPoints = [CGPoint]()
  
  // MARK: Sublayers/views
  fileprivate var graphLayer = LineGraphLayer()
  fileprivate var gridLayer = GridLayer()
  fileprivate var dotsLayer = DotLayer()
  fileprivate var interactionView = GraphInteractionView()
  
  // MARK: - Initializers
  convenience init() {
    self.init(frame: .zero)
  }
  
  required override public init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.addSublayer(gridLayer)
    
    graphLayer.dataProvider = self
    layer.addSublayer(graphLayer)
    
    dotsLayer.dataProvider = self
    layer.addSublayer(dotsLayer)
    
    interactionView.dataProvider = self
    addAutoLayoutSubview(interactionView)
    interactionView.fillSuperview()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder aDecoder: NSCoder) is not required")
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    updateGraphFrame()
  }
  
  // MARK: - Public Methods
  public func update(withDataPoints dataPoints: [Double], animated: Bool) {
    self.dataPoints = dataPoints
    
    graphLayer.updatePaths(animated: animated)
    
    if dotsEnabled {
      drawDots()
    }
    
    if gridEnabled {
      drawGrid()
    }
  }
}

// MARK: Private Methods
extension InteractiveLineGraphView {
  fileprivate func updateGraphPoints() {
    graphPoints.removeAll()
    for (index,_) in dataPoints.enumerated() {
      graphPoints.append(CGPoint.init(x: columnXPoint(column: index), y: columnYPoint(column: index)))
    }
  }
  
  fileprivate func updateGraphFrame() {
    let insetFrameSize = CGSize.init(width: frame.size.width - (graphPadding.left * 2), height: frame.size.height - (graphPadding.left * 2))
    graphLayer.frame.size = insetFrameSize
  }
  
  fileprivate func drawGrid() {
    gridLayer.frame = CGRect.init(origin: .init(x: graphPadding.left, y: graphPadding.top), size: graphLayer.frame.size)
    gridLayer.drawGrid()
  }
  
  fileprivate func drawDots() {
    dotsLayer.frame = bounds
    dotsLayer.update()
  }
}

extension InteractiveLineGraphView: LineGraphDataProvider {
  func position(forColumn column: Int) -> CGPoint {
    return CGPoint.init(x: columnXPoint(column: column), y: columnYPoint(column: column))
  }
  
  func totalDataPoints() -> Int {
    return dataPoints.count
  }
  
  fileprivate func columnYPoint(column: Int) -> CGFloat {
    let minY = frame.height - graphPadding.bottom
    
    if dataPoints.isEmpty { return minY }
    
    let minDataPoint = CGFloat(dataPoints.min() ?? 0)
    let maxDataPoint = CGFloat(dataPoints.max() ?? 0)
    
    let minValue = lineMinY ?? minDataPoint
    let maxValue = lineMaxY ?? maxDataPoint
    let dataPoint = CGFloat(dataPoints[column])
    
    if minValue + maxValue <= 0 || (maxValue - minValue == 0) {
      return minY
    } else {
      // TODO: Think of clearer names, good to know my fading math skills are continuing to fail me
      let proportion = (dataPoint - minValue) / (maxValue - minValue)
      let proportionalHeight = proportion * graphLayer.frame.height
      let y = frame.height - (graphPadding.top) - proportionalHeight
      return y
    }
  }
  
  fileprivate func columnXPoint(column: Int) -> CGFloat {
    if dataPoints.count <= 1 {
      return graphPadding.left
    }
    
    let spacer = (bounds.width - (graphPadding.left + graphPadding.right)) / CGFloat((dataPoints.count - 1))
    var x = CGFloat(column) * spacer
    x += graphPadding.left
    return x
  }
}

extension InteractiveLineGraphView: InteractionDataProvider {
  func position(nearest point: CGPoint) -> CGPoint {
    guard let first = graphPoints.first else { return .zero }
    var nearest = first
    var index: Int = 0
    for (i,graphPoint) in graphPoints.enumerated() {
      let currentDiff = abs(point.x - nearest.x)
      let newDiff = abs(point.x - graphPoint.x)
      if newDiff < currentDiff {
        nearest = graphPoint
        index = i
      }
    }
    
    interactionDelegate?.graphViewInteraction(userInputDidChange: index)
    
    return nearest
  }
  
}
