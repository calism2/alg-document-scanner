//
//  DocumentScannerDelegate.swift
//  AlgDocumentScanner
//
//  Created by pc on 23.05.2024.
//

import VisionKit

protocol DocumentScannerHandler{
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error)
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController)
}


class DocumentScannerDelegate : NSObject, VNDocumentCameraViewControllerDelegate {
    
    private let resultHandler : DocumentScannerHandler
    
    init(resultHandler: DocumentScannerHandler) {
        self.resultHandler = resultHandler
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        resultHandler.documentCameraViewController(controller, didFinishWith: scan)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        resultHandler.documentCameraViewControllerDidCancel(controller )
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        resultHandler.documentCameraViewController(controller, didFailWithError: error)
        // Handle the error as needed
    }
    
}
