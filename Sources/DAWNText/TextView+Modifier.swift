import Foundation
import SwiftUI

private struct LineBreakModeKey: EnvironmentKey {
    static let defaultValue: NSLineBreakMode? = nil
}

extension EnvironmentValues {
    public var lineBreakMode: NSLineBreakMode? {
        get { self[LineBreakModeKey.self] }
        set { self[LineBreakModeKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func lineBreakMode(_ mode: NSLineBreakMode?) -> some View {
        environment(\.lineBreakMode, mode)
    }
}

private struct UIFontKey: EnvironmentKey {
    static let defaultValue: UIFont = .preferredFont(forTextStyle: .body)
}

extension EnvironmentValues {
    public var uiFont: UIFont {
        get { self[UIFontKey.self] }
        set { self[UIFontKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func uiFont(_ font: UIFont) -> some View {
        environment(\.uiFont, font)
    }
}

private struct LineFragmentPaddingKey: EnvironmentKey {
    static let defaultValue: Double? = nil
}

extension EnvironmentValues {
    public var lineFragmentPadding: Double? {
        get { self[LineFragmentPaddingKey.self] }
        set { self[LineFragmentPaddingKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    func lineFragmentPadding(_ lineFragmentPadding: Double?) -> some View {
        environment(\.lineFragmentPadding, lineFragmentPadding)
    }
}

private struct UIForegroundColorKey: EnvironmentKey {
    static let defaultValue: UIColor = .label
}

extension EnvironmentValues {
    public var uiforegroundColor: UIColor {
        get { self[UIForegroundColorKey.self] }
        set { self[UIForegroundColorKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func uiforegroundColor(_ uiforegroundColor: UIColor) -> some View {
        environment(\.uiforegroundColor, uiforegroundColor)
    }
}

public enum TextItemType: Sendable, CaseIterable {
    case link
    case textAttachment
    case tag
}

private struct AllowsSelectionTextItemsKey: EnvironmentKey {
    static var defaultValue: [TextItemType] { TextItemType.allCases }
}

extension EnvironmentValues {
    public var allowsSelectionTextItems: [TextItemType] {
        get { self[AllowsSelectionTextItemsKey.self] }
        set { self[AllowsSelectionTextItemsKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func allowsSelectionTextItems(_ types: [TextItemType] = TextItemType.allCases) -> some View {
        environment(\.allowsSelectionTextItems, types)
    }
}

private struct ExtraActionsKey: EnvironmentKey {
    static let defaultValue: [UIAction] = []
}

extension EnvironmentValues {
    public var extraActions: [UIAction] {
        get { self[ExtraActionsKey.self] }
        set { self[ExtraActionsKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func extraActions(_ extraActions: [UIAction]) -> some View {
        environment(\.extraActions, extraActions)
    }
}

public typealias OnCopy = (AttributedString) -> Void

private struct OnCopyKey: EnvironmentKey {
    static var defaultValue: OnCopy? { nil }
}

extension EnvironmentValues {
    public var onCppy: OnCopy? {
        get { self[OnCopyKey.self] }
        set { self[OnCopyKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func onCopy(_ action: @escaping OnCopy) -> some View {
        environment(\.onCppy, action)
    }
}

private struct OnTapTextItemTagActionKey: EnvironmentKey {
    static var defaultValue: OnTapTextItemTagAction? { nil }
}

extension EnvironmentValues {
    public var onTapTextItemTagAction: OnTapTextItemTagAction? {
        get { self[OnTapTextItemTagActionKey.self] }
        set { self[OnTapTextItemTagActionKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func onTapTextItemTag(_ action: @escaping (String) -> Void) -> some View {
        environment(\.onTapTextItemTagAction, OnTapTextItemTagAction(action: action))
    }
}

public struct OnTapTextItemTagAction: Sendable {
    let action: (String) -> Void
    
    func callAsFunction(_ textItemTag: String) {
        action(textItemTag)
    }
}
