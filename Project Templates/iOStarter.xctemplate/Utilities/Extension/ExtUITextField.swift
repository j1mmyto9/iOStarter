//
//  ExtUITextField.swift
//  BAPA Leader
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 Reprime. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    /// Connect relation of each field so, return field can use to move in every connected fields
    ///
    /// - Parameter fields: All field that will connect
    class func connect(fields: [UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    /// Set placeholder color of UITextField
    ///
    /// - Parameter color: Color of placeholder
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                             attributes: attributeString)
    }
}
