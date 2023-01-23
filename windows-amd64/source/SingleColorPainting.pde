//Importa a biblioteca de vídeo.
import processing.video.*;

//Variável para armazenar o objeto Capture.
Capture video;

//Variáveis para a suavização, usadas posteriormente.
float smoothX = 0;
float smoothY = 0;
float x2;

//Uma variável para rastrear a cor.
color trackColor;

//Armazena a cor vermelho, verde e azul para o pincel.
//É uma variável global porque é utilizada posteriormente na função
//keyPressed() e draw().
int vermelho = 0;
int verde = 0;
int azul = 0;

//Armazena o tamanho para o pincel.
//É uma variável global porque é utilizada posteriormente na função
//keyPressed() e draw().
int tamanho = 20;

//Definição das propriedades iniciais do ambiente.
void setup() {
  //Janela com 1280x360 píxels, sendo dividida por duas telas
  //de 640x360, posteriormente.
  size(1280, 360);

  //Inicializa o objeto.
  //Usa a câmera padrão de modo que ocupe metade da largura da janela.
  video = new Capture(this, width/2, height);
  video.start();

  //Inicializa o "trackColor", procurando pela cor verde.
  trackColor = color(77, 136, 52);

  //Definição da cor do plano de fundo.
  background(240);
}

//Um evento para quando um novo quadro estiver disponível.
void captureEvent(Capture video) {
  //Lê a imagem da câmera.
  video.read();
}

//Inicialização das variáveis para o pincel 4
ArrayList passado = new ArrayList();
float distthresh = 600;

void draw() {

  //Lê os pixels do frame, invertendo o eixo X.
  //video.loadPixels();
  pushMatrix();
  scale(-1, 1);
  image(video, -video.width*2, 0);
  popMatrix();

  //Antes de começar a procurar o pixel, cria-se o "record"
  //para a cor mais próxima definida, sendo um número alto
  //que é fácil do primeiro pixel alcançar.
  float record = 111;

  //X e Y: coordenadas da cor mais próxima.
  int closestX = 0;
  int closestY = 0;

  //Inicia o loop para caminhar por todos os pixels.
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;

      //Pega a cor atual
      color currentColor = video.pixels[loc];

      //Separa a cor atual nos canais RGB (vermelho, verde e azul).
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      //Separa a cor procurada nos canais RGB (vermelho, verde e azul).
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      //Usando a distância euclediana para comparar o quão próxima
      //são as duas cores.
      //A função dist() compara a cor atual com a cor procurada.
      float d = dist(r1, g1, b1, r2, g2, b2);

      //Se a cor atual é mais parecida à cor rastreada do que a
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
  //suavizado ao longo de um caminho.
  smoothX = lerp(smoothX, closestX, 0.1);
  smoothY = lerp(smoothY, closestY, 0.1);

  //Espelha o eixo X, na tela de desenho.
  x2 = smoothX;
  float aux = x2 - 320;
  x2 = 320 - aux;

  //Variável para armazenar a cor a ser desenhada,
  //inicializada em preto.
  color colorBrush = color(vermelho, verde, azul);

  //Pincéis.
  //Quando uma tecla estiver pressionada.
  if (keyPressed) {

    //Se a tecla pressionada for '0', é selecionada a borracha.
    if (key == '0') {
      if (record > 30) {
      } else if (record < 100) {
        //Borracha (preenchimento com a cor de fundo).
        fill(240);
        noStroke();
        ellipse(x2, smoothY, tamanho, tamanho);
      }
    }

    //Se a tecla pressionada for '1', o pincel é em formato de círculo.
    if (key == '1') {
      if (record > 30) {
      } else if (record < 100) {

        //Desenha um círculo no píxel rastreado da cor obtida pelo
        //keyPressing(linha 278).
        fill(colorBrush);
        noStroke();
        ellipse(x2, smoothY, tamanho, tamanho);
      }
    }
    if (key == '2') {
      if (record > 30) {
      } else if (record < 100) {

        //Desenha um quadrado no píxel rastreado da cor obtida pelo
        //keyPressing(linha 278).
        fill(colorBrush);
        noStroke();
        rectMode(CENTER);
        rect(x2, smoothY, tamanho, tamanho);
      }
    }
    if (key == '3') {
      if (record > 30) {
      } else if (record < 100) {

        //Desenha uma elipse no píxel rastreado da cor obtida pelo
        //keyPressing(linha 278).
        fill(colorBrush);
        noStroke();
        ellipse(x2, smoothY, tamanho, tamanho/4);
      }
    }
    if (key == '4') {

      //referência: https://note.com/outburst/n/n631a3845186c

      fill(colorBrush, 100);
      noStroke();
      float x, y;

      //Desenha 20 pequenos círculos de uma vez, utilizando a
      //fórmula matemática para os círculos se concentrarem
      //no centro, criando o efeito de spray.
      for (int i = 0; i < 30; i++) {
        float r = random(1);
        float ang = random (TWO_PI);
        x = x2 + r * tamanho * cos (ang);
        y = smoothY + r * tamanho * sin(ang);

        ellipse(x, y, 5, 5);
      }
    }
  }

  //Só se considera a cor achada se a distância das cores é
  //menor do que 100 e maior do que 30. Esse limite é ajustado
  //dependendo da precisão desejada.

  //Mostra no console se está achando a cor configurada.
  isTracked(record);

  //Limpa o texto das cores, do tamanho e das opções de pincel,
  //criando um quadrado da cor do plano de fundo antes do texto.
  fill(240);
  noStroke();
  rectMode(CORNER);
  rect(25, 8, 615, 22);
  rect(25, 30, 70, 22);
  rect(25, 52, 60, 22);

  //Mostra os valores RGB.
  textSize(16);
  fill(vermelho, 0, 0);
  text("Vermelho: " + vermelho, 25, 24);
  fill(0, verde, 0);
  text("Verde: " + verde, 25, 48);
  fill(0, 0, azul);
  text("Azul: " + azul, 25, 72);
  
  //Mostra a cor selecionada
  fill(vermelho, verde, azul);
  ellipseMode(CORNER);
  ellipse(25, 85, 20, 20);

  //Mostra o tamanho do pincel.
  fill(0);
  text("Tamanho: " + tamanho, 150, 24);

  //Mostra as opções de pincel.
  textSize(14);
  text("Borracha(0)  Círculo(1)  Quadrado(2)  Linha(3)  Spray(4)", 270, 24);
}

