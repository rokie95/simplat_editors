import java.awt.Color;



ColorCreator cc = new ColorCreator();
ColorSelector cs = new ColorSelector();
TextureOverview to = new TextureOverview();
String[] args = {"second window"};

Color[] colorIndex = new Color[10000];
int bgr = 255;
int bgg = 255;
int bgb = 255;

int colorInverseThreshold = 150;
int colors = 1;
int colorSelected = 0;
int selectedValue = 0;
int[] texture;
String clipboardTexture;
int curTexture = 0;
int textureSize = 8;
int maxTextureSize = 24;
int pixSize = 20;
int roundX = 0;
int roundY = 0;
int pixX = 0;
int pixY = 0;
int textureOffsetX = 20;
int textureOffsetY = 20;
int blinkCount = 0;
int texturepackSize = 0;
int texturepackLength = 0;

float backgroundFlash = 0;
float mouseZoom = 0;

boolean blink = false;
boolean canPlace = true;
boolean[] keys = new boolean[266];

String[] texturepack = new String[10000];
String blankTexture = "";
String textureFilename = "textures.json";


//
// FOURTH WINDOW : OVERVIEW
//

public class TextureOverview extends PApplet {


  void settings() {
    size(710, 710);
  }

  void draw() {
    background(backgroundFlash);
    int[] clickFieldX = new int[10000];
    int[] clickFieldY = new int[10000];
    int texturesOnSide = 16;
    int x = 10;
    int y = 10;
    int totalOutSide = 43;
    int texCount = 0;

    for(int i = 0; i < texturesOnSide; i++) {
        for(int j = 0; j < texturesOnSide; j++) {
          //rect(x,y,10,10);
            
            clickFieldX[texCount] = x;
            clickFieldY[texCount] = y;
            
            stroke(backgroundFlash);
            strokeWeight(3);
            fill(backgroundFlash);
            rect(x,y ,40,40);
            
            noStroke();
            strokeWeight(1);
            if(texturepack[texCount] != null) {
              drawTexture(x, y, 5, texCount);
            }
            
            x += totalOutSide;
            texCount++;
        }
        x = 10;
        y += totalOutSide;
    }
    
    if(mousePressed) {
      for(int i = 0; i < clickFieldY.length; i++) {
        if(mouseX > clickFieldX[i] && mouseX < clickFieldX[i] + totalOutSide && mouseY > clickFieldY[i] && mouseY < clickFieldY[i] + totalOutSide) {
          curTexture = i;
        }
      }
    }
    
  }
  
  void drawTexture(int x, int y, int _pixSize, int texPackNum) {
  fill(255);

  String[] strOut = new String[textureSize*textureSize];
  int[] out = new int[strOut.length];

  for (int i = 0; i < strOut.length; i++) {
    strOut[i] = texturepack[texPackNum].charAt(i*2) + "";
  }

  for (int i = 0; i < strOut.length; i++) {
    out[i] = Integer.parseInt(strOut[i]);
  }

  for (int i = 0; i < textureSize; i++) {
    for (int j = 0; j < textureSize; j++) {

      if (out[i*textureSize+j] == 0) {
        fill(bgr, bgg, bgb);
      } else {
        fill(colorIndex[out[i*textureSize+j]].getRed(),
          colorIndex[out[i*textureSize+j]].getGreen(),
          colorIndex[out[i*textureSize+j]].getBlue());
      }

      if (bgr+bgg+bgb < colorInverseThreshold) {
        stroke(255);
      } else {
        stroke(0);
      }

      if (_pixSize < 5) {
        noStroke();
      } else {
        stroke(0);
      }
      
      try {
      rect(x+i*_pixSize, y+j*_pixSize, _pixSize, _pixSize);
      } catch(NullPointerException e) {
        
      }

      if (out[i*textureSize+j] == 0 && _pixSize > 20) {

        inverseColors(bgr, bgg, bgb);
        text("T", x+i*_pixSize+3, y+j*_pixSize+22);
      }

      stroke(0);
    }
  }
}
}

//
// THIRD WINDOW : COLOR SELECTOR
//
public class ColorSelector extends PApplet {


  void settings() {
    size(400, 600);
  }

