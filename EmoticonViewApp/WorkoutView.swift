//
//  WorkoutView.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/25.
//

import SwiftUI



struct WorkoutAnimation: UIViewRepresentable {

    var images : [UIImage]

    func makeUIView(context: Self.Context) -> UIView {

        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        guard let animatedImage:UIImage = UIImage.animatedImage(with: images, duration: 1.0) else {
            return someView
        }

        let someImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        someImage.clipsToBounds = true
        someImage.layer.cornerRadius = 20
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFill

        someImage.image = animatedImage
        someView.addSubview(someImage)

        return someView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WorkoutAnimation>) {
        print("updateUIView")
    }
}
//
//class WorkoutViewModel:ObservableObject {
//    @Published var list:[UIImage] = []
//
//}
//
//
//struct WorkoutView: View {
//    var body: some View {
//        VStack (alignment: HorizontalAlignment.center, spacing: 10) {
//            workoutAnimation()
//            Text("zzzz")
//        }
//    }
//}
