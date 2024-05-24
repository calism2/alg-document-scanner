package alg.document.scanner

import android.content.Context
import android.content.Intent
import android.content.IntentSender
import expo.modules.kotlin.activityresult.AppContextActivityResultContract
import expo.modules.kotlin.providers.AppContextProvider
import java.io.Serializable

internal data class ScannerContractOptions(
    /**
     * Destination file in a form of content-[Uri] to save results coming from camera to.
     */
    val uri: IntentSender,
) : Serializable

internal sealed class ImagePickerContractResult private constructor() {
    object Cancelled : ImagePickerContractResult()
    object Error : ImagePickerContractResult()
}
internal class ScannerContract (
    private val appContextProvider: AppContextProvider
) : AppContextActivityResultContract<ScannerContractOptions, ImagePickerContractResult> {
    override fun createIntent(context: Context, input: ScannerContractOptions): Intent {
        TODO("Not yet implemented")
        println("Create Intent")
        context.applicationContext.startIntentSender(input.uri, null, 0, 0, 0)

    }

    override fun parseResult(input: ScannerContractOptions, resultCode: Int, intent: Intent?): ImagePickerContractResult {
        TODO("Not yet implemented")
        println("Parse Result")
    }


}