  void draw() {
    background(backgroundFlash);

    fill(0);
    if (colors > 0) {
      rect(10, 10+colorSelected*45+17, 200, 16);
      textSize(16);
      if (colorSelected == 0) {
        text("Currently \nSelected \nColor: \nTransparent", 240, 20);
      } else {
        text("Currently \nSelected \nColor: \nR:" + colorIndex[colorSelected].getRed()
          + " G:" + colorIndex[colorSelected].getGreen()
          + " B:" + colorIndex[colorSelected].getBlue()
          , 240, 20);
      }
      fill(colorIndex[colorSelected].getRed(), colorIndex[colorSelected].getGreen(), colorIndex[colorSelected].getBlue());
      rect(240, 120, 100, 200);
    }

    if (colors == 0) {
      fill(0);
      textSize(20);
      text("there are no saved colors \nmake some in the ColorCreator", 20, 30);
    } else {
      for (int i = 0; i < colors; i++) {
        fill(colorIndex[i].getRGB());
        rect(10, 10+i*45+10, 175, 30);
      }
    }
  }

  void keyPressed() {
    if (key == 'w') {
      colorSelected--;
      if (colorSelected < 0) {
        colorSelected = 0;
      }
    }

    if (key == 's') {
      colorSelected++;
      if (colorSelected > colors) {
        colorSelected = colors;
      }
    }
  }
}

public class ColorCreator extends PApplet {
  //
  //SECOND WINDOW : ColorCreator
  //
  int cr = 0;
  int cg = 0;
  int cb = 0;
  int sinceLastSave = -120;
  int selectedColor = 0;

  void settings() {
    size(400, 325);
  }

  void draw() {

    background(backgroundFlash);
    //println(sin(frameCount/10)*50+130);

    fill(0, 0, 0);
    rect(selectedColor*120+15, 5, 110, 85);


    fill(255, 255, 255);
    rect(20, 10, 100, 75);
    rect(140, 10, 100, 75);
    rect(260, 10, 100, 75);


    textSize(25);
    fill(0, 0, 0);
    text(cr, 50, 55);
    text(cg, 170, 55);
    text(cb, 290, 55);


    textSize(12);
    fill(0, 0, 0);
    text("r", 25, 20);
    text("g", 145, 20);
    text("b", 265, 20);


    fill(cr, cg, cb);
    rect(20, 100, 340, 190);


    if (sinceLastSave+120 > frameCount) {
      fill(255);
      textSize(20);
      text("color has been saved", 20, 320);
    }
  }

  void keyPressed() {
    if (key == 'w') {
      colorSelected--;
      if (colorSelected < 0) {
        colorSelected = 0;
      }
    }

    if (key == 's') {
      colorSelected++;
      if (colorSelected > colors) {
        colorSelected = colors;
      }
    }

    if (key == 'e' && sinceLastSave+60 < frameCount) {
      sinceLastSave = frameCount;
      colorIndex[colors] = new Color(cr, cg, cb);
      println(colorIndex[colors].getRGB());
      colors++;
    }

    if (keyCode == RIGHT) {
      selectedColor++;

      if (selectedColor == 3) {
        selectedColor = 2;
      }
    }
    if (keyCode == LEFT) {
      selectedColor--;

      if (selectedColor == -1) {
        selectedColor = 0;
      }
    }
    if (keyCode == UP) {
      if (selectedColor == 0) {
        cr++;
        if (cr > 255)
          cr=255;
      }
      if (selectedColor == 1) {
        cg++;
        if (cg > 255)
          cg=255;
      }
      if (selectedColor == 2) {
        cb++;
        if (cb > 255)
          cb=255;
      }
    }
    if (keyCode == DOWN) {
      if (selectedColor == 0) {
        cr--;
        if (cr < 0)
          cr = 0;
      }
      if (selectedColor == 1) {
        cg--;
        if (cg < 0)
          cg = 0;
      }
      if (selectedColor == 2) {
        cb--;
        if (cb < 0)
          cb = 0;
      }
    }
  }
}

//
//MAIN WINDOW
//

void settings() {

  size(600, 515);


  for (int i = 0; i < colorIndex.length; i++) {
    colorIndex[i] = new Color(255, 255, 255);
  }

  texture = new int[textureSize*textureSize];


  PApplet.runSketch(args, cc);
  PApplet.runSketch(args, cs);
  PApplet.runSketch(args, to);
}

