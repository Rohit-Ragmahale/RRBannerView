//
//  RRBannerView.swift
//  RRBannerView
//
//  Created by Rohit Ragmahale on 19/03/17.
//  Copyright © 2017 Rohit Ragmahale. All rights reserved.
//

import UIKit

class RRBannerView: UIView {
    // This is enum which decides the position of the banner in view
    enum BannerPosition: Int {
        case top = 0    // Top in view
        case middle = 1 // Middle in view
        case bottom = 2 // Bottom in view. Default value.
    }
    
    private var parentView: UIView? = nil
    private var message: String? = nil
    private var title: String? = nil
    private var image: UIImage? = nil
    
    var autoDismiss: Bool = false
    private let viewDisplayDuration: NSTimeInterval = 3.0
    private let imageViewSize: CGFloat = 30.0
    private let defaultPadding: CGFloat = 10.0
    private let interMessagePadding: CGFloat = 5.0
    private var bannerViewHeight: CGFloat = 100.0
    private let miniBannerHeight: CGFloat = 70.0
    private let maxLineLimitForTitle = 5
    private var position: BannerPosition = .bottom
    private var timer: NSTimer? = nil
    
    // MARK: - Init Methods
    /**
    This method creates new RRBannerView
    
    - parameter title: title to be shown banner.
    - parameter message: message to be shown banner .
    - parameter image: image on banner.
    - parameter view: view in which banner is to be shown.
    */
    convenience init(title: String?, message: String?, image: UIImage?, view: UIView) {
        self.init()
        self.title = title
        self.message = message
        self.image = image
        self.parentView = view
    }
    
