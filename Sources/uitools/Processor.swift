//
//  ImageProcessor.swift
//  
//
//  Created by Pepe Polenta on 06/08/2020.
//  Copyright © 2020 Pepe Polenta. All rights reserved.
//

import Kingfisher
import UIKit

public struct Processor {

    static let pdf = PDFProcessor()

    public struct Options {
        public static var pdfTemplate:KingfisherOptionsInfo = [.processor(Processor.pdf), .imageModifier(RenderingModeImageModifier(renderingMode: .alwaysTemplate))]
        public static var template: KingfisherOptionsInfo = [.imageModifier(RenderingModeImageModifier(renderingMode: .alwaysTemplate))]
    }

}

public struct PDFProcessor: ImageProcessor {
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
                switch item {
        case .image(let image):
            return image
        case .data(let data):
            guard let provider = CGDataProvider(data: data as CFData),
                let pdfDoc = CGPDFDocument(provider),
                let pdfPage = pdfDoc.page(at: 1) else { return nil }
            var pageRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
            UIGraphicsBeginImageContextWithOptions(pageRect.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect:  pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return pdfImage
        }
    }

    // `identifier` should be the same for processors with same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    public let identifier = UITools.appName

}
