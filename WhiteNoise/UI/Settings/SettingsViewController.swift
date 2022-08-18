//
//  SettingsViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 21.04.2022.
//

import UIKit


final class SettingsViewController: CustomUIViewController {
    private lazy var settingsView: SettingsView = {
        let view = SettingsView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        return view
    }()
    
    
    override func loadView() {
        view = settingsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsView.willAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
