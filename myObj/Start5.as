package myObj {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextDisplayMode;
	
	public class Start5 extends MovieClip {
		
 		private var temp:Number = 0;
		private var angle:Boolean;
		private var nextTempL:Number = 0;
		private var nextTempP:Number = 0;
		private var speed:int = 10;
		//dodalam 4 zmienne do przechwycenia użycia klawisza:
		private var holdW:Boolean;
		private var holdS:Boolean;
		private var holdU:Boolean;
		private var holdD:Boolean;
		//dodałam dwie zmienne, ktore przechwytują czy piłka była odbita lewą czy prawą paletką 
		//potrzebne do wykrycia kolizji z belkami
		private var pongTestL:Boolean;
		private var pongTestR:Boolean;
		//private var gem:Boolean;
		
		public function Start5(): void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, ActionPong);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, PosiotionsBall);
			//poniżej dodany element nasłuchujący zwolnienie klawisza:
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReset);
			stage.addEventListener(Event.ENTER_FRAME, BallAnim);
			ball.addEventListener(Event.ENTER_FRAME, BallDetect);
			ball.addEventListener(Event.ENTER_FRAME, NextStart);
			belka_up.addEventListener(Event.ENTER_FRAME, Reflection);
			belka_down.addEventListener(Event.ENTER_FRAME, Reflection);
		}
		private function ActionPong(event:KeyboardEvent): void {
			//"przechwycenie użycia klawisza"
			if (event.keyCode == 38) { 
				holdU = true;
			}
			if (event.keyCode == 40) { 
				holdD = true;
			}
			if (event.keyCode == 87) {
				holdW = true;
			}
			if (event.keyCode == 83) { 
				holdS = true;
			}
				
			//lewa paletka - ruch	
			if (holdU==true){
				if (pong_left.y > 0) {
					pong_left.y -= speed;
					}
				}
			if (holdD==true){
				if (pong_left.y < (stage.stageHeight - pong_left.height)){
					pong_left.y += speed;
					}
				}
			//prawa paletka - ruch	
			if (holdW == true) { 
				if (pong_right.y > 0){
					pong_right.y -= speed;
					}
				}
			if (holdS == true) { 
				if (pong_right.y < (stage.stageHeight - pong_right.height)){
					pong_right.y += speed;
					}
				}
			}
			
		// dodana funkcja resetuje ustawienie klawiszy:
		private function keyReset(event:KeyboardEvent) {
				
      		switch(event.keyCode) {
        		case 38:
          			holdU = false;
          			break;
        		case 40:
          			holdD = false;
          			break;
        		case 87:
          			holdW = false;
          			break;
        		case 83:
          			holdS = false;
          			break;
      				}
			}
			
			//pilka wraca na pozycje startu lub startuje, znika ekran powitalny.
			private function PosiotionsBall(event:KeyboardEvent) {
				if (event.keyCode == 32) { 
					ball.x = 275; 
					ball.y = 200;
					ball.alpha = 1;
					FRAME1.alpha = 0;
					EndText.text = "";
					temp = Math.floor(Math.random()*2);
					if (((nextTempL / 4) == 10) || ((nextTempP / 4) == 10)) {
						EndText.text = "";
						nextTempP = 0;
						nextTempL = 0;
						right_text.text = String(nextTempP);
						left_text.text = String(nextTempL);
					}
				}
			}
			//wykrywanie kolizji piłki i paletek
			//zmienia odpowiadają za rotację 45
			private function BallDetect(event:Event) {
				if (ball.hitTestObject(pong_right.pong_right_up) == true) {
					//trace('trafiony');
					temp -= 1;
					angle = true;
					pongTestR = true; //ustawiamy wartość zmiennej dla poprawnej detekcji kolizji z belkami górną i dolną
				}
				if (ball.hitTestObject(pong_right.pong_right_down) == true) {
					//trace('trafiony');
					temp -= 1;
					angle = false;
					pongTestR = true; //ustawiamy wartość zmiennej dla poprawnej detekcji kolizji z belkami górną i dolną
				}
				if (ball.hitTestObject(pong_left.pong_left_up) == true) {
					//trace('trafiony');
					temp += 1;
					angle = true;
					pongTestL = true; //ustawiamy wartość zmiennej dla poprawnej detekcji kolizji z belkami górną i dolną
				}
				if (ball.hitTestObject(pong_left.pong_left_down) == true) {
					temp += 1;
					angle = false;
					pongTestL = true; //ustawiamy wartość zmiennej dla poprawnej detekcji kolizji z belkami górną i dolną
				} else {
					//trace('pudlo');
				}
			}
			//wykrywanie kolizji w przypadku zderzenia z krawędzią pola gry
			private function Reflection(event:Event) { 
					if (ball.hitTestObject(belka_up) == true) {
						//trace('belka górna');
						if (pongTestL==true){
							temp = 1;
							angle = false;
							pongTestL=false;
						}
						if (pongTestR==true){
							temp = -1;
							angle = false;
							pongTestR=false;
						}
					}
					if (ball.hitTestObject(belka_down) == true) {
						if (pongTestL==true){
							temp = 1;
							angle = true;
							pongTestL=false;
						}
						if (pongTestR==true){
							temp = -1;
							angle = true;
							pongTestR=false;
						}
					}
				}
			//kierowanie ruchem piłki - w lewo i prawo, oraz rotacja
			private function BallAnim(event:Event): void {
				trace(temp);trace(angle);
					if (temp > 0) {
							if (angle == false) {
								ball.x += 7;
								ball.y += 4;
							}
							
							if (angle == true) {
								ball.x += 7;
								ball.y -= 4;
							}
						}
					
					if (temp <= 0) {
							if (angle == false) {
								ball.x -= 7;
								ball.y += 4;
									
							}
							if (angle == true) {
								ball.x -= 7;
								ball.y -= 4;
							}
						}
				}
			//kolizja z niewidocznym obiektem, naliczanie punktów graczy
			private function NextStart(event:Event) { 
				if (ball.hitTestObject(pl) == true) {
					++ nextTempL;
					trace(nextTempL);
					left_text.text = String(Math.floor(nextTempL / 4));
				}
				if (ball.hitTestObject(pr) == true) {
					++ nextTempP;
					trace(nextTempP);
					right_text.text = String(Math.floor(nextTempP / 4));
				}
				if (Math.floor(nextTempP / 4) == 10) {
					EndText.text = "WINS PLAYER 1";
					right_text.text = "10";
				}
				if (Math.floor(nextTempL / 4) == 10) {
					EndText.text = "WINS PLAYER 2";
					left_text.text = "10";
				}
			}
			
	}
}
