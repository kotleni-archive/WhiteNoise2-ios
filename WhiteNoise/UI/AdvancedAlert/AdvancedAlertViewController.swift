//
//  AdvancedAlertViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 02.06.2022.
//

import UIKit


final class AdvancedAlertViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public var elements: [AlertElementType]?
    public lazy var advancedAlertView = AdvancedAlertView(viewController: self, elements: elements)
    
    convenience init(elements: [AlertElementType]? = nil) {
        self.init()
        self.elements = elements
        modalPresentationStyle = .overCurrentContext
    }
    
    override func loadView() {
        view = advancedAlertView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        advancedAlertView.alpha = 1
        advancedAlertView.alertBackground.fadeInFromLeftSide { [weak self] in
            self?.advancedAlertView.didAppear()
        }
        advancedAlertView.layoutAfterAppearence()
    }
    
    
    
    public func close() {
        dismissKeyboard()
        advancedAlertView.close()
    }

}
