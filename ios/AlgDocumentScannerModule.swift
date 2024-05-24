import ExpoModulesCore
import VisionKit
import CoreGraphics


struct DocumentScannerContext {
    let promise: Promise
}



internal struct ImageResponse: Record {
    @Field var url: String
    @Field var width: Int
    @Field var height: Int
}



public class AlgDocumentScannerModule: Module,  DocumentScannerHandler{
    
    private var scannerContext: DocumentScannerContext?
    
    typealias SaveImageResult = (url: URL, data: Data)
    
    public func definition() -> ModuleDefinition {
        let documentScannerDelegate = DocumentScannerDelegate(resultHandler: self)

   
        Name("AlgDocumentScanner")
        
     
        
   
        // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
        AsyncFunction("scan") { (promise: Promise)   in
            
            guard let currentVc = appContext?.utilities?.currentViewController() else {
                // throw
                throw Exception(name: "MissionViewController", description: "test")
            }
            
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = documentScannerDelegate
            
            self.scannerContext = DocumentScannerContext(promise: promise)
            
            currentVc.present(documentCameraViewController, animated: true)
            
            
        }.runOnQueue(.main)
        
        
        
        // Enables the module to be used as a native view. Definition components that are accepted as part of the
        // view definition: Prop, Events.
        View(AlgDocumentScannerView.self) {
            // Defines a setter for the `name` prop.
            Prop("name") { (view: AlgDocumentScannerView, prop: String) in
                print(prop)
            }
        }
    }
    
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard let context = scannerContext else {
            print("Context lost")
            return;
        }
        
        
        var images: [ImageResponse] = []
     
        
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            do {
                let savedImage : SaveImageResult =  try saveImage(image, options: ManipulateOptions())
            
                images.append(
                    ImageResponse(url: Field(wrappedValue: savedImage.url.absoluteString), width: Field(wrappedValue: image.cgImage?.width ?? 0), height: Field(wrappedValue: image.cgImage?.height ?? 0))
                )
            
            }catch let error {
                print(error)
            }
        }
        context.promise.resolve(images)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {
        
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        
    }
    
    
    internal func saveImage(_ image: UIImage, options: ManipulateOptions) throws -> SaveImageResult {
      guard let cachesDirectory = self.appContext?.config.cacheDirectory else {
        throw FileSystemNotFoundException()
      }

      let directory = URL(fileURLWithPath: cachesDirectory.path).appendingPathComponent("DocumentScanner")
      let filename = UUID().uuidString.appending(options.format.fileExtension)
      let fileUrl = directory.appendingPathComponent(filename)

      FileSystemUtilities.ensureDirExists(at: directory)
      
        guard let data = image.jpegData(compressionQuality: options.compress) else {
            throw ImageWriteFailedException("JPG data can not created")
        }
      do {
        try data.write(to: fileUrl, options: .atomic)
      } catch let error {
        throw ImageWriteFailedException(error.localizedDescription)
      }
      return (url: fileUrl, data: data)
    }
    
    
}




