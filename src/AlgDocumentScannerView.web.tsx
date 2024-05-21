import * as React from 'react';

import { AlgDocumentScannerViewProps } from './AlgDocumentScanner.types';

export default function AlgDocumentScannerView(props: AlgDocumentScannerViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
