//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by Lee McCormick on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            loadViewIfNeeded() //???
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              
              let body = bodyTextView.text, !body.isEmpty else { return presentErrorToUser(errorText: "Please, enter your title and body.") }
        
        if let entry = entry {
            EntryController.shared.update(entry: entry, title: title, body: body) { (result) in
                switch result {
                case .success(let response):
                    print(response)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        } else {
            EntryController.shared.createEntryWith(title: title, body: body) { (result) in
                switch result {
                case .success(let entry):
                    self.entry = entry
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        bodyTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - Helper Fuctions
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
}

// MARK: - Extension
extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
