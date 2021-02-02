//
//  UIViewControllerExtension.swift
//  CloudKitJournal
//
//  Created by Lee McCormick on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    func presentErrorToUser(errorText: String) {
        let alertController = UIAlertController(title: "ERROR", message: errorText, preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
