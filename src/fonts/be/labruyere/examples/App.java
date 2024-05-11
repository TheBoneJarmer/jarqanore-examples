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
    private static String text;
    
    private static void onOpen() {
        try {
            font = new Font("assets/default.ttf", 16, 16);
            text = "This is an éxàmple piëce öf text containing UTF-16 ©hara©ters!";
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
        
        System.out.println(text.length());
        System.out.println();
        
        var width = font.measure(text, 1);
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
        
            Renderer.renderText(window, font, text, position, scale, Color.WHITE);
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
