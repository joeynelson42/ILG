//
//  InteractiveLineGraphView.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/14/19.
//

import UIKit

open class InteractiveLineGraphView: UIView {
  
  // MARK: Data
  weak public var dataProvider: InteractiveLineGraphDataProvider! {
    didSet {
      self.dataProviderDidChange()
    }
  }
  
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
  
  // MARK: Line Attributes
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
  
  fileprivate let graphPadding = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
  fileprivate var graphPoints = [CGPoint]()
  
  // MARK: Sublayers/views
  fileprivate var graphLayer = LineGraphLayer()
  fileprivate var gridLayer = GridLayer()
  fileprivate var dotsLayer = DotLayer()
  fileprivate var interactionView = GraphInteractionView()
  
  // MARK: - Life Cycle
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
  
  @objc func dataProviderDidChange() {
    interactionView.dataProvider = self
    update(animated: false)
  }
  
  // MARK: - Public
  public func update(animated: Bool) {
    guard let _ = dataProvider else { return }
    
    updateGraphPoints()
    
    graphLayer.updatePaths(animated: animated)
    
    if dotsEnabled {
      drawDots()
    }
    
    if gridEnabled {
      drawGrid()
    }
  }
}

// MARK: Private
extension InteractiveLineGraphView {
  fileprivate func updateGraphPoints() {
    graphPoints.removeAll()
    for (index,_) in dataProvider.dataPoints().enumerated() {
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
    dotsLayer.drawDots()
  }
}

extension InteractiveLineGraphView: LineGraphDataProvider {
  func position(forColumn column: Int) -> CGPoint {
    return CGPoint.init(x: columnXPoint(column: column), y: columnYPoint(column: column))
  }
  
  func totalDataPoints() -> Int {
    guard let _ = dataProvider else { return 0 }
    return dataProvider.dataPoints().count
  }
  
  fileprivate func columnYPoint(column: Int) -> CGFloat {
    let minY = frame.height - graphPadding.bottom
    
    guard let _ = dataProvider else { return minY }
    
    if dataProvider.dataPoints().isEmpty { return minY }
    
    let minValue = CGFloat(dataProvider.dataPoints().min() ?? 0)
    let maxValue = CGFloat(dataProvider.dataPoints().max() ?? 0)
    let dataPoint = CGFloat(dataProvider.dataPoints()[column])
    
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
    guard let _ = dataProvider else { return 0 }
    
    if dataProvider.dataPoints().count <= 1 {
      return 0
    }
    
    let spacer = (bounds.width - (graphPadding.left + graphPadding.right)) / CGFloat((dataProvider.dataPoints().count - 1))
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
    
    dataProvider.updateDetailCardView(atIndex: index)
    interactionDelegate?.graphViewInteraction(userInputDidChange: index)
    
    return nearest
  }

  func detailCardView() -> UIView? {
    guard let _ = dataProvider else { return nil }
    return dataProvider.detailCardView()
  }
  
}
