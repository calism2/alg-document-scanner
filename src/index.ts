import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to AlgDocumentScanner.web.ts
// and on native platforms to AlgDocumentScanner.ts
import AlgDocumentScannerModule from './AlgDocumentScannerModule';
import AlgDocumentScannerView from './AlgDocumentScannerView';
import { ChangeEventPayload, AlgDocumentScannerViewProps } from './AlgDocumentScanner.types';

// Get the native constant value.
export const PI = AlgDocumentScannerModule.PI;

export type ScanResult = {
  url: string,
  width: number,
  height: number
}

export async function scan() : Promise<ScanResult[]> {
  return await AlgDocumentScannerModule.scan();
}

export async function setValueAsync(value: string) {
  return await AlgDocumentScannerModule.setValueAsync(value);
}

const emitter = new EventEmitter(AlgDocumentScannerModule ?? NativeModulesProxy.AlgDocumentScanner);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { AlgDocumentScannerView, AlgDocumentScannerViewProps, ChangeEventPayload };
