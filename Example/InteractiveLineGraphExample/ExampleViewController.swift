//
//  ExampleViewController.swift
//  InteractiveLineGraphExample
//
//  Created by Joey Nelson on 1/23/19.
//

import UIKit
import InteractiveLineGraph

class ExampleViewController: UIViewController {
  
  // MARK: - Properties
  private var points = [Double]()
  
  // MARK: - View
  let baseView = ExampleView()
  
  // MARK: - Life Cycle
  override func loadView() {
    super.loadView()
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    baseView.graphView.dataProvider = self
    baseView.graphView.interactionDelegate = self
    
    baseView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap)))
    
    baseView.layoutIfNeeded()
    points = generateRandomList()
    baseView.graphView.update(animated: false)
  }
  
  @objc func handleTap() {
    points = generateRandomList()
    baseView.graphView.update(animated: true)
  }
  
  fileprivate func generateRandomList() -> [Double] {
    var list = [Double]()
    for _ in 0 ..< 12 {
      list.append(Double.random(in: 0...50))
    }
    return list
  }
}

extension ExampleViewController: InteractiveLineGraphDataProvider {
  func detailCardView() -> UIView? {
    return baseView.graphDetailCard
  }
  
  func updateDetailCardView(atIndex index: Int) {
    baseView.graphDetailCard.textLabel.text = "Index #\(index)"
  }
  
  func dataPoints() -> [Double] {
    return points
  }
}

extension ExampleViewController: GraphViewInteractionDelegate {
  func graphViewInteraction(userInputDidChange currentIndex: Int) {
    print("Index #\(index)")
  }
}
