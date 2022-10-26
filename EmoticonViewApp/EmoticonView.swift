//
//  EmoticonView.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmoticonAnimationModel {
    let id:Int
    let image:UIImage
}

class PreviewEmoticonViewModel:ObservableObject {
    
    @Published var list:[EmoticonAnimationModel] = []
    @Published var completeFlag = false
    
    var imageManager = ImageManager()
    init() {
        
    }
    
    func loadImage(_ urlStrList:[String]) {
        print("urlStrList count : \(urlStrList.count)")
        var failCnt = 0
        for i in urlStrList.indices {
            let str = urlStrList[i]
            imageManager.load(url: URL(string: str))
            imageManager.setOnSuccess { [weak self] image, data, type in
                guard let self = self else { return }
                self.list.append(EmoticonAnimationModel(id: i, image: image))
                // 마지막 한개가 안받아짐
                if urlStrList.count-1-failCnt == self.list.count {
                    print("laod complete")
                    self.completeFlag = true
                }
            }
            imageManager.setOnFailure { error in
                print("\(str) load fail : \(error.localizedDescription)")
                failCnt += 1
            }
        }
        
    }
}

struct PreviewEmoticonView: View {
    
    let emoticonModel:EmoticonModel
    
    let favAction:() -> Void
    let delAction:() -> Void
    
    @StateObject var vm = PreviewEmoticonViewModel()
    
    var body: some View {
        HStack(spacing:0) {
            Spacer()
            VStack {
                Image("ico-star-grey")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.top)
                Spacer()
            }
            .onTapGesture {
                favAction()
            }
            VStack(alignment: .trailing) {
                if vm.completeFlag {
                    WorkoutAnimation(images: vm.list.sorted(by: { e1, e2 in e1.id < e2.id }).map({ model in model.image }))
                        .frame(width: 100, height: 100, alignment: .center)
                }else{
                    // Loading View
                    Rectangle().fill(Color.gray)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                
            }
            VStack {
                Image("x-closewhite")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.top)
                Spacer()
            }
            .onTapGesture {
                delAction()
            }
        }
        .frame(height:140)
        .padding(.trailing, 10)
        .background(Color.black.opacity(0.5))
        .onAppear() {
            vm.loadImage(emoticonModel.frameFile.map({ model in
                "\(BASE_URL)\(EMOTICON_URL)\(model.frameFileName)"
            }))
            
        }
    }
}

struct EmoticonView: View {
    
    @StateObject var vm = EmoticonViewModel()
    
    var rows: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var rows2: [GridItem] = [
        GridItem(.flexible())
    ]
    
    @State var offset = CGPointZero
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing:0) {
                if vm.showPreview, let e = vm.selectedEmoticon {
                    PreviewEmoticonView(emoticonModel: e) {
                        
                    } delAction: {
                        vm.showPreview = false
                    }
                }
                TabView(content: {
                    ForEach(vm.mutateEmoticonList) { pageModel in
                        emoticonPageView(list: pageModel.subList)
                            .padding(.top, 20)
                            .padding(.bottom, 50)
                    }
                    
                })
                .tabViewStyle(.page)
                .frame(height: 200)
                .background(Color("Color"))
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows2) {
                        ForEach(vm.groupList, id: \.groupId) { emoticon in
                            LazyHStack {
                                WebImage(url: URL(string: "\(BASE_URL)\(EMOTICON_URL)\(emoticon.groupImg)"))
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .padding(.trailing, 10)
                                    .frame(width: (UIScreen.main.bounds.width-50) / 5,
                                           height: 40,
                                           alignment: .center)
                            }
                        }
                    }
                }
                .frame(height: 50)
                .padding(.leading, 10)
                .background(Color.gray)
            }
            
        }
        .animation(.none)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        
    }
    
    func emoticonPageView(list:[EmoticonModel]) -> some View {
        return LazyHGrid(rows: rows) {
            ForEach(list, id: \.emotId) { emoticon in
                LazyHStack {
                    WebImage(url: URL(string: "\(BASE_URL)\(EMOTICON_URL)\(emoticon.frameFile[0].frameFileName)"))
                        .resizable()
                        .indicator(.activity)
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width-50) / 3,
                               alignment: .center)
                        .onTapGesture {
                            vm.selectedEmoticon = emoticon
                            if vm.showPreview {
                                // 기존 프리뷰가 있을경우
                                vm.showPreview = false
                                // 임시 방편으로 delay를 줘서 뷰를 새로고침함
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    vm.showPreview = true
                                }
                            }else{
                                vm.showPreview = true
                            }
                            
                        }
                }
            }
            
        }
    }
}

struct EmoticonView_Previews: PreviewProvider {
    static var previews: some View {
        EmoticonView()
    }
}
