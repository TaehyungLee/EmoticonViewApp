//
//  UIScrollViewWrapper.swift
//  EmoticonViewApp
//
//  Created by Taehyung Lee on 2022/10/24.
//

import SwiftUI

class UIScrollViewViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.alwaysBounceVertical = false
        v.alwaysBounceHorizontal = false
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        return v
    }()

    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.pinEdges(of: self.scrollView, to: self.view)

        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.pinEdges(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)

    }

    func pinEdges(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
        viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
        viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
        viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
        viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }

}

struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {

    var content: () -> Content

    @Binding var offset: CGPoint
    init(_ axes: Axis.Set = .vertical, offset: Binding<CGPoint>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        _offset = offset
    }

    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        let vc = UIScrollViewViewController()
        vc.hostingController.rootView = AnyView(self.content())
        vc.view.layoutIfNeeded ()
        vc.scrollView.contentOffset = offset
        return vc
    }

    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(self.content())
        viewController.scrollView.contentOffset = offset
    }
    
    func makeCoordinator() -> Controller {
        return Controller(parent: self)
    }
    
    class Controller: NSObject, UIScrollViewDelegate {
        var parent: UIScrollViewWrapper<Content>
        init(parent: UIScrollViewWrapper<Content>) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset
        }
    }
}
