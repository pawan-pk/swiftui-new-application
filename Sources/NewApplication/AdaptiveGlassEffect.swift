//
//  AdaptiveGlassEffect.swift
//  NewApplication
//
//  Created by Pawan Kushwaha on 14/03/26.
//
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import SwiftUI

public enum AdaptiveGlassType: Sendable {
    case regular
    case clear
    case identity
}

@available(iOS 15.0, macOS 10.15, *)
public struct AdaptiveGlass: Equatable, Sendable {
    public let type: AdaptiveGlassType
    public var tint: Color?
    public let isEnabled: Bool
    
    public init(type: AdaptiveGlassType, tint: Color? = nil, isEnabled: Bool = true) {
        self.type = type
        self.tint = tint
        self.isEnabled = isEnabled
    }
    
    public static var regular: AdaptiveGlass { AdaptiveGlass(type: .regular, isEnabled: true) }
    public static var clear: AdaptiveGlass { AdaptiveGlass(type: .clear, isEnabled: true) }
    public static var identity: AdaptiveGlass { AdaptiveGlass(type: .identity, isEnabled: true) }
    
    public func tint(_ color: Color?) -> AdaptiveGlass {
        AdaptiveGlass(type: self.type, tint: color, isEnabled: self.isEnabled)
    }
    
    public func interactive(_ isEnabled: Bool = true) -> AdaptiveGlass {
        AdaptiveGlass(type: self.type, tint: self.tint, isEnabled: isEnabled)
    }
    
    public static func == (a: AdaptiveGlass, b: AdaptiveGlass) -> Bool {
        return a.type == b.type
    }
}

@available(iOS 15.0, macOS 10.15, *)
extension AdaptiveGlass {
    @available(iOS 26.0, macOS 26.0, *)
    var glass: Glass {
        var glass: Glass
        switch self.type {
            case .regular:
                glass = .regular
            case .clear:
                glass = .clear
            case .identity:
                glass = .identity
        }
        if self.tint != nil {
            glass = glass.tint(self.tint)
        }
        glass = glass.interactive(self.isEnabled)
        
        return glass
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    var material: some ShapeStyle {
        switch self.type {
            case .regular:
                return Material.regular.opacity(0.7)
            case .clear:
                return Material.ultraThin.opacity(0.2)
            case .identity:
                return Material.thin.opacity(0)
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
public struct AdaptiveGlassEffect<S: Shape>: ViewModifier {
    var adaptiveGlass: AdaptiveGlass = .regular
    var shape: S
    
    public init(adaptiveGlass: AdaptiveGlass = .regular, shape: S) {
        self.adaptiveGlass = adaptiveGlass
        self.shape = shape
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            content
                .glassEffect(adaptiveGlass.glass, in: shape)
        } else {
            content
                .ifLet(adaptiveGlass.tint, transform: { value, content in
                    content.background(
                        adaptiveGlass.type != .identity ? value : .clear,
                        in: shape
                    )
                })
                .background(adaptiveGlass.material, in: shape)
                .if(adaptiveGlass.type != .identity, transform: { view in
                    view.overlay {
                        shape.stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.6),
                                    .clear,
                                    .white.opacity(0.6),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    }
                })
                .allowsHitTesting(adaptiveGlass.isEnabled)
        }
    }
}
