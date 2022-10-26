//
//  EmoticonModel.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/20.
//

import Foundation


struct EmoticonGroupModel : Codable {
    let groupImg:String
    let groupName:String
    let groupImgPath:String
    let groupId:String
    
}

struct EmoticonModel:Codable {
    let isSystem:Int
    let emojiName:String
    let fileName:String
    let groupName:String
    let groupImgPath:String
    let emotId:String
    let emotType:Int
    let imgpath:String
    let namelang:String
    let groupId:String
    let groupImg:String
    let frameFile:[EmoticonFrameModel]
    
}

struct EmoticonPageModel:Identifiable {
    let id = UUID().uuidString
    let subList:[EmoticonModel]
    
}

struct EmoticonFrameModel :Codable {
    let frameFileName:String
}
