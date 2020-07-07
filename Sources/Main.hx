package;

import kha.Assets;
import kha.System;

class Main {
	static final SCREEN_W: Int = 800;
	static final SCREEN_H: Int = 600;

	static var bench: Bench;

	public static function main(): Void {
		System.start({title: "Parrot Mark", width: SCREEN_W, height: SCREEN_H}, (_) -> {
			Assets.fonts.mainfontLoad(() -> {
				bench = new parrots.Parrots();
				//bench = new multiparrots.MultiParrots();
			});
		});
	}
}
