import { StyleSheet, Text, View } from 'react-native';

import * as AlgDocumentScanner from 'alg-document-scanner';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{AlgDocumentScanner.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
