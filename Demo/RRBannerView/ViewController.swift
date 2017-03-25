//
//  ViewController.swift
//  RRBannerView
//
//  Created by Rohit Ragmahale on 19/03/17.
//  Copyright © 2017 Rohit Ragmahale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func showBannerViewAtTop(sender: AnyObject) {
        let bannner: RRBannerView = RRBannerView(title: "", message: "", image:UIImage(named: "like"), view: self.view)
        bannner.autoDismiss = true
        bannner.show(.top)
    }
    
    @IBAction func showBannerViewAtBottom(sender: AnyObject) {
        let bannner: RRBannerView = RRBannerView(title: "RRBannerView", message: "iOS is the second most popular mobile operating system in the world, after Android.", image:nil, view: self.view)
        bannner.autoDismiss = true
        bannner.show(.bottom)
    }
    
    @IBAction func showBannerViewAtMiddle(sender: AnyObject) {
        let bannner: RRBannerView = RRBannerView(title: "iOS", message: "iOS (formerly iPhone OS) is a mobile operating system created and developed by Apple Inc. exclusively for its hardware. It is the operating system that presently powers many of the company's mobile devices, including the iPhone, iPad, and iPod Touch. It is the second most popular mobile operating system globally after Android. iPad tablets are also the second most popular, by sales, against Android since 2013", image:UIImage(named: "like"), view: self.view)
        bannner.show(.middle)
    }

}

