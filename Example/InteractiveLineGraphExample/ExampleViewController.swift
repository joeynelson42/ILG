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
    
    // MARK: - View
    let baseView = ExampleView()
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.graphView.interactionDelegate = self
        
        baseView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap)))
        
        baseView.layoutIfNeeded()
        baseView.graphView.configure(withDataPoints: generateRandomList())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseView.graphView.update(withDataPoints: generateRandomList(), animated: true)
    }
    
    @objc func handleTap() {
        baseView.graphView.update(withDataPoints: generateRandomList(), animated: true)
    }
    
    fileprivate func generateRandomList() -> [Double] {
        var list = [Double]()
        for _ in 0 ..< 12 {
            list.append(Double.random(in: 0...50))
        }
        return list
    }
}

extension ExampleViewController: GraphViewInteractionDelegate {
    func graphViewInteraction(userInputDidChange currentIndex: Int) {
        baseView.textLabel.text = "\(currentIndex)"
    }
}
