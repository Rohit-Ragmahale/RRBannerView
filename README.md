# RRBannerView
Simple banner view that can be used to show short messages and alerts in iOS apps

## Features
* Simple view having title, message and image
* Easy to use
* Tap to dismiss and auto dismiss feature
* Banner can be showned at top / middle / bottom of container view

![visit https://github.com/Rohit-Ragmahale/RRBannerView](https://github.com/Rohit-Ragmahale/RRBannerView/blob/master/Sample.png)

## How to use?

```objc

@IBAction func showBannerViewAtBottom(sender: AnyObject) {
    let bannner: RRBannerView = RRBannerView(title: "RRBannerView", message: "iOS is the second most popular mobile operating system in the world, after Android.", image:UIImage(named: "apple"), view: self.view)
    bannner.autoDismiss = true
    bannner.show(.bottom)
}

```

## TODO
* Action buttons
