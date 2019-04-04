//
//  BHAlert.swift
//  MBAlert
//
//  Created by Bilal Ashraf on 4/4/19.
//  Copyright © 2019 Bitshub Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

private let defaultAlertHeight:CGFloat = 90;
private let defaultAlertWidth:CGFloat = UIScreen.main.bounds.width;
private let screenHeight:CGFloat = UIScreen.main.bounds.height;
private let screenWidth:CGFloat = UIScreen.main.bounds.width;
private let defaultMaxNumberOfAlerts:Int = 3;
private let defaultDismissDelay:TimeInterval = 3;
private let defaultAnimationInterval:TimeInterval = 0.3;
private let defaultErrorColor = UIColor.red;
private let defaultSuccessColor = UIColor.green;
private let defaultPanicColor = UIColor.red;
private let defaultInfoColor = UIColor.yellow;
private let defaultWarningColor = UIColor.orange;
private let defaultUnknownColor = UIColor.black;
private let defaultTitleFont:UIFont = UIFont.init(name: "HelveticaNeue-Light", size: 15) ?? UIFont.systemFont(ofSize: 15);
private let defaultSubtitleFont:UIFont = UIFont.init(name:"HelveticaNeue-Light",size:12) ?? UIFont.systemFont(ofSize: 12)


private var alerts:[BHAlert] = [BHAlert]()

public enum BHAlertType {
    case error
    case success
    case info
    case panic
    case unknown
}

public enum BHAlertPosition {
    case bottom
    case top
}

public enum BHAlertTheme {
    case rounded
    case boxed
    case flat
    case toast
}

typealias ActionBlock = ()->()

public class BHAlert:UIView {
    
    static let errorIconName = "bh_alert_error_icon"
    static let successIconName = "bh_alert_complete_icon"
    static let warnIconName = "bh_alert_info_icon"
    
    // Internal Variables
    var type:BHAlertType = .error
    var position:BHAlertPosition = .top
    var title:String = ""
    var subTitle:String = ""
    var iconImage:UIImage = UIImage.init(named: BHAlert.errorIconName)!
    
    private var yHidden:CGFloat {
        return position == .top ? -defaultAlertHeight : defaultAlertWidth + defaultAlertHeight
    }
    private var yVisible:CGFloat {
        return position == .top ? CGFloat(alerts.count) * defaultAlertHeight : screenHeight - defaultAlertHeight
    }
    
    private var firstViewController: UIViewController? {
        let windows = UIApplication.shared.windows;
        let lastWindow = windows.last;
        return lastWindow?.rootViewController;
    }
    
    
    func show() {
        if alerts.count >= defaultMaxNumberOfAlerts {
            alerts.first?.hide(delay:0);
        }
        if let vc = self.firstViewController {
            OperationQueue.main.addOperation {
                UIView.transition(with: vc.view, duration: defaultAnimationInterval, options: AnimationOptions.curveEaseOut,animations: {
                    vc.view.addSubview(self)
                    self.frame = CGRect.init(x: 0, y: self.yVisible, width: defaultAlertWidth, height: defaultAlertHeight);
                    alerts.append(self);
                }, completion: { finished in
                    if finished { self.hide() }
                });
            }
        }
    }
    
    func hide(delay:TimeInterval = defaultDismissDelay) {
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: defaultAnimationInterval, delay: delay, options: AnimationOptions.curveEaseOut, animations: {
                self.frame = CGRect.init(x: 0, y: self.yHidden, width:defaultAlertWidth, height: defaultAlertHeight);
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                    if let index = alerts.firstIndex(where: { $0 == self }) {
                        alerts.remove(at: index);
                    }
                }
            });
        }
    }
    
    @objc func dismiss(_ sender:Any) {
        self.hide(delay: 0);
    }
    
    func setup() {
        
        switch type {
        case .error:
            backgroundColor = defaultErrorColor;
            iconImage = UIImage.init(named: BHAlert.errorIconName)!;
            break;
        case .panic:
            backgroundColor = defaultPanicColor;
            iconImage = UIImage.init(named: BHAlert.errorIconName)!;
            break;
        case .success:
            backgroundColor = defaultSuccessColor;
            iconImage = UIImage.init(named: BHAlert.successIconName)!;
            break;
        case .info:
            backgroundColor = defaultInfoColor;
            iconImage = UIImage.init(named: BHAlert.warnIconName)!;
            break;
        case .unknown:
            backgroundColor = defaultUnknownColor;
            iconImage = UIImage.init(named: BHAlert.warnIconName)!;
            break;
        }

        self.frame = CGRect.init(x: 0, y: yHidden, width: UIScreen.main.bounds.width, height: 70);
        
        let marginTopRequired:CGFloat = 20;
        let marginY:CGFloat = 8;
        let marginX:CGFloat = 15;
        
        let imageView = UIImageView.init(frame: CGRect.init(x: marginX,
                                                            y: marginY + marginTopRequired,
                                                            width: defaultAlertHeight / 2,
                                                            height: defaultAlertHeight / 2));
        imageView.image = self.iconImage;
        self.addSubview(imageView);
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: marginX + imageView.frame.width + marginX,
                                                    y: marginTopRequired + marginY,
                                                    width: defaultAlertWidth - imageView.frame.width - (marginX * 3),
                                                    height: 14));
        titleLabel.textColor = UIColor.white;
        titleLabel.font = defaultTitleFont;
        titleLabel.text = title;
        self.addSubview(titleLabel);
        
        
        let descriptionLabel = UILabel.init(frame: CGRect.init(x: marginX + imageView.frame.width + marginX,
                                                    y: titleLabel.frame.origin.y + marginY * 2,
                                                    width: defaultAlertWidth - imageView.frame.width - (marginX * 3),
                                                    height: 40));
        descriptionLabel.textColor = UIColor.white;
        descriptionLabel.text = subTitle;
        descriptionLabel.numberOfLines = 3;
        descriptionLabel.font = defaultSubtitleFont
        self.addSubview(descriptionLabel);
        
//        let dismissButton = UIButton.init(frame: self.frame);
//        dismissButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside);
//        dismissButton.isUserInteractionEnabled = true;
//        self.addSubview(dismissButton);
    }
    
    convenience init(type:BHAlertType, position:BHAlertPosition,title:String,subtitle:String) {
        self.init();
        self.title = title;
        self.subTitle = subtitle;
        self.type = type;
        self.position = position;
        setup();
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BHAlert {
    // Static public method
    static func showAlert(type:BHAlertType,position:BHAlertPosition,title:String,subtitle:String) {
        let alert = BHAlert.init(type: type,position: position,title: title,subtitle: subtitle);
        alert.show();
    }
    
    static func hideAll() {
        for alert in alerts { alert.hide(delay:0) }
    }
}
