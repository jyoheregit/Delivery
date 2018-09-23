//
//  BaseViewController.swift
//  Delivery
//
//  Created by Joe on 16/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var loadingView : UIView = {
        let loadingView = UIView()
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.7
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }()
    
    lazy var activityIndicatorView : UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = self.view.center
        return activityIndicatorView
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    lazy var emptyMessageView : UILabel = {
        let messageLabel = UILabel(frame: self.view.frame)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    lazy var connectionLabel : UILabel = {
        let connectionLabel = UILabel()
        connectionLabel.backgroundColor = .red
        connectionLabel.textColor = .white
        connectionLabel.textAlignment = .center
        connectionLabel.text = "No Connection"
        return connectionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = title()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //anchorConnectionLabel()
    }
    
    func setupUI() {}
    func title() -> String? { return nil }
    
    func anchorConnectionLabel(){
        self.view.addSubview(connectionLabel)
        connectionLabel.anchor(top: nil,
                               leading: (anchor: self.view.leadingAnchor, constant: 0),
                               bottom: (anchor: self.view.bottomAnchor, constant: 0),
                               trailing: (anchor: self.view.trailingAnchor, constant: 0))
        connectionLabel.widthAnchor.activateConstraint(equalToConstant: self.view.frame.size.width)
        connectionLabel.heightAnchor.activateConstraint(equalToConstant: 20)
    }

    // MARK: Activity Indicator
    
    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Empty Message
    
    func emptyMessageViewWith(message : String?) -> UILabel {
        emptyMessageView.text = message
        return emptyMessageView
    }
    
    // MARK: Refresh Control
    
    @objc func refresh(){
        print("refresh called");
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
