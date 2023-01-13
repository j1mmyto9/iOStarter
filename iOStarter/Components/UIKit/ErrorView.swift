//
//  ErrorView.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import UIKit

class ErrorView: UIView {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var messageLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var image: UIImage?
    private var message: String
    
    /// Initialize error view
    /// - Parameters:
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - action: Action to reload fetch data while error occur
    init(image: UIImage? = nil, message: String, tag: Int = 1431) {
        self.image = image
        self.message = message
        
        super.init(frame: .zero)
        
        self.tag = tag
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let hStackView = UIStackView(arrangedSubviews: [imageView, messageLbl])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .vertical
        hStackView.alignment = .center
        hStackView.spacing = 20
        self.addSubview(hStackView)
        
        hStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 40).isActive = true
        hStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 40).isActive = true
        hStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 40).isActive = true
        hStackView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: 40).isActive = true
        
        hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
    }
    
    private func setupView() {
        imageView.image = image
        imageView.isHidden = image == nil
        
        messageLbl.text = message
        
        self.backgroundColor = .clear
    }
    
    private func setContentConstraint(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Show error view in view
    ///
    /// - Parameters:
    ///   - aView: View that will add error view
    func show(in view: UIView) {
        view.addSubview(self)
        setContentConstraint(in: view)
    }

}

extension UIView {
    /// Show error view in front view
    ///
    /// - Parameters:
    ///   - frame: Size & position of error view
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - tapReload: Action to reload fetch data while error occur
    ///   - tag: Mark of error view in superview
    func setErrorView(image: UIImage? = nil, message: String, tag: Int = 1431) {
        let errorView = ErrorView(image: image, message: message, tag: tag)
        if !self.subviews.contains(where: { $0.tag == tag }) {
            errorView.show(in: self)
        }
    }
    
    /// Stop animating activity indicator in superview of current view
    /// - Parameter tag: Mark of error view in superview
    func removeErrorView(tag: Int = 1431) {
        if let errorView = self.subviews.first(where: { $0.tag == tag }) as? ErrorView {
            errorView.removeFromSuperview()
        }
    }
}