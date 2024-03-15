//
//  CounterViewController.swift
//  Counter
//
//  Created by Юрий Гриневич on 14.03.2024.
//

import UIKit

final class CounterViewController: UIViewController {
    
    private enum Operation {
        case plus
        case minus
        case reset
    }
    
    private var count: Int = 0 {
        didSet {
            counterLabel.text = "\(count)"
        }
    }
    
    private var historyMessage: String {
        get {
            historyTextView.text
        }
        set {
            historyTextView.text += "\n" + newValue
            autoScrollTextView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initialCounterState()
    }
    
    // MARK: - UIProperties
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        button.layer.cornerRadius = 30
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 45, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let historyTextView: UITextView = {
        let text = UITextView()
        text.textAlignment = .left
        text.isEditable = false
        text.font = .systemFont(ofSize: 18, weight: .medium)
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
}

// MARK: - Methods
extension CounterViewController {
    
    @objc private func plusButtonTapped() {
        counterLogic(operation: .plus)
    }
    
    @objc private func minusButtonTapped() {
        counterLogic(operation: .minus)
    }
    
    @objc private func resetButtonTapped() {
        counterLogic(operation: .reset)
    }
    
    private func counterLogic(operation: Operation) {
        switch operation {
        case .plus:
            count += 1
            historyMessage = messageGenerator(text: "значение изменено на +1")
            
        case .minus:
            if count > 0 {
                count -= 1
                historyMessage = messageGenerator(text: "значение изменено на -1")
            } else {
                historyMessage = messageGenerator(text: "попытка уменьшить значение счётчика ниже 0")
            }
            
        case .reset:
            count = 0
            historyMessage = messageGenerator(text: "значение сброшено")
        }
    }
        
    private func messageGenerator(text: String) -> String {
        "[\(Date().formatted(date: .abbreviated, time: .shortened))]: " + text
    }
    
    private func autoScrollTextView() {
        let range = NSMakeRange(historyTextView.text.count - 1, 0)
        historyTextView.scrollRangeToVisible(range)
    }
}

// MARK: - InitialState and Constraints
extension CounterViewController {
    
    private func initialCounterState() {
        counterLabel.text = "\(count)"
        historyTextView.text = "История изменений:"
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(plusButton, minusButton, resetButton, counterLabel, historyTextView)
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        let padding: CGFloat = 40
        let buttonHeight: CGFloat = 60
        
        NSLayoutConstraint.activate([
            
            historyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            historyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            historyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            historyTextView.heightAnchor.constraint(equalToConstant: 200),
            
            counterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -padding),
            counterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            counterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            counterLabel.heightAnchor.constraint(equalToConstant: padding),
            
            plusButton.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: padding),
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            plusButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            plusButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 2 * padding) / 2),
            
            minusButton.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: padding),
            minusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            minusButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            minusButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 2 * padding) / 2),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: padding),
            resetButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            resetButton.widthAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
