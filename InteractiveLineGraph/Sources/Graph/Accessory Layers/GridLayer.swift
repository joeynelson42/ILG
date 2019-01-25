//
//  GridLayer.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/14/19.
//

import UIKit

final class GridLayer: CAShapeLayer {
  
  var insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
  var horizontalLines: Int = 0
  var verticalLines: Int = 0
  
  func drawGrid() {
    
    if horizontalLines + verticalLines <= 0 { return }
    
    let linePath = UIBezierPath()
    if horizontalLines > 0 {
      for i in 0...(horizontalLines - 1) {
        
        var y: CGFloat = frame.height / CGFloat((horizontalLines - 1)) * CGFloat(i) + insets.top
        
        if i == 0 {
          y += lineWidth
        } else if i == (horizontalLines - 1) {
          y -= lineWidth
        }
        
        let moveX: CGFloat = insets.left
        let addLineX: CGFloat = frame.width - insets.right
        
        linePath.move(to: CGPoint(x: moveX + lineWidth, y: y))
        linePath.addLine(to: CGPoint(x: addLineX - lineWidth, y: y))
      }
    }
    
    if verticalLines > 0 {
      for i in 0...(verticalLines - 1) {
        let x: CGFloat = frame.width / CGFloat((verticalLines - 1)) * CGFloat(i) + insets.left
        let moveY: CGFloat = insets.top
        let addLineY: CGFloat = insets.top + frame.height
        
        if i == verticalLines - 1 {
          linePath.move(to: CGPoint(x: x - lineWidth, y: moveY))
          linePath.addLine(to: CGPoint(x: x - lineWidth, y: addLineY))
        } else {
          linePath.move(to: CGPoint(x: x + lineWidth, y: moveY))
          linePath.addLine(to: CGPoint(x: x + lineWidth, y: addLineY))
        }
      }
    }
    
    path = linePath.cgPath
  }
}