void draw() {
  backgroundFlash = sin(frameCount/10)*50+130;
  background(backgroundFlash);

  if (texturepackSize != textureSize) {
    String textureReplacement = "";

    for (int i = 0; i < textureSize*textureSize; i++) {
      textureReplacement+="0.";
    }
    textureReplacement=textureReplacement.substring(0, textureReplacement.length()-1);
    blankTexture = textureReplacement;

    for (int i = 0; i < texturepack.length; i++) {
      texturepack[i] = textureReplacement;
    }

    texturepackSize = textureSize;
  }

  drawTexture(430, 20, 16, curTexture);

  //for (int i = 0; i < 100; i++) {
  //  if (i == curTexture) {
  //    drawTexture(250-curTexture*110+i*110-20, 380, 15, i);
  //  } else {
  //    drawTexture(250-curTexture*110+i*110, 380, 10, i);
  //  }

  //  fill(0);
  //  text(i, 250-curTexture*110+i*110, 370);
  //}

  //draw selected box first
  fill(0);
  rect(selectedValue*100+15, 400, 90, 75); 
  //text("texturepack: ", 20, 390);

  //draw the texture size input box
  fill(255);
  rect(20, 405, 80, 65);
  rect(120, 405, 80, 65);
  rect(220, 405, 80, 65);
  rect(320, 405, 80, 65);

  //draw text on boxes
  fill(0);

  textSize(13); // small text
  text("textureSize", 22, 417);
  text("bg r", 122, 417);
  text("bg g", 222, 417);
  text("bg b", 322, 417);

  textSize(25); // big text
  text(curTexture+"", 480, 500);
  text(textureSize, 50, 450);
  text(bgr, 135, 450);
  text(bgg, 235, 450);
  text(bgb, 335, 450);

  // find round x and y

  roundX = (round(mouseX/pixSize)*pixSize+pixSize/2+int(mouseZoom))-pixSize;
  roundY = (round(mouseY/pixSize)*pixSize+pixSize/2+int(mouseZoom))-pixSize;

  pixX = ceil(((roundX+textureOffsetX/pixSize)/20)/2);
  pixY = ceil(((roundY+textureOffsetY/pixSize)/20)/2);

  text(ceil(((roundX-20/pixSize)/20)/2) + ", " + ceil(((roundY-20/pixSize)/20)/2) + " canPlace: " + canPlace, 20, 505);

  //draw texture
  if (textureSize > 12) {
    drawTexture(textureOffsetX, textureOffsetY, int(20+mouseZoom), curTexture);
    pixSize=20;
  } else {
    drawTexture(textureOffsetX, textureOffsetY, int(40+mouseZoom), curTexture);
    pixSize=40;
  }

  if (blink) {
    fill(0);
    if (pixX < textureSize && pixY < textureSize) {
      rect(roundX, roundY, int(mouseZoom)+pixSize, int(mouseZoom)+pixSize);
    }
  }

  if (pixX < textureSize && pixY < textureSize) {
    canPlace = true;
    if (mousePressed) {
      saveTexture(curTexture);

      println("set color: " + colorIndex[colorSelected] + "at xblock: " + pixX + " and yblock: " + pixY +
        "\nwith texture value of " + colorSelected + " also saved to texturepack");

      texture[pixX*textureSize+pixY] = colorSelected;
    }
  } else {
    canPlace = false;
  }

  blinkCount++;
  if (blinkCount < 15) {
    blink=false;
  } else if (blinkCount > 15) {
    blink=true;
  }
  if (blinkCount > 30) {
    blinkCount=0;
  }
}

void drawTexture(int x, int y, int _pixSize, int texPackNum) {
  fill(255);

  String[] strOut = new String[textureSize*textureSize];
  int[] out = new int[strOut.length];

  for (int i = 0; i < strOut.length; i++) {
    strOut[i] = texturepack[texPackNum].charAt(i*2) + "";
  }

  for (int i = 0; i < strOut.length; i++) {
    out[i] = Integer.parseInt(strOut[i]);
  }

  for (int i = 0; i < textureSize; i++) {
    for (int j = 0; j < textureSize; j++) {

      if (out[i*textureSize+j] == 0) {
        fill(bgr, bgg, bgb);
      } else {
        fill(colorIndex[out[i*textureSize+j]].getRed(),
          colorIndex[out[i*textureSize+j]].getGreen(),
          colorIndex[out[i*textureSize+j]].getBlue());
      }

      if (bgr+bgg+bgb < colorInverseThreshold) {
        stroke(255);
      } else {
        stroke(0);
      }

      if (_pixSize < 5) {
        noStroke();
      } else {
        stroke(0);
      }
      
      try {
      rect(x+i*_pixSize, y+j*_pixSize, _pixSize, _pixSize);
      } catch(NullPointerException e) {
        
      }

      if (out[i*textureSize+j] == 0 && _pixSize > 20) {

        inverseColors(bgr, bgg, bgb);
        text("T", x+i*_pixSize+3, y+j*_pixSize+22);
      }

      stroke(0);
    }
  }
}

