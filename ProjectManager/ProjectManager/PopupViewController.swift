//
//  PopupViewController.swift
//  ProjectManager
//
//  Created by Andrew on 2023/05/19.
//
//

import UIKit
import SnapKit

class PopupViewController: UIViewController {
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let titleTextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해주세요"
        return textField
    }()
    
    private let datePicker = {
        let date = UIDatePicker()
        return date
    }()
    
    private let contentTextView = {
        let textView = UITextView()
        // placeholder 넣기
        return textView
    }()
    
    private let popupStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(containerView)
        containerView.addSubview(popupStackView)
        
        popupStackView.addArrangedSubview(titleTextField)
        popupStackView.addArrangedSubview(datePicker)
        popupStackView.addArrangedSubview(contentTextView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        popupStackView.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(10)
            $0.right.equalTo(10)
            $0.bottom.equalTo(10)
        }
    }
    
}

//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//
//    // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
//    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
//        self?.containerView.transform = .identity
//        self?.containerView.isHidden = false
//    }
//}
//
//override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//
//    // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
//    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
//        self?.containerView.transform = .identity
//        self?.containerView.isHidden = true
//    }
//}
