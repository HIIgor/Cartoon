//
//  CTNavigationController.swift
//  Cartoon
//
//  Created by xiangyaguo on 2020/5/13.
//  Copyright © 2020 HiIgor. All rights reserved.
//

import UIKit

class CTNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    func setupLayout() {
        guard let interactionGes = interactivePopGestureRecognizer else { return }
        guard let targetView = interactionGes.view else { return }
        guard let internalTargets = interactionGes.value(forKeyPath: "targets") as? [NSObject] else { return }
        guard let internalTarget = internalTargets.first?.value(forKeyPath: "target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        
        let fullScreenGetsture = UIPanGestureRecognizer(target: internalTarget, action: action)
        fullScreenGetsture.delegate = self
        targetView.addGestureRecognizer(fullScreenGetsture)
        interactionGes.isEnabled = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
}

extension CTNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let leftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight;
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if ges.translation(in: gestureRecognizer.view).x * (leftToRight ? 1 : -1) <= 0 || disablePopGesture{
            return false
        }
        return viewControllers.count != 1;
    }
}

extension CTNavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = topViewController else { return .lightContent }
        return topVC.preferredStatusBarStyle
    }
}

enum CTNavigationBarStyle {
    case theme, clear, white
}

extension UINavigationController {
    private struct AssocatedKeys {
        static var disablePopGesture: Void?
    }
    
    var disablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &AssocatedKeys.disablePopGesture) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssocatedKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setBarStyle(_ style: CTNavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
    }
}


