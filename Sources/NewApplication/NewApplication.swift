import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
#Preview {
    ZStack {
        Image("Background", bundle: .module)
            .resizable(resizingMode: .tile)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        ScrollView {
            VStack {
                Text("Pawan Kumar Kushwaha")
                    .padding()
                    .adaptiveGlassEffect(
                        .regular.tint(Color.red.opacity(0.2)),
                        in: RoundedRectangle(cornerRadius: 17)
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
