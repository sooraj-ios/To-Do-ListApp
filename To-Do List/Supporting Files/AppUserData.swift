//
//  AppUserData.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import UIKit
class UserData {
    static let shared = UserData()

    private let userDefault = UserDefaults.standard

    // MARK: - APP USER DATA
    var currentLanguage: String {
        get{
            return userDefault.string(forKey: "currentLanguage") ?? "en"
        }
        set(data) {
            userDefault.set(data, forKey: "currentLanguage")
        }
    }
}
