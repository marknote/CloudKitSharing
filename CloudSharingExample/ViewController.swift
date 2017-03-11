//
//  ViewController.swift
//  CloudSharingExample
//
//  Created by Hans Knöchel on 14.06.16.
//  Copyright © 2016 Appcelerator. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UICloudSharingControllerDelegate {
    let customZoneName = "TestZone"
    let recordTypeName = "TestRecord"
    @IBAction func didTapCreateCustomZoneButton(){
        let container: CKContainer = CKContainer.default()
        
        let privateDatabase = container.privateCloudDatabase
        let customZone = CKRecordZone(zoneName: customZoneName)
        privateDatabase.save(customZone, completionHandler: ({returnRecord, error in
            if error != nil {
                // Zone creation failed
                OperationQueue.main.addOperation {
                    print("Cloud Error:\(error?.localizedDescription)")
                }
            } else {
                // Zone creation succeeded
                OperationQueue.main.addOperation {
                    print( "The \(self.customZoneName) was successfully created in the private database.")
                }
            }
        }))
    }
    
    @IBAction func didTapCloudSharingButton() {
        
    
        let container: CKContainer = CKContainer.default()
        
        let privateDatabase = container.privateCloudDatabase
        
        
        let customZone = CKRecordZone(zoneName: customZoneName)
        let newRecord = CKRecord(recordType: recordTypeName, zoneID: customZone.zoneID)
         newRecord.setObject("test" as CKRecordValue?, forKey: "content")
        
       
        
        let cloudSharingController: UICloudSharingController = UICloudSharingController{ controller,
            preparationCompletionHandler in
            
            let share: CKShare = CKShare(rootRecord: newRecord)
            share[CKShareTitleKey] = "hello" as CKRecordValue?
            
            
            let modifyRecordsOperation = CKModifyRecordsOperation( recordsToSave: [newRecord, share], recordIDsToDelete: nil)
            
            modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                if records != nil {
                    print("Share and Root records saved successfully")
                }
                preparationCompletionHandler(share,  container , error)
            }
            
            privateDatabase.add(modifyRecordsOperation)
        }
        cloudSharingController.delegate = self
        cloudSharingController.popoverPresentationController?.sourceView = self.view
        // Set sharing permissions
        cloudSharingController.availablePermissions = [.allowPublic, .allowReadOnly]
        
        
        // Show cloud shareing dialog
        self.present(cloudSharingController, animated: true, completion: nil)
        
        
    }
    public func itemTitle(for csc: UICloudSharingController) -> String? {
        return "here"
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("cloudSharingControllerDidSaveShare")
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        print("cloudSharingControllerDidStopSharing")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failedToSaveShareWithError: \(error.localizedDescription)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