void exportTexturepack() {

  texturepackLength = 0;
  for(int i = 0; i < texturepack.length; i++) {
    if(!texturepack[i].equals(blankTexture)) {
      texturepackLength++;
    }
  }

  processing.data.JSONObject jobj = new processing.data.JSONObject();
  jobj.put("textureSize", textureSize);
  jobj.put("background", String.format("#%02x%02x%02x", bgr, bgg, bgb));

  processing.data.JSONObject clrObj = new processing.data.JSONObject(); //sub json object to put colors in
  clrObj.put("0", "alpha");
  //clrObj.put("9990", "#000000");
  for (int i = 1; i < colors; i++) {
    clrObj.put(i+"", String.format("#%02x%02x%02x", colorIndex[i].getRed(), colorIndex[i].getGreen(), colorIndex[i].getBlue()));
  }
  jobj.setJSONObject("colorIndex", clrObj); //puts the color json object into the main export json "jobj"

  processing.data.JSONObject texObj = new processing.data.JSONObject(); // does the same thing as color json thing

  //if(texturepack[0] == blankTexture) {} else {
  //  texObj.put(0+"", blankTexture);
  //}

  //texObj.put("9999", "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.9990.0.0.0.0.0.0.0.9990.9990.9990.9990.9990.9990.9990.9990.9990.0.9990.0.0.0.9990.0.9990.0.0.9990.0.9990.0.0.9990.0.0.0.9990.0.0.0.0.0.0.0.0.0.0.0.0");

  for (int i = 0; i < texturepackLength+1; i++) {
    texObj.put(i+"", texturepack[i]);
  }
  jobj.setJSONObject("textureData", texObj);

  println(jobj.toString());
  saveStrings("textures.json", jobj.toString().split("\n"));
}

void inverseColors(int r, int g, int b) {
  if (r+g+b < colorInverseThreshold) {
    fill(255);
    stroke(255);
  } else {
    fill(0);
    stroke(0);
  }
}

void saveTexture(int texturePackNum) {
  String out = "";
  for (int i = 0; i < texture.length; i++) {
    out+=texture[i]+".";
  }
  out=out.substring(0, out.length()-1);
  texturepack[texturePackNum] = out;
  println("saved to texturepack[" + texturePackNum + "]");
  println("saved: " + out);
  println();

}

void loadTexture(int texturePackNum) {
  String[] strOut = new String[textureSize*textureSize];
  for (int i = 0; i < strOut.length; i++) {
    strOut[i] = texturepack[texturePackNum].charAt(i*2) + "";
  }

  //for(int i = 0; i < texturepack[texturePackNum].length(); i++) {
  //  strOut[i] =
  //  texturepack[texturePackNum].split(".")[i];
  //}

  int[] out = new int[strOut.length];

  print("loading: " + strOut.length + " :");
  for (int i = 0; i < strOut.length; i++) {
    print(strOut[i] + ".");
  }
  println();

  for (int i = 0; i < strOut.length; i++) {
    out[i] = Integer.parseInt(strOut[i]);
  }

  for (int i = 0; i < out.length; i++) {
    texture[i] = out[i];
  }

  println("loaded texturepack[" + texturePackNum + "]");
  println();
}

