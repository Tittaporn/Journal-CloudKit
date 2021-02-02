//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Lee McCormick on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

class EntryController {
    
    // MARK: - Properties
    static let shared = EntryController()
    var entries: [Entry] = []
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD Methods
    // CREATE
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        // Create newEntry
        let newEntry = Entry(title: title, body: body)
        
        save(entry: newEntry) { (result) in
            switch result {
            case .success(let entry):
                print("Successfully saving entry in the cloud.")
                return completion(.success(entry))
            case .failure(let error):
                print(error.localizedDescription)
                print("Error saving entry in the cloud. ")
                completion(.failure(.ckError))
            }
        }
        
    }
    
    // SAVE
    func save(entry: Entry, completion: @escaping  (_ result: Result<Entry?, EntryError>) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        // Save the entry
        privateDB.save(entryRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError))
                }
                
                guard let record = record,
                      let savedEntry = Entry(ckRecord: record)
                else { return completion(.failure(.unableToUnwrap))}
                self.entries.append(savedEntry)
                completion(.success(savedEntry))
            }
        }
    }
    
    // READ
    func fetchEntriesWith(completion: @escaping (_ result: Result<[Entry]?, EntryError>) -> Void) {
        // predicate
        let fetchAllEntriesPredicate = NSPredicate(value: true)
        
        // ckQuery
        let entryQuery = CKQuery(recordType: EntryConstants.RecordType, predicate: fetchAllEntriesPredicate)
        
        // perform
        privateDB.perform(entryQuery, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError))
                }
                guard let records = records else { return completion(.failure(.unableToUnwrap))}
                let fetchedEntries = records.compactMap{ Entry(ckRecord: $0)}
                self.entries = fetchedEntries
                print("Successfully fetched all entries.")
                completion(.success(self.entries))
            }
        }
    }
    
    // UPDATE
    func update(entry: Entry, title: String, body: String, completion: @escaping (Result<String, EntryError>) -> Void) {
        entry.title = title
        entry.body = body
        let entryToUpdate = entry.ckRecordID
        privateDB.fetch(withRecordID: entryToUpdate) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError))
                }
                
                guard let record = record else {return completion(.failure(.unableToUnwrap))}
                
                record.setValuesForKeys([
                    EntryConstants.TitleKey : title,
                    EntryConstants.BodyKey : body
                ])
                
                let modifyRecords = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
                modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.changedKeys
                self.privateDB.add(modifyRecords)
                completion(.success("Successfully updating entry in the cloud."))
            }
        }
    }
    
    // DELETE
    func delete(entry: Entry, completion: @escaping (Result<String,EntryError>) -> Void) {
        let entryRecordToDelete = CKRecord(entry: entry)
        
        privateDB.delete(withRecordID: entryRecordToDelete.recordID) { (entryToDelete, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.ckError))
                }
                
                guard let index = self.entries.firstIndex(of: entry) else {return completion(.failure(.ckError))}
                self.entries.remove(at: index)
                return completion(.success("Sucessfully deleting entry in the cloud."))
            }
        }
    }
}

