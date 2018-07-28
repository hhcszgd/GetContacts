//
//  ShowingController.swift
//  GetContacts
//
//  Created by WY on 2018/7/28.
//  Copyright © 2018年 WY. All rights reserved.
//

import UIKit
import Contacts
class ShowingController: UITableViewController {
    var contacts  = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    func getContacts() {
        DDContactManager.getMobileContacts { (contacts) in
            if let contacts = contacts{
                self.contacts = contacts
                self.tableView.reloadData()
            }else{
                print("未授权")
                let sure = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                    print("确定")
                    self.openSetting()
                })
                let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
                    print("cancel")
                })
                self.alert( detailTitle: "开启权限", actions: [sure , cancel])
            }
        }
//        let store = CNContactStore()
//        let request = CNContactFetchRequest.init(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor , CNContactGivenNameKey as CNKeyDescriptor ,CNContactFamilyNameKey as CNKeyDescriptor ])
//        self.contacts.removeAll()
//        try? store.enumerateContacts(with: request) { (contact,  bool) in
//            print(bool.pointee )
//            if contact.isKeyAvailable(CNContactPhoneNumbersKey){
//                for item in  contact.phoneNumbers{
//                    if item.value.stringValue.count == 11 && item.value.stringValue.hasPrefix("1"){//chinese mobile number only
//                        self.contacts.append(contact)
//                    }
//                }
//            }
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    
//    func getContacts() {
//        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: "Appleseed")
//        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
//        let store = CNContactStore()
////        store.unifiedContacts(matching: <#T##NSPredicate#>, keysToFetch: <#T##[CNKeyDescriptor]#>)
//        let contacts = try? store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: "关键字"), keysToFetch:[String.init(CNContactGivenNameKey) as CNKeyDescriptor , CNContactFamilyNameKey as CNKeyDescriptor]) //以关键字匹配联系人
//        dump(contacts)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "reuseCell"){
            cell = reuseCell
        }else{
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "reuseCell")
        }
        var fullName  = ""
        var phoneNumber = ""
        
        if self.contacts[indexPath.row].isKeyAvailable(CNContactFamilyNameKey){
            fullName.append(self.contacts[indexPath.row].familyName)
        }
        if self.contacts[indexPath.row].isKeyAvailable(CNContactGivenNameKey){
            fullName.append(self.contacts[indexPath.row].givenName)
        }
        if self.contacts[indexPath.row].isKeyAvailable(CNContactPhoneNumbersKey){
            for item in  self.contacts[indexPath.row].phoneNumbers{
                if item.value.stringValue.count == 11{
                    phoneNumber = item.value.stringValue
                }
            }
            if phoneNumber.count == 0 {
                phoneNumber = self.contacts[indexPath.row].phoneNumbers.first?.value.stringValue ?? "" 
            }
        }
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = phoneNumber
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
