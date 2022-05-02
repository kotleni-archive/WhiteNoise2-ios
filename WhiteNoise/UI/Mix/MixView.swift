//
//  MixView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit


final class MixView: UIView {
    
    private enum ViewState: String {
        case Create, Saved
    }
    
    private let filterTags = FilterTag.getAllFilterTags()
    private var sounds = Sound.getAllSounds()
    private var filtredSounds = Array<Sound>()
    
    private weak var mixViewDisplayLogic: MixViewDisplayLogic!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var upgradeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Lock")
        button.setTitle("  Upgrate", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Semibold", size: 14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundImage(for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7058823529, blue: 1, alpha: 1)
            .withAlphaComponent(0.1)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIImageView = {
        let image = UIImage(named: "SettingsButton")
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var filterTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterTagCollectionViewCell.self, forCellWithReuseIdentifier: FilterTagCollectionViewCell.nameOfClass)
        
        return collectionView
    }()
    
    private lazy var soundsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SoundCollectionViewCell.self, forCellWithReuseIdentifier: SoundCollectionViewCell.nameOfClass)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private lazy var segmentControl: CustomSegmentedControl = {
        let titles = [ViewState.Create.rawValue,
                      ViewState.Saved.rawValue
        ]
        let control = CustomSegmentedControl(frame: CGRect.zero, buttonTitle: titles)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var customTabBar: CustomTabBar = {
        let customTabBar = CustomTabBar()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        return customTabBar
    }()
    
    convenience init(viewController: MixViewDisplayLogic) {
        self.init()
        mixViewDisplayLogic = viewController
        setPrimarySettings()
    }
    
    public func getCustomTabBar() -> CustomTabBar {
        customTabBar
    }
    // MARK: - Scroll methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customTabBar.halfFadeIn()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        customTabBar.halfFadeIn()
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonClicked() {
            viewController?.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    
    @objc private func segmentDidChange(_ segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    
    // MARK: - GUI Settings
    
    public func setCollectionViewSettings() {
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView(filterTagCollectionView, didSelectItemAt: indexPath)
        filterTagCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func setPrimarySettings() {
        horizontalStackView.addArrangedSubview(upgradeButton)
        horizontalStackView.addArrangedSubview(settingsButton)
        addSubview(horizontalStackView)
        addSubview(segmentControl)
//        stackView.addArrangedSubview(horizontalStackView)
//        mixViewDisplayLogic.addViewToNavgitaionBar(view: horizontalStackView)
//        stackView.addArrangedSubview(horizontalStackView)
        
//        stackView.setCustomSpacing(25, after: horizontalStackView)
//        stackView.addArrangedSubview(segmentControl)
        stackView.addArrangedSubview(filterTagCollectionView)
        stackView.addArrangedSubview(soundsCollectionView)
        addSubview(stackView)
        setCustomTabBarSettings()
        setupConstraints()
        
    }
    
    private func setupConstraints() {
//        let spacing = UIScreen.main.bounds.size.width / 4
        let spacing = 176.0
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        let upgrateButtonWidth = 112.0

        horizontalStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            .isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true

        
        
        stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor)
            .isActive = true
        

        horizontalStackView.setCustomSpacing(spacing, after: upgradeButton)
        upgradeButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor)
            .isActive = true
        upgradeButton.widthAnchor.constraint(equalToConstant: upgrateButtonWidth)
            .isActive = true
        
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        segmentControl.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 36)
            .isActive = true
        segmentControl.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        filterTagCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        filterTagCollectionView.heightAnchor.constraint(equalTo: segmentControl.heightAnchor, multiplier: 2).isActive = true
        soundsCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    private func setCustomTabBarSettings() {
        let height = 70.0
        let bottomPadding = 50.0
        guard let navigationController = mixViewDisplayLogic.getNavigationController() else { return }
        navigationController.view.addSubview(customTabBar)
        customTabBar.widthAnchor.constraint(equalTo: navigationController.view.widthAnchor, multiplier: 0.65)
            .isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: navigationController.view.centerXAnchor)
            .isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: -bottomPadding)
            .isActive = true
        setSoundsCollectionViewBottomInset(height+bottomPadding)
    }
    
    private func setSoundsCollectionViewBottomInset(_ inset: CGFloat) {
        soundsCollectionView.contentInset.bottom = inset * 1.5
    }
}

// MARK: - CollectionView methods

extension MixView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == soundsCollectionView ? filtredSounds.count : filterTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case soundsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.nameOfClass, for: indexPath) as? SoundCollectionViewCell else { return UICollectionViewCell() }
            let sound = filtredSounds[indexPath.item]
            if sound.isPlaying {
                soundsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                cell.setBackgroundStyle(selectedStyle: .selected(animated: false))
            }
            cell.setCellParameters(sound: sound)
            return cell
        case filterTagCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterTagCollectionViewCell.nameOfClass, for: indexPath) as? FilterTagCollectionViewCell else { return UICollectionViewCell() }
                cell.setCellParameters(filterTag: filterTags[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case soundsCollectionView:
            let height = (24.552 * 1.5 ) + 100 + 10 // 24.552 is font height of label
            return CGSize(width: 100, height: height)
        case filterTagCollectionView:
            return CGSize(width: 100, height: 50)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterTagCollectionView:
            let selectedTag = filterTags[indexPath.row].title
            guard let cell = filterTagCollectionView.cellForItem(at: indexPath) as? FilterTagCollectionViewCell else { return }
            cell.setSelectedStyle()
            filtredSounds = selectedTag != "All" ? sounds.filter { $0.category == selectedTag } : sounds
            soundsCollectionView.reloadData()
            break
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else { collectionView.deselectItem(at: indexPath, animated: true)
                return }
            filtredSounds[indexPath.item].isPlaying = true
            cell.setBackgroundStyle(selectedStyle: .selected(animated: true))
            break
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else { return }
            filtredSounds[indexPath.item].isPlaying = false
            cell.setBackgroundStyle(selectedStyle: .unselected(animated: true))
        default:
            return
        }
    }
    
}
