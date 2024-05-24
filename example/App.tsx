import { StyleSheet, Text, View, Image, Button, ScrollView, Pressable } from 'react-native';
import { manipulateAsync, FlipType, SaveFormat } from 'expo-image-manipulator';

import * as AlgDocumentScanner from 'alg-document-scanner';
import React from 'react';

export default function App() {
  const [images, setImages] = React.useState<AlgDocumentScanner.ScanResult[]>([]);


  return (
    <View style={{flex: 1}}>
      <View style={{flex: 1, backgroundColor: 'powderblue'}} > 
         
        
      </View>
      <View style={{flex: 2, backgroundColor: 'skyblue'}} >
      <ScrollView style={{flex: 1, backgroundColor: 'red'}} >
      <Button
              title='test'
          onPress={async ()=>{
            let result = await AlgDocumentScanner.scan()
            setImages(result)
          }}
 
        ></Button> 
            {images.map(
              (image, i) => 
                <Image key={i} style={{width: 400, height: 450, resizeMode: "contain" , borderWidth: 1, borderColor: 'red'}}  source={{uri: image.url}} ></Image>
            
            )}
      </ScrollView>
    
    </View>
    </View>



  );
}



const styles = StyleSheet.create({
  container: {
    flex: 1
  },
});