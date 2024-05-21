import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { AlgDocumentScannerViewProps } from './AlgDocumentScanner.types';

const NativeView: React.ComponentType<AlgDocumentScannerViewProps> =
  requireNativeViewManager('AlgDocumentScanner');

export default function AlgDocumentScannerView(props: AlgDocumentScannerViewProps) {
  return <NativeView {...props} />;
}
