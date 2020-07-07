package parrots;

import kha.Window;
import kha.Assets;
import kha.Font;
import kha.Framebuffer;
import kha.Image;
import kha.Scheduler;
import kha.System;
import kha.input.Mouse;

class Parrots implements Bench {
	var parrotTex: Image;
	var font: Font;

	var bCount: Int = 0;
	var parrots: Array<Parrot>;
	var gravity: Float = 0.5;
	var maxX: Int;
	var maxY: Int;
	var minX: Int;
	var minY: Int;

	var backgroundColor: Int = 0xFF2A3347;
	var deltaTime: Float = 0.0;
	var totalFrames: Int = 0;
	var elapsedTime: Float = 0.0;
	var previousTime: Float = 0.0;
	var fps: Int = 0;

	function mouseDown(button: Int, x: Int, y: Int): Void {
		final count:Int = button == 0 ? 10000 : 1000;
		for (i in 0...count) {
			final parrot = new Parrot();
			parrot.speedX = Math.random() * 5;
			parrot.speedY = Math.random() * 5 - 2.5;
			parrots.push(parrot);
		}
		bCount = parrots.length;
	}

	function update(): Void {
		for (i in 0...parrots.length) {
			final parrot = parrots[i];

			parrot.x += parrot.speedX;
			parrot.y += parrot.speedY;
			parrot.speedY += gravity;

			if (parrot.x > maxX) {
				parrot.speedX *= -1;
				parrot.x = maxX;
			}
			else if (parrot.x < minX) {
				parrot.speedX *= -1;
				parrot.x = minX;
			}

			if (parrot.y > maxY) {
				parrot.speedY *= -0.8;
				parrot.y = maxY;
				if (Math.random() > 0.5) {
					parrot.speedY -= 3 + Math.random() * 4;
				}
			}
			else if (parrot.y < minY) {
				parrot.speedY = 0;
				parrot.y = minY;
			}
		}
	}

	function render(frames: Array<Framebuffer>): Void {
		var framebuffer = frames[0];

		var currentTime: Float = Scheduler.realTime();
		deltaTime = (currentTime - previousTime);

		elapsedTime += deltaTime;
		if (elapsedTime >= 1.0) {
			fps = totalFrames;
			totalFrames = 0;
			elapsedTime = 0;
		}
		totalFrames++;

		framebuffer.g2.begin(true, backgroundColor);
		framebuffer.g2.color = 0xFFFFFFFF;
		for (parrot in parrots){
			framebuffer.g2.drawImage(parrotTex, parrot.x, parrot.y);
		}

		framebuffer.g2.font = font;
		framebuffer.g2.fontSize = 16;
		framebuffer.g2.color = 0xFF000000;
		framebuffer.g2.fillRect(0, 0, Window.get(0).width, 20);
		framebuffer.g2.color = 0xFFFFFFFF;
		framebuffer.g2.drawString("Parrots: " + bCount + "         FPS: " + fps, 10, 2);
		framebuffer.g2.end();

		previousTime = currentTime;
	}

	public function new() {
		Assets.loadImage("small_parrot", (image) -> {
			font = Assets.fonts.mainfont;
			parrotTex = Assets.images.small_parrot;

			parrots = new Array<Parrot>();
			minX = 0;
			maxX = Window.get(0).width - parrotTex.width;
			minY = 0;
			maxY = Window.get(0).height - parrotTex.height;

			Mouse.get().notify(mouseDown, null, null, null);
			Scheduler.addTimeTask(update, 0, 1 / 60);
			System.notifyOnFrames(render);
		});
	}
}
