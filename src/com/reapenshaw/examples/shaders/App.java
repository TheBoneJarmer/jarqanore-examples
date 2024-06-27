package com.reapenshaw.examples.shaders;

import be.labruyere.arqanore.*;
import be.labruyere.arqanore.enums.Keys;
import be.labruyere.arqanore.enums.ShaderTarget;
import be.labruyere.arqanore.enums.ShaderType;
import be.labruyere.arqanore.exceptions.ArqanoreException;

public class App {
    private static Window window;
    private static Sprite sprite;
    private static Shader shader;

    private static void onOpen() {
        try {
            shader = new Shader();
            shader.addSource("assets/sprity_v.glsl", ShaderType.VERTEX);
            shader.addSource("assets/sprity_f.glsl", ShaderType.FRAGMENT);
            shader.compile();

            sprite = new Sprite("assets/player.png", 16, 16);
        } catch (ArqanoreException e) {
            e.printStackTrace();
            window.close();
        }
    }

    private static void onClose() {
        shader.delete();
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
            Renderer.setShader(shader, ShaderTarget.SPRITE);
            Renderer.renderSprite(window, sprite, 32, 32, 4, 4, 0, 0, 0, 0, 0, false, false, 255, 255, 255, 255);
        } catch (ArqanoreException e) {
            e.printStackTrace();
            window.close();
        }
    }

    public static void main(String[] args) {
        var fqn = "com/reapenshaw/examples/shaders/App";

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
