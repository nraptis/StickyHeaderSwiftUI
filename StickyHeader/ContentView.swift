//
//  ContentView.swift
//  StickyHeader
//
//  Created by Nicky Taylor on 11/6/22.
//

import SwiftUI

struct ContentView: View {
    
    static let headerPortrait = UIImage(named: "swift_header_portrait")!
    static let headerLandscape = UIImage(named: "swift_header_landscape")!
    
    @State private var scrollOvershoot: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { outerGeometry in
            scrollView(outerGeometry: outerGeometry)
        }
    }
    
    func scrollView(outerGeometry: GeometryProxy) -> some View {
        
        let landscape = (outerGeometry.size.width > outerGeometry.size.height)
        let image = landscape ? Self.headerLandscape : Self.headerPortrait
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        guard imageWidth > 1.0 else { fatalError("invalid image dimension") }
        guard imageHeight > 1.0 else { fatalError("invalid image dimension") }
        
        let outerGeometryFrame = outerGeometry.frame(in: .global)
        let imageSizeFactor = (outerGeometryFrame.width / imageWidth)
        
        let headerWidth = outerGeometry.size.width
        let headerHeight = imageHeight * imageSizeFactor
        
        return ScrollView {
            VStack(spacing: 0) {
                GeometryReader { innerGeometry in
                    header(outerGeometry: outerGeometry,
                           innerGeometry: innerGeometry,
                           image: image,
                           headerWidth: headerWidth,
                           headerHeight: headerHeight)
                }
                .frame(width: headerWidth,
                       height: headerHeight)
                
                placeholderScrollContent()
            }
        }
    }
    
    func header(outerGeometry: GeometryProxy,
                innerGeometry: GeometryProxy,
                image: UIImage,
                headerWidth: CGFloat,
                headerHeight: CGFloat) -> some View {
        
        let outerGeometryFrame = outerGeometry.frame(in: .global)
        let innerGeometryFrame = innerGeometry.frame(in: .global)
        let overshoot = max(innerGeometryFrame.minY - outerGeometryFrame.minY, 0)
        
        return ZStack {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .offset(y: -overshoot)
            .frame(width: headerWidth,
                   height: headerHeight + overshoot)
        }
        .frame(width: headerWidth,
               height: headerHeight,
               alignment: Alignment(horizontal: .center, vertical: .top))
    }
    
    func placeholderScrollContent() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { index in
                HStack {
                    Spacer()
                    Text("Row: \(index)")
                        .font(.system(size: 32))
                        .padding(.vertical, 12)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .background(RoundedRectangle(cornerRadius: 8.0).stroke().foregroundColor(.gray))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
