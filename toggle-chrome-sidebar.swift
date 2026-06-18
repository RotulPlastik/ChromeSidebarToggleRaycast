#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Toggle Chrome Sidebar
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 📑
// @raycast.packageName Chrome Utils

import AppKit
import ApplicationServices

let targetTitles = ["expand tabs", "collapse tabs"]

guard let chromeApp = NSRunningApplication.runningApplications(
    withBundleIdentifier: "com.google.Chrome"
).first else {
    print("Chrome is not running")
    exit(1)
}

let appElement = AXUIElementCreateApplication(chromeApp.processIdentifier)

var windowsValue: CFTypeRef?
guard AXUIElementCopyAttributeValue(
    appElement,
    kAXWindowsAttribute as CFString,
    &windowsValue
) == .success,
let windows = windowsValue as? [AXUIElement],
let window = windows.first else {
    print("No Chrome windows found")
    exit(1)
}

func findButton(element: AXUIElement, depth: Int = 0) -> AXUIElement? {
    if depth > 10 { return nil }

    var role: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &role)

    var title: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &title)

    var desc: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXDescriptionAttribute as CFString, &desc)

    let roleStr = role as? String ?? ""
    let titleStr = title as? String ?? ""
    let descStr = desc as? String ?? ""

    if roleStr == (kAXButtonRole as String)
        && (targetTitles.contains(titleStr.lowercased()) || targetTitles.contains(descStr.lowercased()))
    {
        return element
    }

    var children: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children)

    guard let childArray = children as? [AXUIElement] else { return nil }

    for child in childArray {
        if let found = findButton(element: child, depth: depth + 1) {
            return found
        }
    }
    return nil
}

guard let button = findButton(element: window) else {
    print("Sidebar toggle button not found in accessibility tree")
    exit(1)
}

AXUIElementPerformAction(button, kAXPressAction as CFString)
