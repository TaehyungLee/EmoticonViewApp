//
//  MainView.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/20.
//

import SwiftUI

class MainViewModel:ObservableObject {
    
    @Published var showEmoticonView = false
    @Published var txt:String = ""
    deinit {
        
    }
    
    init() {
        
    }
}

/*
 [목표]
 - 이모티콘 버튼 누르면 키보드 높이만큼 화면이 나와서 키보드를 덮거나 키보드 내리고 그자리 그대로 이모티콘 보이도록 함
 - 이모티콘 목록에서 하나 선택하면 애니메이션 프리뷰 뜸
 - 한 페이지에 표시되는 이모티콘은 10개 이며, 그 이상이면 페이징 처리
 - 이모티콘 즐찾 기능 구현 : 즐겨찾기 탭이 있으며 선택하면 즐찾한 이모티콘만 표시
 */

struct MainView: View {
    
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        ZStack(alignment:.bottom) {
            GeometryReader{_ in
                VStack {
                    HStack(spacing: 15){
                        
                        TextField("메시지를 입력해 주세요.", text: $vm.txt)
                        Button(action: {
                            
                            UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                            vm.showEmoticonView.toggle()
                            
                        }) {
                            Image(systemName: "smiley").foregroundColor(Color.black.opacity(0.5))
                        }
                        
                    }
                    .padding(12)
                    .background(Color.init(white: 0.89))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    
                }.padding()
            }
            
            EmojiView(show: $vm.showEmoticonView, txt: $vm.txt).offset(y: vm.showEmoticonView ?  (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! : UIScreen.main.bounds.height)
//            EmoticonView()
//                .offset(y: vm.showEmoticonView ? (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! : UIScreen.main.bounds.height)
                
        }
        .animation(.default)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (_) in
                vm.showEmoticonView = false
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
