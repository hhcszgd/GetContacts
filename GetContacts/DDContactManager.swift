//
//  DDContactManager.swift
//  GetContacts
//
//  Created by WY on 2018/7/28.
//  Copyright © 2018年 WY. All rights reserved.
//

import UIKit
import Contacts
class DDContactManager: NSObject {
    
    /// getMobileContacts
    ///
    /// - Parameter contactArray: nil means not authorized
    static func getMobileContacts(contactArray: @escaping ([CNContact]?) -> Void)  {
        let store = CNContactStore()
        store.requestAccess(for: CNEntityType.contacts) { (bool , error ) in
            if bool {
                 DispatchQueue.main.async {
                    self.performRequest(contactArray: contactArray)
                }
            }else{
                contactArray(nil)//not authorized
            }
        }
    }
    private static func performRequest(contactArray: @escaping ([CNContact]?) -> Void){
        var contacts  = [CNContact]()
        let request = CNContactFetchRequest.init(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor , CNContactGivenNameKey as CNKeyDescriptor ,CNContactFamilyNameKey as CNKeyDescriptor ])
        try? CNContactStore().enumerateContacts(with: request) { (contact,  bool) in
            print(bool.pointee )
            if contact.isKeyAvailable(CNContactPhoneNumbersKey){
                for item in  contact.phoneNumbers{
                    if item.value.stringValue.count == 11 && item.value.stringValue.hasPrefix("1"){//chinese mobile number only
                        contacts.append(contact)
                    }
                }
            }
        }
        contactArray(contacts)
    }


    
}
