
import CoreGraphics
import ExpoModulesCore






/**
 Options to use when saving the resulted image.
 */
internal struct ManipulateOptions: Record {


  @Field
  var compress: Double = 1.0

  @Field
  var format: ImageFormat = .jpeg
}


/**
 Enum with supported image formats.
 */
internal enum ImageFormat: String, EnumArgument {
 case jpeg
 case jpg
 case png

 var fileExtension: String {
   switch self {
   case .jpeg, .jpg:
     return ".jpg"
   case .png:
     return ".png"

   }
 }
}
