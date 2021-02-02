//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Lee McCormick on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

// MARK: - Magic String
struct EntryConstants {
    static let RecordType = "Entry"
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
}

// MARK: - Entry Class
class Entry {
    var title: String
    var body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

// MARK: - Entry Extensions
extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
              let body = ckRecord[EntryConstants.BodyKey] as? String,
              let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date else { return nil}
        
        self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

// MARK: - CKRecord
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordType, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryConstants.TitleKey : entry.title,
            EntryConstants.BodyKey : entry.body,
            EntryConstants.TimestampKey : entry.timestamp,
        ])
    }
}

