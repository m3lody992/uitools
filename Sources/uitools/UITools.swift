import Foundation
import UIKit
import CoreAudio

public protocol UIToolsStrings {
    var fiveAsters: String { get }
}

public struct UITools {
    
    internal static var shared = UITools()
    
    internal var appName: String!
    internal static var appName: String {
        shared.appName
    }
    
    internal var xmarkURL: URL!
    internal static var xmarkURL: URL {
        shared.xmarkURL
    }
    
    internal var primaryColor: UIColor!
    internal static var primaryColor: UIColor {
        shared.primaryColor
    }
    
    internal var strings: UIToolsStrings!
    internal static var strings: UIToolsStrings {
        shared.strings
    }

    public static func configure(appName: String, primaryColor: UIColor, strings: UIToolsStrings, xmarkURL: URL) {
        shared.appName = appName
        shared.primaryColor = primaryColor
        shared.strings = strings
        shared.xmarkURL = xmarkURL
    }
    
}
