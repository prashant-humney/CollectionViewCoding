//
//  ViewController.swift
//  CollectionViewCoding
//
//  Created by Prashant Humney on 27/02/21.
//  Copyright © 2021 Prashant Humney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let cellIdentifier = "cellIdentifier"
  let sectionHeaderIdentifier = "headerId"
  var tasks = ["Pay Bills", "Buy Grocery", "Shopping"]
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    navigationItem.title = "To-Do List"
    
  }
  
  private func setupLayouts() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      view.topAnchor.constraint(equalTo: collectionView.topAnchor),
      view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
    ])
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = UIColor.white
    collectionView.alwaysBounceVertical = true
    setupLayouts()
    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(CustomCollectionHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
    cell.nameLabel.text = tasks[indexPath.row]
    return cell
  }
  
  func addTask(_ text: String) {
    tasks.append(text)
    collectionView.reloadData()
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as? CustomCollectionHeaderViewCell else { return UICollectionViewCell() }
    cell.viewController = self
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 100)
  }
}

class CustomCollectionHeaderViewCell: BaseCell {
  var viewController: ViewController?
  
  let textField: UITextField = {
    let view = UITextField()
    view.placeholder = "Enter Task Name"
    view.borderStyle = .roundedRect
    return view
  }()
  
  let button: UIButton = {
    let view = UIButton(type: .system)
    view.setTitle("Add Task", for: .normal)
    view.setTitleColor(UIColor.blue, for: .normal)
    return view
  }()
  
  override func setupViews() {
    addSubview(textField)
    addSubview(button)
    textField.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(self.addAction), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
      textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8.0),
      textField.topAnchor.constraint(equalTo: self.topAnchor,constant: 8.0),
      textField.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -8.0),
      button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
      button.topAnchor.constraint(equalTo: self.topAnchor),
      button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  @objc func addAction() {
    viewController?.addTask(textField.text!)
    textField.text = ""
  }
}

class CustomCollectionViewCell: BaseCell {
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont.boldSystemFont(ofSize: 14.0)
    return label
  }()
  
  override func setupViews() {
    addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -8.0),
      self.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
      self.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8.0),
      self.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor)
    ])
  }
}

class BaseCell: UICollectionViewCell {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupViews() {}
}
