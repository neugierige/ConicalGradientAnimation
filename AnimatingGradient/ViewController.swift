//
//  ViewController.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/13/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animatingGradientCircle: AnimatingGradientCircle?
    let gradientColors: [UIColor] = [.white, .white, .white, .white, .lightGray, .gray, .darkGray, .black]
    let outsideColor = UIColor(red: 10/255, green: 189/255, blue: 227/255, alpha: 1.0)

    let viewWidth: CGFloat = 300
    let strokeWidth: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = outsideColor
        let gradientCircleView = AnimatingGradientCircle(frame: CGRect(x: view.frame.width/2 - viewWidth/2, y: 100, width: viewWidth, height: viewWidth), gradientColors: gradientColors, outsideColor: outsideColor, strokeWidth: strokeWidth)
        animatingGradientCircle = gradientCircleView
        view.addSubview(gradientCircleView)
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animatingGradientCircle?.animateGradientView(duration: 5.0, percentageToFill: 0.78)
        }
    }
}
