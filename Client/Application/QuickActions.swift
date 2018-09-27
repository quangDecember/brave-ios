/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Storage

import Shared
import XCGLogger

enum ShortcutType: String {
    case newTab = "NewTab"

    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }

        self.init(rawValue: last)
    }

    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}

protocol QuickActionHandlerDelegate {
    func handleShortCutItemType(_ type: ShortcutType, userData: [String: NSSecureCoding]?)
}

class QuickActions: NSObject {

    fileprivate let log = Logger.browserLogger

    static let QuickActionsVersion = "1.0"
    static let QuickActionsVersionKey = "dynamicQuickActionsVersion"

    static let TabURLKey = "url"
    static let TabTitleKey = "title"

    fileprivate let lastBookmarkTitle = NSLocalizedString("Open Last Bookmark", tableName: "3DTouchActions", comment: "String describing the action of opening the last added bookmark from the home screen Quick Actions via 3D Touch")
    fileprivate let _lastTabTitle = NSLocalizedString("Open Last Tab", tableName: "3DTouchActions", comment: "String describing the action of opening the last tab sent to Brave from the home screen Quick Actions via 3D Touch")

    static var sharedInstance = QuickActions()

    var launchedShortcutItem: UIApplicationShortcutItem?

    // MARK: Handling Quick Actions
    @discardableResult func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem, withBrowserViewController bvc: BrowserViewController ) -> Bool {

        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard let shortCutType = ShortcutType(fullType: shortcutItem.type) else { return false }

        DispatchQueue.main.async {
            self.handleShortCutItemOfType(shortCutType, userData: shortcutItem.userInfo, browserViewController: bvc)
        }

        return true
    }

    fileprivate func handleShortCutItemOfType(_ type: ShortcutType, userData: [String: NSSecureCoding]?, browserViewController: BrowserViewController) {
        switch type {
        case .newTab:
            handleOpenNewTab(withBrowserViewController: browserViewController, isPrivate: false)
        }
    }

    fileprivate func handleOpenNewTab(withBrowserViewController bvc: BrowserViewController, isPrivate: Bool) {
        bvc.openBlankNewTab(focusLocationField: true, isPrivate: isPrivate)
    }
}
