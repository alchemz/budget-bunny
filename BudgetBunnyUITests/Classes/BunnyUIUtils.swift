//
//  BunnyUIUtils.swift
//  BudgetBunny
//
//  Created by Kiefer Yap on 6/6/16.
//  Copyright © 2016 Kiefer Yap. All rights reserved.
//

import UIKit

class BunnyUIUtils: NSObject {
    
    // Returns an uncommented localized string, given the key. The comments are normally used for your localization team, but, well...)
    class func uncommentedLocalizedString(key: String) -> String {
        return NSLocalizedString(key, bundle: NSBundle.init(forClass: self.classForCoder()), comment: "")
    }
}