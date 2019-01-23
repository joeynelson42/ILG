//
//  DotLayer.swift
//  InteractiveLineGraph
//
//  Created by Joey Nelson on 1/14/19.
//

import UIKit

final class DotLayer: CAShapeLayer {
    
    weak var dataProvider: GraphDataProvider!
    private var dotLayers = [CAShapeLayer]()
    
    func drawDots() {
        let _ = dotLayers.map { $0.removeFromSuperlayer() }
        guard let _ = dataProvider else { return }
        
        for i in 0 ..< dataProvider.totalDataPoints() {
            let circlePath = createCirclePath(forPoint: dataProvider.position(forColumn: i))
            let newDot = CAShapeLayer()
            newDot.path = circlePath.cgPath
            newDot.fillColor = strokeColor
            dotLayers.append(newDot)
        }
        
        let _ = dotLayers.map { self.addSublayer($0) }
    }
    
    // TODO: This needs some work.
    func update() {
        guard let _ = dataProvider else { return }
        for index in 0 ..< (dataProvider.totalDataPoints() - 1) {
    
            let circlePath = createCirclePath(forPoint: dataProvider.position(forColumn: index))
            
            if let existingDot = dotLayers[safe: index] {
                let animation = CABasicAnimation(keyPath: "path")
                animation.fromValue = existingDot.path
                animation.toValue = circlePath.cgPath
                animation.duration = 0.4
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                existingDot.add(animation, forKey: "path")
                existingDot.fillColor = strokeColor
                existingDot.path = circlePath.cgPath
            } else {
                let newDot = CAShapeLayer()
                newDot.path = circlePath.cgPath
                newDot.fillColor = strokeColor
                dotLayers.append(newDot)
                addSublayer(newDot)
            }
        }
    }
    
    private func createCirclePath(forPoint point: CGPoint) -> UIBezierPath {
        var adjustedPoint = point
        adjustedPoint.x -= lineWidth/2
        adjustedPoint.y -= lineWidth/2
        return UIBezierPath(ovalIn: CGRect(origin: adjustedPoint, size: CGSize(width: lineWidth, height: lineWidth)))
    }
}
