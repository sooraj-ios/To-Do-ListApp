//
//  AppActivityIndicator.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit
class ActivityIndicator: UIView {

    private var activityIndicator: UIActivityIndicatorView!
    private var backgroundView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Background view to dim the background
        backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        // Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)

        // Constraints
        NSLayoutConstraint.activate([
            // Background view constraints
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            // Activity Indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // Function to show activity indicator
    func show() {
        if let window = UIApplication.shared.windows.first {
            self.frame = window.bounds
            window.addSubview(self)
            activityIndicator.startAnimating()
        }
    }

    // Function to hide activity indicator
    func hide() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}