//Quando o mouse é pressionado, limpa a tela.
void mousePressed() {
  background(240);
}

//Mostra no console se está achando a cor configurada
void isTracked(float record) {
  if (record > 30) {
    println("Não está achando");
  } else if (record< 100) {
    println("Está achando");
  }
}

void keyPressed() {

  //Quando a tecla 0 é pressionada, cria-se uma linha verde
  //abaixo de 'Borracha'.
  if (key =='0') {
    stroke(0, 255, 0);
    strokeWeight(3);
    line(270, 27, 337, 27);
  }

  //Quando a tecla 1 é pressionada, cria-se uma linha verde
  //abaixo de 'Círculo'.
  if (key =='1') {
    stroke(0, 255, 0);
    strokeWeight(3);
    line(345, 27, 398, 27);
  }

  //Quando a tecla 2 é pressionada,cria-se uma linha verde
  //abaixo de 'Quadrado'.
  if (key =='2') {
    stroke(0, 255, 0);
    strokeWeight(3);
    line(410, 27, 480, 27);
  }

  //Quando a tecla 3 é pressionada, cria-se uma linha verde
  //abaixo de 'Linha'.
  if (key =='3') {
    stroke(0, 255, 0);
    strokeWeight(3);
    line(487, 27, 535, 27);
  }

  //Quando a tecla 4 é pressionada, cria-se uma linha verde
  //abaixo de 'Spray'.
  if (key =='4') {
    stroke(0, 255, 0);
    strokeWeight(3);
    line(540, 27, 588, 27);
  }

  //Quando a tecla 'R' é pressionada, aumenta o valor do vermelho
  //em 15, tendo um limite de 255.
  if (key == 'r' || key == 'R') {
    if (vermelho <= 240) {
      vermelho+=15;
    }
  }
  //Quando a tecla 'E' é pressionada, diminui o valor do vermelho
  //em 15, tendo um limite de 0.
  if (key == 'e' || key == 'E') {
    if (vermelho >= 15) {
      vermelho-=15;
    }
  }

  //Quando a tecla 'G' é pressionada, aumenta o valor do verde
  //em 15, tendo um limite de 255.
  if (key == 'g' || key == 'G') {
    if (verde <= 240) {
      verde+=15;
    }
  }

  //Quando a tecla 'F' é pressionada, diminui o valor do verde
  //em 15, tendo um limite de 0.
  if (key == 'f' || key == 'F') {
    if (verde >= 15) {
      verde-=15;
    }
  }

  //Quando a tecla 'B' é pressionada, aumenta o valor do azul
  //em 15, tendo um limite de 255.
  if (key == 'b' || key == 'B') {
    if (azul <= 240) {
      azul+=15;
    }
  }

  //Quando a tecla 'V' é pressionada, diminui o valor do azul
  //em 15, tendo um limite de 0.
  if (key == 'v' || key == 'V') {
    if (azul >= 15) {
      azul-=15;
    }
  }

  //Quando a tecla '+' ou '=' é pressionada, aumenta o valor do
  //tamanho em 10, tendo um limite de tamanho de 200.
  if (key == '=' || key == '+') {
    if (tamanho < 200) {
      tamanho += 10;
    }
  }

  //Quando a tecla '-' ou '_' é pressionada, diminui o valor do
  //tamanho em 10, tendo um limite de tamanho de 10.
  if (key == '-' || key == '_') {
    if (tamanho > 10) {
      tamanho -= 10;
    }
  }
}
