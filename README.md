# JArqanore Examples
This repo contains example applications build with JArqanore. This repo also serves as a way to debug JArqanore since the repo from JArqanore is focussed on the library only.

## Building
I added a PowerShell script called `build.ps1`. It works both on Linux and Windows. I highly recommend using it. It expects the lib folder to contain the right version of `jarqanore.jar` as well as the `.dll` or `.so` files. You can get those from the [JArqanore](https://github.com/thebonejarmer/jarqanore) repo and the [Arqanore](https://github.com/thebonejarmer/arqanore) repo respectively.

## Running
In order to run one of the examples in the out folder you need to execute the following commands from a terminal or PowerShell window.

```
cd out
java -Djava.library.path=lib/ -jar ./example-window.jar
```