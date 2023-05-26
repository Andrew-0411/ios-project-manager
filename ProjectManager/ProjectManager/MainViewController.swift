//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SnapKit

enum Section {
    case main
}

struct TodoLabel: Hashable {
    let title: String
    let content: String
    let date: Date
}

class MainViewController: UIViewController {
    private var todoDataSource: UICollectionViewDiffableDataSource<Section, TodoLabel>?
    private var doingDataSource: UICollectionViewDiffableDataSource<Section, TodoLabel>?
    private var doneDataSource: UICollectionViewDiffableDataSource<Section, TodoLabel>?
    private let todoCollectionView = CustomCollectionView()
    private let doingCollectionView = CustomCollectionView()
    private let doneCollectionView = CustomCollectionView()
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoCollectionView, doingCollectionView, doneCollectionView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let todoList = [TodoLabel(title: "책상정리", content: "집중이 안될때 역시나 책상정리", date: Date()), TodoLabel(title: "일기정리", content: "난 가끔 일기를 쓴다", date: Date()), TodoLabel(title: "빨래하기", content: "그만 쌓아두고 싶다....", date: Date())]
    private let doingList = [TodoLabel(title: "Hi!Andrew!Andrew!Andrew!Andrew!Andrew!Andrew!Andrew!Andrew!", content: "is a peninsular region in East Asia. Since 1945, it has been divided at or near the 38th parallel, with North Korea (Democratic People's Republic of Korea) comprising its northern half and South Korea (Republic of Korea) comprising its southern half. Korea consists of the Korean Peninsula, Jeju Island, and several minor islands near the peninsula. The peninsula is bordered by China (Manchuria) to the north and Russia to the northeast, across the Amrok and Duman rivers. It is separated from Japan to the southeast by the Korea Strait.", date: Date()), TodoLabel(title: "Hello~", content: "Brody!", date: Date())]
    private let doneList = [TodoLabel(title: "방정리", content: "눈감고 그댈 그려요 맘속 그댈 찾았죠", date: Date())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        setUpDataSource()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray5
        view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(-50)
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "Project Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }
    
    @objc private func didTapAddButton(sender: UIBarButtonItem) {
        modalPresentationStyle = .fullScreen
        let vc = PopupViewController()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion:nil)
    }
}

// MARK: UICollectionViewDiffableDataSource, CompositionalLayoutConfiguration
extension MainViewController {
    private func configureCellRegistration() -> UICollectionView.CellRegistration<TodoListCell, TodoLabel> {
        return UICollectionView.CellRegistration<TodoListCell, TodoLabel> { cell, IndexPath, todo in
            cell.configure(title: todo.title, content: todo.content, date: todo.date)
        }
    }

    private func configureHeaderRegistration(headerText: String, listCount: Int) -> UICollectionView.SupplementaryRegistration<Header> {
        return UICollectionView.SupplementaryRegistration<Header>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, _) in
            headerView.headerLabel.text = headerText
            headerView.cellCountLabel.text = String(listCount)
        }
    }
    
    private func configureDataSource(collectionView: UICollectionView, registration: UICollectionView.CellRegistration<TodoListCell, TodoLabel>, headerRegistration: UICollectionView.SupplementaryRegistration<Header>) -> UICollectionViewDiffableDataSource<Section, TodoLabel> {
        let dataSource = UICollectionViewDiffableDataSource<Section, TodoLabel>(collectionView: collectionView) { (collectionView, indexPath, todo) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: todo)
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }

    private func setUpDataSource() {
        let registration = configureCellRegistration()
        let todoHeader = configureHeaderRegistration(headerText: "TODO", listCount: todoList.count)
        let doingHeader = configureHeaderRegistration(headerText: "DOING", listCount: doingList.count)
        let doneHeader = configureHeaderRegistration(headerText: "DONE", listCount: doneList.count)

        todoDataSource = configureDataSource(collectionView: todoCollectionView, registration: registration, headerRegistration: todoHeader)
        doingDataSource = configureDataSource(collectionView: doingCollectionView, registration: registration, headerRegistration: doingHeader)
        doneDataSource = configureDataSource(collectionView: doneCollectionView, registration: registration, headerRegistration: doneHeader)

        var todoSnapshot = NSDiffableDataSourceSnapshot<Section, TodoLabel>()
        todoSnapshot.appendSections([.main])
        todoSnapshot.appendItems(todoList, toSection: .main)
        
        var doingSnapshot = NSDiffableDataSourceSnapshot<Section, TodoLabel>()
        doingSnapshot.appendSections([.main])
        doingSnapshot.appendItems(doingList, toSection: .main)
        
        var doneSnapshot = NSDiffableDataSourceSnapshot<Section, TodoLabel>()
        doneSnapshot.appendSections([.main])
        doneSnapshot.appendItems(doneList, toSection: .main)

        todoDataSource?.apply(todoSnapshot, animatingDifferences: true)
        doingDataSource?.apply(doingSnapshot, animatingDifferences: true)
        doneDataSource?.apply(doneSnapshot, animatingDifferences: true)
    }
}
