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

    @IBOutlet weak var safetyBar: AnimatingGradientBarView!
    @IBOutlet weak var upsideBar: AnimatingGradientBarView!
    @IBOutlet weak var overallBar: AnimatingGradientBarView!
    @IBOutlet weak var matchupBar: AnimatingGradientBarView!
    @IBOutlet weak var recentPerfBar: AnimatingGradientBarView!

    private var contentView: AnimatingBarGraphView?
    var outsideColor: UIColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        _ = loadFromNib()
    }

    func animateRatingsBarGraph(duration: TimeInterval, ratings: Ratings) {
        safetyBar.animate(duration: duration, percentage: ratings.safety)
        upsideBar.animate(duration: duration, percentage: ratings.upside)
        overallBar.animate(duration: duration, percentage: ratings.overall)
        matchupBar.animate(duration: duration, percentage: ratings.matchup)
        recentPerfBar.animate(duration: duration, percentage: ratings.recentPerformance)
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
