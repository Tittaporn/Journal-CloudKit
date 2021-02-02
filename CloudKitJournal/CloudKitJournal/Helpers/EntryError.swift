//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Lee McCormick on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError
    case unableToUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError:
            return "The server failed to reach the necessary data."
        case .unableToUnwrap:
            return "Opps, there was an error looking for data in the could."
        }
    }
}


