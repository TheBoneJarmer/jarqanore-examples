package be.labruyere.examples;

import be.labruyere.arqanore.Window;
import be.labruyere.arqanore.Keyboard;
import be.labruyere.arqanore.enums.Keys;

public class App {
    private static Window window;
    
    private static void onOpen() {
        System.out.println("Window opened");    
    }
    
    private static void onClose() {
        System.out.println("Window closed");
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
