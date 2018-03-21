//
//  ViewController.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/13/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animatingBarGraph: AnimatingBarGraphView!
    var animatingGradientCircle: AnimatingGradientCircle?
    let gradientColors: [UIColor] = [.white, .white, .white, .white, .lightGray, .gray, .darkGray, .black]
    let outsideColor = UIColor(red: 10/255, green: 189/255, blue: 227/255, alpha: 1.0)

    let viewWidth: CGFloat = 100
    let strokeWidth: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = outsideColor

        setupAnimatingBarGraph()
    }

    func setupAnimatingBarGraph() {
        animatingBarGraph.setupGradientBars()
    }

    func setupGradientCircleView() {
        let gradientCircleView = AnimatingGradientCircle(xPosition: view.frame.width/2 - viewWidth/2, yPosition: 100, width: viewWidth, gradientColors: gradientColors, outsideColor: outsideColor, strokeWidth: strokeWidth)
        animatingGradientCircle = gradientCircleView
        view.addSubview(gradientCircleView)
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animatingGradientCircle?.animateGradientView(duration: 5.0, percentageToFill: 0.78)
        }
    }
}
