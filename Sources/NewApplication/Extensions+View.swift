//
//  Extensions+View.swift
//  NewApplication
//
//  Created by Pawan Kushwaha on 11/03/26.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
extension View {
    
    // MARK: - Conditional rendering
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func ifLet<Content: View, Value>(_ value: Value?, transform: (_ value: Value, _ content: Self) -> Content) -> some View {
        if let value {
            transform(value, self)
        } else {
            self
        }
    }
    
    /// Applies a modifier to a view conditionally.
    ///
    /// - Parameters:
    ///   - condition: The condition to determine if the content should be applied.
    ///   - content: The modifier to apply to the view.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<T: View>(
        if condition: @autoclosure () -> Bool,
        then content: (Self) -> T
    ) -> some View {
        if condition() {
            content(self)
        } else {
            self
        }
    }
    
    /// Applies a modifier to a view conditionally.
    ///
    /// - Parameters:
    ///   - condition: The condition to determine the content to be applied.
    ///   - trueContent: The modifier to apply to the view if the condition passes.
    ///   - falseContent: The modifier to apply to the view if the condition fails.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<TrueContent: View, FalseContent: View>(
        if condition: @autoclosure () -> Bool,
        then trueContent: (Self) -> TrueContent,
        else falseContent: (Self) -> FalseContent
    ) -> some View {
        if condition() {
            trueContent(self)
        } else {
            falseContent(self)
        }
    }
    
    // MARK: - Adaptive GlassEffect
    @ViewBuilder func adaptiveGlassEffect(_ adaptiveGlass: AdaptiveGlass = .regular, in shape: some Shape = Capsule()) -> some View {
        self.modifier(AdaptiveGlassEffect(adaptiveGlass: adaptiveGlass, shape: shape))
    }
}
