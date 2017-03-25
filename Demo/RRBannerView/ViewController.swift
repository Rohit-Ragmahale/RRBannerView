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
        let bannner: RRBannerView = RRBannerView(title: "RRBannerView", message: "", image:UIImage(named: "like"), view: self.view)
        bannner.autoDismiss = true
        bannner.show(.top)
    }
    
    @IBAction func showBannerViewAtBottom(sender: AnyObject) {
        let bannner: RRBannerView = RRBannerView(title: "RRBannerView", message: "Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved.", image:UIImage(named: "like"), view: self.view)
        bannner.show(.middle)
    }
    
    @IBAction func showBannerViewAtMiddle(sender: AnyObject) {
        let bannner: RRBannerView = RRBannerView(title: "RRBannerView", message: "Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved. Created by Rohit Ragmahale on 19/03/17. Copyright © 2017 Rohit Ragmahale. All rights reserved.", image:UIImage(named: "like"), view: self.view)
        bannner.show(.bottom)
    }

}

