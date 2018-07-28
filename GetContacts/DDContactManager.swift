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
        contacts.sort { (leftContact, rightContact) -> Bool in
            var leftFullName  = ""
            
            if leftContact.isKeyAvailable(CNContactFamilyNameKey){
                leftFullName = leftContact.familyName
            }
            if leftFullName.count == 0 && leftContact.isKeyAvailable(CNContactGivenNameKey){
                leftFullName = leftContact.givenName
            }
            
            var rightFullName = ""
            if rightContact.isKeyAvailable(CNContactFamilyNameKey){
                rightFullName.append(rightContact.familyName)
            }
            if rightFullName.count == 0 && rightContact.isKeyAvailable(CNContactGivenNameKey){
                rightFullName = rightContact.givenName
            }
            var left =  ""
            if leftFullName.isIncludeChinese(){
                left = leftFullName.transformToPinyin().transformToPinyinHead()
            }else{
                left = leftFullName.transformToPinyinHead()
            }
            
            var right =  ""
            if right.isIncludeChinese(){
                right = rightFullName.transformToPinyin().transformToPinyinHead()
            }else{
                right = rightFullName.transformToPinyinHead()
            }
            return left < right
        }
        contactArray(contacts)
    }


    
}
extension String{
    /// 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
//            let little = 0x4e00
            if (0x4e00 < ch.value && ch.value < 0x9fff) {
                return true
            } // 中文字符范围:0x4e00 ~ 0x9fff
        }
        return false
    }
    
    /// 将中文字符串转换为拼音
    ///
    /// - Parameter hasBlank: 是否带空格(默认不带空格)
    func transformToPinyin(hasBlank: Bool =  false) -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }
    /// 获取中文首字母
    ///
    /// - Parameter lowercased: 是否小写(默认大写)
    func transformToPinyinHead(lowercased: Bool = false) -> String {
        let pinyin = self.transformToPinyin(hasBlank: true).capitalized // 字符串转换为首字母大写
        var headPinyinStr = ""
        for ch in pinyin.characters {
            if ch <= "Z" && ch >= "A" {
                headPinyinStr.append(ch) // 获取所有大写字母
            }
        }
        return lowercased ? headPinyinStr.lowercased() : headPinyinStr
    }
}