void keyPressed() {

  if (keyCode == RIGHT) {
    selectedValue++;

    if (selectedValue == 7) {
      selectedValue = 6;
    }
  }
  if (keyCode == LEFT) {
    selectedValue--;

    if (selectedValue == -1) {
      selectedValue = 0;
    }
  }

  if (key == 'x') {
    exportTexturepack();
  }

  if (key == 'd') {
    saveTexture(curTexture);
    curTexture++;
    loadTexture(curTexture);
  }

  if (key == 'a' && curTexture > 0) {
    saveTexture(curTexture);
    curTexture--;
    loadTexture(curTexture);
  }

  if (key == 'z') {
    importTexturepack();
  }

  if (key == 'c') {
    println("copied: " + texturepack[curTexture]);
    clipboardTexture = texturepack[curTexture];
  }

  if (key == 'v') {
    texturepack[curTexture] = clipboardTexture;
    loadTexture(curTexture);
  }

  if(key == 't') {

    for(int i = curTexture; i < texturepackLength; i++) {
      texturepack[i] = texturepack[i + 1];

      println("texture " + i + " replaced with " + (i+1));
    }
    texturepackLength--;

  }

  if(key == ']') {

    texturepackLength++;

  }

  if(key == '[') {

    texturepackLength--;

  }

  if (key == '.') {
    if (selectedValue == 1) {
      bgr=255;
    }
    if (selectedValue == 2) {
      bgg=255;
    }
    if (selectedValue == 3) {
      bgb=255;
    }
  }

  if (key == ',') {
    if (selectedValue == 1) {
      bgr=0;
    }
    if (selectedValue == 2) {
      bgg=0;
    }
    if (selectedValue == 3) {
      bgb=0;
    }
  }

  if (key == 'w') {
    colorSelected--;
    if (colorSelected < 0) {
      colorSelected = 0;
    }
  }

  if (key == 'z') {
    mouseZoom = 0;
  }

  if (key == 's') {
    colorSelected++;
    if (colorSelected > colors-1) {
      colorSelected = colors-1;
    }
  }

  if (keyCode == UP) {
    if (selectedValue == 0) {
      textureSize++;

      if (textureSize > maxTextureSize) {
        textureSize = maxTextureSize;
      }

      texture = new int[textureSize*textureSize];
    }

    if (selectedValue == 1) {
      bgr++;
      if (bgr > 255)
        bgr=255;
    }

    if (selectedValue == 2) {
      bgg++;
      if (bgg > 255)
        bgg=255;
    }

    if (selectedValue == 3) {
      bgb++;
      if (bgb > 255)
        bgb=255;
    }
  }

  if (keyCode == DOWN) {
    if (selectedValue == 0) {
      textureSize--;

      if (textureSize < 5) {
        textureSize = 5;
      }

      texture = new int[textureSize*textureSize];
    }

    if (selectedValue == 1) {
      bgr--;
      if (bgr < 0)
        bgr=0;
    }

    if (selectedValue == 2) {
      bgg--;
      if (bgg < 0)
        bgg=0;
    }

    if (selectedValue == 3) {
      bgb--;
      if (bgb < 0)
        bgb=0;
    }
  }
}

void importTexturepack() {

  try {
    String texStr = "";
    for (int i = 0; i < loadStrings(textureFilename).length; i++) {
      texStr+=loadStrings(textureFilename)[i] + "\n";
    }
    //println(texStr);
    Object obj = new JSONParser().parse(texStr);

    org.json.simple.JSONObject jObj = (org.json.simple.JSONObject) obj;

    //println(jObj.get("colorIndex"));
    textureSize = Integer.parseInt(jObj.get("textureSize").toString());
    println("texture size: " + textureSize);

    bgr = Color.decode(jObj.get("background").toString()).getRed();
    bgg = Color.decode(jObj.get("background").toString()).getGreen();
    bgb = Color.decode(jObj.get("background").toString()).getBlue();
    println("BACKGROUND R: " + bgr + " G: " + bgg + " B: " + bgb);
    println();

    //Color index
    println("Color Index: ");
    org.json.simple.JSONObject clrJson = (org.json.simple.JSONObject) jObj.get("colorIndex");

    colorIndex[0] = new Color(bgr, bgg, bgb);
    colors = 1;
    for (int i = 1; i < 1000; i++) {
      if (clrJson.get(i+"") != null) {
        colorIndex[i] = Color.decode(clrJson.get(i+"")+"");
        colors++;
        println(colorIndex[i]);
      } else {
        break;
      }
      println(i + "    " + clrJson.get(i+""));
    }

    println();

    //Texture data
    println("Texture Data: ");
    org.json.simple.JSONObject texJson = (org.json.simple.JSONObject) jObj.get("textureData");

    for (int i = 0; i < 1000; i++) {
      if (texJson.get(i+"") != null) {
        texturepack[i] = texJson.get(i+"").toString();
        //println(texturepack[i]);
      } else {
        texturepackLength = i;
        break;
      } 
      println(i + "    " + texJson.get(i+""));
    }

  }
  catch(Exception e) {
    println("error when loading textures ");
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  mouseZoom+=e;
}
