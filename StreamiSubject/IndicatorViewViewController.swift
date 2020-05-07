//
//  IndicatorViewViewController.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/07.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit

class IndicatorViewViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static let shardeIndicator: IndicatorViewViewController = IndicatorViewViewController(nibName: "IndicatorViewViewController", bundle: nil)
    
    var add = false
    
    // shared
    class func SharedIndicator() {
        shardeIndicator.initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the v
    }
    
    // initialize
    private func initialize() {
        let frame:CGRect = UIScreen.main.bounds
        self.view.frame = frame
        self.view.isHidden = true
    }
    
    class func isIndicatorShowed() -> Bool {
        return !shardeIndicator.view.isHidden
    }
    
    // indicator hidden( hidden : true , not hidden : false
    class func ShowIndicatorView(showActivityIndicator:Bool) {
        if showActivityIndicator == true {
            if shardeIndicator.add != true {
                shardeIndicator.add = true
                let window:UIWindow = ((UIApplication .shared.delegate?.window)!)!
                DispatchQueue.main.async {
                    window.insertSubview(shardeIndicator.view, at: 10000)
                    shardeIndicator.view.translatesAutoresizingMaskIntoConstraints = false
                    
                    window.addConstraint(NSLayoutConstraint(item: shardeIndicator.view!, attribute: .right, relatedBy: .equal, toItem: window, attribute: .right, multiplier: 1.0, constant: 0))
                    window.addConstraint(NSLayoutConstraint(item: shardeIndicator.view!, attribute: .left, relatedBy: .equal, toItem: window, attribute: .left, multiplier: 1.0, constant: 0))
                    window.addConstraint(NSLayoutConstraint(item: shardeIndicator.view!, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1.0, constant: 0))
                    window.addConstraint(NSLayoutConstraint(item: shardeIndicator.view!, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1.0, constant: 0))
                }
            }
        } else {
            shardeIndicator.view.removeFromSuperview()
            shardeIndicator.add = false
        }
        
        shardeIndicator.view.isHidden = !showActivityIndicator
        
        if showActivityIndicator {
            shardeIndicator.indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            shardeIndicator.indicator.startAnimating()
        } else {
            shardeIndicator.indicator.stopAnimating()
        }
        
    }
    
}
