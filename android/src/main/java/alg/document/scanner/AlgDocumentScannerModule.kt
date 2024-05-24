package alg.document.scanner



import android.provider.ContactsContract.CommonDataKinds.Im
import android.util.Log
import androidx.core.app.ActivityCompat.startIntentSenderForResult
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.RESULT_FORMAT_JPEG
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.SCANNER_MODE_FULL
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import expo.modules.kotlin.Promise
import expo.modules.kotlin.exception.Exceptions
import expo.modules.kotlin.functions.Queues
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.kotlin.records.Field
import expo.modules.kotlin.records.Record
import java.io.Serializable
import expo.modules.kotlin.exception.CodedException


class Image : Record, Serializable {
  @Field
  val url: String

  constructor(url: String) {
    this.url = url
  }
}

const val SCAN_REQUEST_CODE = 193828221;

class AlgDocumentScannerModule : Module() {


  private val currentActivity
    get() = appContext.currentActivity ?: throw Exceptions.MissingActivity()

  private var promiseContext : Promise? = null


  override fun definition() = ModuleDefinition {

    Name("AlgDocumentScanner")

    OnActivityResult { _, payload ->
      if(payload.requestCode != SCAN_REQUEST_CODE) {
        return@OnActivityResult
      }

      // Check if the user cancelled the scan
      if(payload.data == null) {
        println("cancelled")
        promiseContext?.reject(CodedException("Cancelled"))
        return@OnActivityResult
      }

      // Get the scanned images
      var promiseResult : Array<Image> = emptyArray()

      val result = GmsDocumentScanningResult.fromActivityResultIntent(payload.data);
      if (result != null ) {

        result.pages?.let { pages ->
          for (page in pages) {
            val imageUri = page.imageUri
            promiseResult += Image(imageUri.toString())
          }
        }

        promiseContext?.resolve(promiseResult)
      }
    }


    AsyncFunction("scan") { promise: Promise ->
      val currentActivity = appContext.activityProvider?.currentActivity
      if (currentActivity == null) {
        promise.reject(Exceptions.MissingActivity())
        return@AsyncFunction
      }

      promiseContext = promise;

      val options = GmsDocumentScannerOptions.Builder()
        .setGalleryImportAllowed(true)
        .setPageLimit(10)
        .setResultFormats(RESULT_FORMAT_JPEG)
        .setScannerMode(SCANNER_MODE_FULL)
        .build()
      val scanner = GmsDocumentScanning.getClient(options)


    scanner.getStartScanIntent(currentActivity)
      .addOnSuccessListener {
        Log.d("AlgDocumentScannerModule", it.toString())
        startIntentSenderForResult(currentActivity, it, SCAN_REQUEST_CODE, null, 0, 0, 0, null)
      }
      .addOnFailureListener {
        it.printStackTrace()
        //Handle to failure
      }


    }.runOnQueue(Queues.MAIN)


    // May need in feature
    View(AlgDocumentScannerView::class) {
      // Defines a setter for the `name` prop.
      Prop("name") { view: AlgDocumentScannerView, prop: String ->
        println(prop)
      }
    }
  }








}
