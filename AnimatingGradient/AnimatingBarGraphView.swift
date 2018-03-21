//
//  AnimatingBarGraphView.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/20/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit

struct Ratings {
    var overall: Double
    var upside: Double
    var safety: Double
    var matchup: Double
    var recentPerformance: Double
}

class AnimatingBarGraphView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var safetyBar: StandardGradientView!
    @IBOutlet weak var upsideBar: StandardGradientView!
    @IBOutlet weak var overallBar: StandardGradientView!
    @IBOutlet weak var matchupBar: StandardGradientView!
    @IBOutlet weak var recentPerfBar: StandardGradientView!

    var ratings: Ratings!
    var outsideColor: UIColor = UIColor(red: 10/255, green: 189/255, blue: 227/255, alpha: 1.0)
    
    let safetyBarCoverView = UIView()
    let upsideBarCoverView = UIView()
    let overallBarCoverView = UIView()
    let matchupBarCoverView = UIView()
    let recentPerfBarCoverView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        _ = loadFromNib()
    }

    func setupGradientBars() {
        let gradientViews = [safetyBar!, upsideBar!, overallBar!, matchupBar!, recentPerfBar!]
        gradientViews.forEach {
            $0.configureColors(gradientColors: [UIColor.red, UIColor.yellow, UIColor.green])
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            $0.colorLocations = [0.0, 0.5, 1.0]
        }

        let gradientViewPath = UIBezierPath(roundedRect: safetyBar!.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: safetyBar!.bounds.width/2, height: safetyBar!.bounds.width/2))
        let safetyBarMaskLayer = CAShapeLayer()
        safetyBarMaskLayer.path = gradientViewPath.cgPath
        let upsideBarMaskLayer = CAShapeLayer()
        upsideBarMaskLayer.path = gradientViewPath.cgPath
        let overallBarMaskLayer = CAShapeLayer()
        overallBarMaskLayer.path = gradientViewPath.cgPath
        let matchupBarMaskLayer = CAShapeLayer()
        matchupBarMaskLayer.path = gradientViewPath.cgPath
        let recentPerfBarMaskLayer = CAShapeLayer()
        recentPerfBarMaskLayer.path = gradientViewPath.cgPath

        safetyBar.layer.mask = safetyBarMaskLayer
        upsideBar.layer.mask = upsideBarMaskLayer
        overallBar.layer.mask = overallBarMaskLayer
        matchupBar.layer.mask = matchupBarMaskLayer
        recentPerfBar.layer.mask = recentPerfBarMaskLayer

        setupGradientCovers()
    }

    func setupGradientCovers() {
        let gradientViews = [safetyBar!, upsideBar!, overallBar!, matchupBar!, recentPerfBar!]
        let gradientCoverViews = [safetyBarCoverView, upsideBarCoverView, overallBarCoverView, matchupBarCoverView, recentPerfBarCoverView]
        print("BAR VIEWS")
        print(safetyBar.frame)
        print(upsideBar.frame)
        print(overallBar.frame)
        print(matchupBar.frame)
        print(recentPerfBar.frame)

        print("BAR COVER VIEWS")
        for index in 0...gradientViews.count-1 {
            mainView.addSubview(gradientCoverViews[index])
            gradientCoverViews[index].frame = gradientViews[index].frame
            print(gradientCoverViews[index].frame)
            gradientCoverViews[index].frame.origin = gradientViews[index].frame.origin
            gradientCoverViews[index].backgroundColor = .red
        }
    }

    func animateRatingsBarGraph() {

    }

}

extension UIView {

    func loadFromNib() -> UIView {
        let view = getNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }

    func getNib<T: UIView>() -> T {
        let name = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Could not load \(name)")
        }
        return view
    }
}
