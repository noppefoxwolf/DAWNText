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

public enum SelectionMode: Sendable {
    case all
    case linkOnly
    case none
}

private struct SelectionModeKey: EnvironmentKey {
    static let defaultValue: SelectionMode = .all
}

extension EnvironmentValues {
    public var selectionMode: SelectionMode {
        get { self[SelectionModeKey.self] }
        set { self[SelectionModeKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func selectionMode(_ mode: SelectionMode) -> some View {
        environment(\.selectionMode, mode)
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
