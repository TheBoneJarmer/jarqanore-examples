package be.labruyere.examples;

import be.labruyere.arqanore.Window;
import be.labruyere.arqanore.Keyboard;
import be.labruyere.arqanore.Font;
import be.labruyere.arqanore.Renderer;
import be.labruyere.arqanore.Vector2;
import be.labruyere.arqanore.Color;
import be.labruyere.arqanore.enums.Keys;

public class App {
    private static Window window;
    private static Font font;
    
    private static void onOpen() {
        try {
            font = new Font("assets/default.ttf", 16, 16);
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
    }
    
    private static void onClose() {
        font.delete();
    }
    
    private static void onUpdate(double at) {
        try {
            if (Keyboard.keyPressed(Keys.ESCAPE)) {
                window.close();
            }  
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
    }
    
    private static void onRender2D() {
        try {
            var position = new Vector2(32, 32);
            var scale = new Vector2(1, 1);
        
            Renderer.renderText(window, font, "This is an example piece of text!", position, scale, Color.WHITE);
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
    }

    public static void main(String[] args) {
        var fqn = "be/labruyere/examples/App";
    
        try {
            window = new Window(1440, 786, "JArqanore Example");
            window.onOpen(fqn, "onOpen");
            window.onClose(fqn, "onClose");
            window.onUpdate(fqn, "onUpdate");
            window.onRender2D(fqn, "onRender2D");
            window.open(false, true, true);
            window.delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
