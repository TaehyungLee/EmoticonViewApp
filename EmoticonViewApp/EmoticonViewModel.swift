//
//  EmoticonViewModel.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/20.
//

import Foundation

class EmoticonViewModel:ObservableObject {
    
    @Published var emoticonList:[EmoticonModel] = []
    @Published var mutateEmoticonList:[EmoticonPageModel] = []
    @Published var groupList:[EmoticonGroupModel] = []
    
    @Published var showPreview = false
    @Published var selectedEmoticon:EmoticonModel? = nil
    
    let pageNum = 6
    deinit {
        
    }
    
    init() {
        // json 파싱해서 리스트에 저장
        self.emoticonList = self.loadData(fileNameStr: "emoticon_detail")
        
        var pageModel:[EmoticonPageModel] = []
        for i in 0..<emoticonList.count/pageNum + 1 {
            
            let startNum = i * pageNum
            if emoticonList.count > startNum {
                var endNum = ((i+1) * pageNum)
                if emoticonList.count < endNum {
                    endNum = emoticonList.count
                }
                var subList:[EmoticonModel] = []
                for j in startNum..<endNum {
                    subList.append(emoticonList[j])
                }
                pageModel.append(EmoticonPageModel(subList: subList))
            }
            
        }
        self.mutateEmoticonList = pageModel
        
        self.groupList = self.loadData(fileNameStr: "emoticon")
        
    }
    
    func groupLoadData() {
        
    }
    
    func loadData<T:Codable>(fileNameStr:String) -> [T]  {
        guard let url = Bundle.main.url(forResource: fileNameStr, withExtension: "json")
        else {
            print("Json file not found")
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("data make fail")
            return []
        }
//        guard let emoticonList = try? JSONDecoder().decode([EmoticonModel].self, from: data) else {
//            print("JSONDecoder fail")
//            return
//        }
        
        do {
            let list = try JSONDecoder().decode([T].self, from: data)
            return list
        } catch DecodingError.dataCorrupted(let context) {
            print(context.debugDescription)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("\(key.stringValue) was not found, \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("\(type) was expected, \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("no value was found for \(type), \(context.debugDescription)")
        } catch {
            print("I know not this error")
        }
        
        return []
        
    }
    
    
}
