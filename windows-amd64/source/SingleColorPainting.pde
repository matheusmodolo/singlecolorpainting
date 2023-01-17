//importa a biblioteca de vídeo
import processing.video.*;

//Variável para armazenar o objeto Capture
Capture video;

//Variáveis para a suavização de ruído, usadas posteriormente
float smoothX = 0;
float smoothY = 0;

//Uma variável para rastrear a cor
color trackColor;

//Definição das propriedades iniciais do ambiente
void setup() {
  //Janela com 640x360 píxels
  size(1280, 360);

  //Inicializa o objeto
  //Usa a câmera padrão na resolução da janela
  video = new Capture(this, width/2, height);
  video.start();
  // Inicializa o "trackColor", procurando pelo verde
  trackColor = color(77, 136, 52);

  //Definição da cor do plano de fundo
  background(75);
}

//Um evento para quando um novo quadro estiver disponível
void captureEvent(Capture video) {
  //Lê a imagem da câmera
  video.read();
}

void draw() {
  //Lê os pixels do frame
  //video.loadPixels();
  pushMatrix();
  scale(-1, 1);
  image(video, -video.width*2, 0);
  popMatrix();

  // Antes de começar a procurar o pixel, cria-se o "record"
  //para a cor mais próxima definida, sendo um número alto
  //que é fácil do primeiro pixel alcançar

  //float record = 500;
  float record = 111;

  // X e Y: coordenadas da cor mais próxima
  int closestX = 0;
  int closestY = 0;

  // Inicia o loop para caminhar por todos os pixels
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // Pega a cor atual
      color currentColor = video.pixels[loc];

      //Separa a cor atual nos canais RGB (vermelho, verde e azul)
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      //Separa a cor procurada nos canais RGB (vermelho, verde e azul)
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      //Usando a distância euclediana para comparar o quão próxima
      //é as cores
      //A função dist( ) compara a cor atual com a cor procurada
      float d = dist(r1, g1, b1, r2, g2, b2);

      // Se a cor atual é mais parecida à cor rastreada do que a
      //cor mais próxima, salva a localização atual e a diferença
      //atual.
      if (d < record) {
        record = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  //A função lerp() calcula um número entre dois números em
  //um incremento específico, é usada para criar um movimento
  //suave ao longo de um caminho reto
  smoothX = lerp(smoothX, closestX, 0.1);
  smoothY = lerp(smoothY, closestY, 0.1);

  //Espelha o eixo X
  float x = smoothX;
  float aux = x - 320;
  x = 320 - aux;

  /*espelho1
   float x = smoothX;
   float aux = abs(x - 320);
   if (x > 320) {
     x = 320 - aux;
   } else {
     x = 320 + aux;
   }
   */

  //Só se considera a cor achada se a distância das cores é
  //menor do que 100 e maior do que 30. Esse limite é ajustado
  //dependendo da precisão desejada
  if (record > 30) {
  } else if (record < 100) {
    // Desenha um círculo no píxel rastreado
    fill(trackColor);
    noStroke();
    ellipse(x, smoothY, 20, 20);
  }
}

//Quando o mouse é pressionado, apaga toda a tela
void mousePressed() {
  background(75);
}
