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
    @IBOutlet weak var animatingGradientBar: AnimatingGradientBarView!
    var animatingGradientCircle: AnimatingGradientCircle?
    let gradientColors: [UIColor] = [.white, .white, .white, .white, .lightGray, .gray, .darkGray, .black]
    let outsideColor = UIColor.black

    let viewWidth: CGFloat = 100
    let strokeWidth: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = outsideColor
        setupBarGraph()
    }

    func setupBarGraph() {
        animatingBarGraph.safetyBar.setOutsideColor(UIColor.darkGray)
        animatingBarGraph.upsideBar.setOutsideColor(UIColor.darkGray)
        animatingBarGraph.overallBar.setOutsideColor(UIColor.darkGray)
        animatingBarGraph.matchupBar.setOutsideColor(UIColor.darkGray)
        animatingBarGraph.recentPerfBar.setOutsideColor(UIColor.darkGray)
    }

    func setupGradientCircleView() {
        let gradientCircleView = AnimatingGradientCircle(xPosition: view.frame.width/2 - viewWidth/2, yPosition: 100, width: viewWidth, gradientColors: gradientColors, outsideColor: outsideColor, strokeWidth: strokeWidth)
        animatingGradientCircle = gradientCircleView
        view.addSubview(gradientCircleView)
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animatingBarGraph.animateRatingsBarGraph(duration: 1, ratings: Ratings(overall: 0.78, upside: 0.89, safety: 0.67, matchup: 0.35, recentPerformance: 0.57))

            // animatingGradientCircle?.animateGradientView(duration: 5.0, percentageToFill: 0.78)
        }
    }
}
