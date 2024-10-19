//
//  AppToastView.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit

enum ToastType{
    case error
    case success
    case warning
    case info
}

class AppToastView {

    static let shared = AppToastView()

    func showToast(message: String, toastType: ToastType, duration: Double = 3.0) {

        let backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        var borderColor = UIColor.orange
        let textColor = UIColor.white
        var icon = UIImage(named: "warning")?.withRenderingMode(.alwaysTemplate)

        switch toastType{
        case .error:
            borderColor = UIColor.systemRed
            icon = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        case .success:
            borderColor = UIColor.systemGreen
            icon = UIImage(named: "success")?.withRenderingMode(.alwaysTemplate)
        case .warning:
            borderColor = UIColor.systemOrange
            icon = UIImage(named: "warning")?.withRenderingMode(.alwaysTemplate)
        case .info:
            borderColor = UIColor.systemBlue
            icon = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        }

        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            return
        }

        let toastView = UIView()
        toastView.backgroundColor = backgroundColor.withAlphaComponent(0.8)
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        toastView.layer.borderColor = borderColor.cgColor
        toastView.layer.borderWidth = 1

        let iconImageView = UIImageView(image: icon)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = borderColor
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.text = message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        toastView.addSubview(iconImageView)
        toastView.addSubview(messageLabel)
        keyWindow.addSubview(toastView)

        // Set constraints for iconImageView
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Set constraints for messageLabel
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -10)
        ])

        // Set constraints for toastView
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 20),
            toastView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -20),
            toastView.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])

        // Animate the toast view
        toastView.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            toastView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
    }
}
