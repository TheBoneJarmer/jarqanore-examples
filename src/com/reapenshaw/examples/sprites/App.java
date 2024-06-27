package com.reapenshaw.examples.sprites;

import be.labruyere.arqanore.Window;
import be.labruyere.arqanore.Keyboard;
import be.labruyere.arqanore.Sprite;
import be.labruyere.arqanore.Renderer;
import be.labruyere.arqanore.Vector2;
import be.labruyere.arqanore.Color;
import be.labruyere.arqanore.enums.Keys;

public class App {
    private static Window window;
    private static Sprite sprite;
    
    private static void onOpen() {
        try {
            sprite = new Sprite("assets/player.png", 16, 16);
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
    }
    
    private static void onClose() {
        sprite.delete();
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
            var scale = new Vector2(4, 4);
            var origin = new Vector2(0, 0);
        
            Renderer.renderSprite(window, sprite, position, scale, origin, 0, 0, 0, false, false, Color.WHITE);
        } catch (Exception e) {
            e.printStackTrace();
            window.close();
        }
    }

    public static void main(String[] args) {
        var fqn = "com/reapenshaw/examples/sprites/App";
    
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