    // MARK: - LifeCycle Methods
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = superview {
            self.alpha = 0.0
            populateDetails()
            addToParent()
            addTapgesture()
            if autoDismiss {
                timer = NSTimer.scheduledTimerWithTimeInterval(viewDisplayDuration, target: self, selector: Selector("dissmissSelf:"), userInfo: nil, repeats: true)
            }
            layoutIfNeeded()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.alpha = 1.0
            })
        }
    }
    
    // MARK: - Public Methods
    /**
    This method adds RRBannerView to parent view
    
    - parameter position: banner position in parent view
    
    */
    func show(position: BannerPosition = .bottom) {
        self.position = position
        if let _ = parentView {
            //backgroundColor = UIColor.redColor()
            translatesAutoresizingMaskIntoConstraints = false
            alpha = 0.0
            parentView?.addSubview(self)
        }
    }
    
    // MARK: - Private Methods
    /**
    This method removes RRBannerView from parent view
    
    - parameter sender: UITapGestureRecognizer.
    */
    func dissmissSelf(sender: UITapGestureRecognizer) {
        timer?.invalidate()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.0
            }) { (success: Bool) -> Void in
                self.removeFromSuperview()
        }
    }
    
    /**
     This method adds tap gesture to RRBannerView
     
     */
    private func addTapgesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dissmissSelf:"))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    /**
     This method adds RRBannerView to parent view
     
     */
    private func addToParent() {
        let views : [String : AnyObject] = ["self": self, "parentView": parentView!]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[self]-0-|", options: [.AlignAllCenterY], metrics: nil, views: views)
        switch(position) {
        case .top:
            allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(\(defaultPadding))-[self(\(bannerViewHeight))]", options: [], metrics: nil,views: views)
            break
        case .middle:
            // TODO: Add visual constraint
            allConstraints += [NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: parentView!, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)]
            allConstraints += [NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: bannerViewHeight)]
            break
        case .bottom:
            allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[self(\(bannerViewHeight))]-0-|", options: [], metrics: nil,views: views)
            break
        }
        NSLayoutConstraint.activateConstraints(allConstraints)
    }
    
    private func addTitleLabel(titleLabel: UILabel, containerView: UIView) -> (titleLabel: UILabel, labelHeight: CGFloat) {
        let leftPadding = image == nil ? defaultPadding : defaultPadding + imageViewSize + defaultPadding
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.numberOfLines = maxLineLimitForTitle
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        let views = ["titleLabel" : titleLabel, "containerView" : containerView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(\(leftPadding))-[titleLabel]-(\(defaultPadding))-|", options: [.AlignAllCenterY], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(\(defaultPadding))-[titleLabel]", options: [], metrics: nil,views: views)
        NSLayoutConstraint.activateConstraints(allConstraints)
        titleLabel.text = title
        return (titleLabel: titleLabel, labelHeight: calculateHeightForLabel(titleLabel))
    }
    
    private func addMessageTextView(titleLabel: UILabel, containerView: UIView) -> CGFloat  {
        let messageTextView: UITextView = UITextView(frame: .zero)
        let leftPadding = image == nil ? defaultPadding : defaultPadding + imageViewSize + defaultPadding
        var textViewHeight: CGFloat = 0
        messageTextView.frame = CGRectMake(0, 0, (parentView?.frame.width)! - (image == nil ? defaultPadding * 4 : defaultPadding * 5 + imageViewSize), parentView!.frame.height)
        messageTextView.editable = false
        messageTextView.font = UIFont.systemFontOfSize(14)
        messageTextView.textAlignment = .Center
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageTextView)
        let views = ["titleLabel" : titleLabel, "containerView" : containerView, "messageTextView" : messageTextView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-\(leftPadding)-[messageTextView]-(\(defaultPadding))-|", options: [.AlignAllCenterY], metrics: nil, views: views)
        allConstraints += title?.characters.count > 0 ? NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[titleLabel]-(\(interMessagePadding))-[messageTextView]", options: [], metrics: nil,views: views) : NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(\(defaultPadding))-[messageTextView]", options: [], metrics: nil,views: views)
        messageTextView.text = message
        let maxTextViewHeight: CGFloat = parentView!.frame.height * 0.60
        let contentSize = messageTextView.sizeThatFits(messageTextView.bounds.size)
        textViewHeight = maxTextViewHeight > contentSize.height ? contentSize.height : maxTextViewHeight
        var frame = messageTextView.frame
        frame.size.height = textViewHeight
        messageTextView.frame = frame
        allConstraints += [NSLayoutConstraint(item: messageTextView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: textViewHeight)]
        NSLayoutConstraint.activateConstraints(allConstraints)
        messageTextView.scrollEnabled = (contentSize.height >= maxTextViewHeight) ? true : false
        
        return textViewHeight
    }
    
    private func addImageView(containerView: UIView) {
        let imageView = UIImageView(frame: .zero)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        let views = ["imageView" : imageView, "containerView" : containerView]
        var allConstraints = [NSLayoutConstraint]()
        if title?.characters.count == 0 && message?.characters.count == 0 {
            //allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(defaultPadding)-[imageView(\(imageViewSize))]", options: [.AlignAllCenterY], metrics: nil, views: views)
            
            // TODO: Add visual constraint
            allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)]
            allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: imageViewSize)]
            NSLayoutConstraint.activateConstraints(allConstraints)
        }
        else {
            allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(defaultPadding)-[imageView(\(imageViewSize))]", options: [.AlignAllCenterY], metrics: nil, views: views)
        }
        
        // TODO: Add visual constraint
        allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)]
        allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: imageViewSize)]
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
    private func addContainerView() -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .whiteColor()
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        let views : [String : AnyObject] = ["self": self, "containerView": containerView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(defaultPadding))-[containerView]-(\(defaultPadding))-|", options: [.AlignAllCenterY], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(defaultPadding))-[containerView]-(\(defaultPadding))-|", options: [], metrics: nil,views: views)
        NSLayoutConstraint.activateConstraints(allConstraints)
        return containerView
    }
    
    /**
     This method populates RRBannerView. It adds title, message and image to be shown on banner.
     
     */
    private func populateDetails() {
        var titleLabel: UILabel = UILabel(frame: .zero)
        
        var textViewHeight: CGFloat = 0
        var titleLabelHeight: CGFloat = 0
        var interMessagePadding: CGFloat = 0
        let containerView = addContainerView()
        
        // Add message text if given
        if title?.characters.count > 0 {
            let titleTuple = addTitleLabel(titleLabel, containerView: containerView)
            titleLabel = titleTuple.titleLabel
            titleLabelHeight = titleTuple.labelHeight
            interMessagePadding = self.interMessagePadding
        }
        // Add message text if given
        if message?.characters.count > 0 {
            textViewHeight = addMessageTextView(titleLabel, containerView: containerView)
        }
        // Add image if given
        if let _ = image {
            addImageView(containerView)
        }
        // Calclating view height
        let viewHeight: CGFloat = 4 * defaultPadding + titleLabelHeight + interMessagePadding + textViewHeight
        bannerViewHeight = viewHeight > parentView!.frame.height ? parentView!.frame.height : viewHeight
        bannerViewHeight = (bannerViewHeight >= miniBannerHeight) ? bannerViewHeight : miniBannerHeight
    }
    
    /**
     This method calculates label height
     
     - parameter label: Label whose heigth needs to be calculated.
     
     - returns: view height.
     */
    private func calculateHeightForLabel(label: UILabel) -> CGFloat {
        let leftPadding = image == nil ? defaultPadding * 4 : defaultPadding * 5 + imageViewSize
        let dummylabel:UILabel = UILabel(frame: CGRectMake(0, 0, (parentView?.frame.width)! - leftPadding, CGFloat.max))
        dummylabel.numberOfLines = maxLineLimitForTitle
        dummylabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        dummylabel.font = label.font
        dummylabel.text = label.text
        dummylabel.sizeToFit()
        return dummylabel.frame.height
    }
}
