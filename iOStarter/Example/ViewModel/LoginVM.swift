//
//  LoginVM.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import Foundation

class LoginVM {
    func errorMessage(email: String, password: String) -> String? {
        if email.isEmpty || password.isEmpty {
            return ErrorConstant.completeForm
        }
        if !email.isValidEmail {
            return ErrorConstant.emailValidity
        }
        if !password.isValidPassword {
            return ErrorConstant.passwordValidity
        }
        return nil
    }
    
    func login(email: String, password: String, callback: ViewModelRequestCallback) {
        ApiHelper.shared.localRequest(fileName: "user.json", callback: { json, isSuccess, message in
            if isSuccess {
                let user = User(fromJson: json)
                UserSession.shared.setProfile(user)
            }
            callback?(isSuccess, message)
        })
    }
}
