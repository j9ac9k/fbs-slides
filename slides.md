---
author: Ogi Moore
title: Packaging a python GUI Application
date: December 28, 2019
---

## Who Am I

Ogi Moore

@ogimoore

github.com/j9ac9k

Technologist @ Sensory

# What are we talking about?

How can we distribute our python GUI applications to a widespread audience...

---

## Difference between a library and an application

my own definitions, and I am not an authority on this matter...

. . .

"library" is meant to be used by other developers

  * numpy, requests, etc..

. . .

"application" is meant to be used by end-users

  * youtube-dl, spyder, qutebrowser...

---

## Libraries should be packaged for developers

1. Create python wheel with setuptools (or flit)
2. Upload to pypi, and then anyone can install via pip

```
pip install <library>
```

---

## Applications need to be distributed differently

::: incremental

* users may or may not have python installed
* users may not feel comfortable interacting with the command line

:::

---

# How do we make a cross-platform GUI application?

. . .

Qt! (pronunced "cute")

- cross-platform framework to create modern and native looking GUIs
- C++ framework with python bindings available (pyside2, pyqt5)
  - best to abstract differences away by using `qtpy` library
- it's a _huge_ framework
  - offers a lot more than just GUI elements

---

## Screenshot

<img class="plain"  src="./images/fred.png"/>

<!-- ![Fred Screenshot](./images/fred.png "") -->

---

# How to deploy GUI applications?

- make it into a wheel and upload to pypi? 
  - Sure, but end users may not have python installed
  - End users may not know how to install python... [xkcd reference]
  - it's not a library, end-users may not be developers comfortable working from the command line

. . .

- can we create a "native" installer like any other application we install on our machines?

---

## Sure we can!

. . .

but it's tricky....

---

## The fbs library

* with fbs, we can create native installers (screenshot of windows installer, linux installer, macOS dmg)
* have executables to run to start without command line usage
* has awesome `fbs startproject` command to create a bare minimum example that you can incorporate/modify for your project

---

## fbs does have requirements...

::: incremental

* needs to be a PyQt5/PySide2 application
* right directory structure
* build.json
* requirements/base.txt
  * in my CI process I just run

     ```cp requirements.txt requirements/base.txt``` 

* docs are _very_ good, source code is easy to read too...

:::

---

## How to use fbs?

. . .

- `fbs freeze` - Converts your python package into a stand-alone executable (via pyinstaller)

. . .

- `fbs installer` - Bundles your executable into a single file installer 
  - AppSetup.exe for Windows (using `NSIS`)
  - App.dmg for macOS (using `create-dmg`)
  - App.deb for Ubuntu/Debian (using `fpm`)

---

## More considerations

- windows installers can only be created on windows machines
  - same with macOS and linux 
- ubuntu needs a `fpm` to make the .deb packages
- windows needs `pypiwin32`, windows10 SDK, Visual C++ redistributables
- really annoying to setup a bunch of VMs and do manually

---

## Runs from source != executable will run

- pyinstaller is used when creating the executables
- it may not grab one of your dependencies and you get a runtime error when trying to launch teh application
  - this happened with numpy 1.17.0
  - scipy 1.3.1 → 1.3.2+ on Windows
  - many other instances too...
- suggest you test your executable before bundling into the installer

::: notes

pin your dependency versions so you can go in your git history and evaluate what dependency update broke things

:::

---

## Testing the Executable
- Start the application wait 10 seconds, kill it by name
  - If you get an error when killing the application, it means it didn't start successfully, and you need to investigate more
  - If it kills without an error code, it means you application was running :thumbsup:
  - trickier on windows, need to make into non-windowed executable first, test, then make into windowed executable

--- 

## Commmands to test executables

Linux:

```bash
target/App/App & sleep 10 ; kill $!
```

macOS:

```bash
(target/App.app/Contents/MacOS/App) & sleep 10 ; kill $!
```

Windows:

```cmd
start target\App\App.exe & waitfor timeVoid /t 10 2>NUL & taskkill /im App.exe /f
```

---

## CI to the rescue
- Following services offer free cross-platform CI services (for open-source projects)
  - azure pipelines
  - travis
  - github actions
- make installers artifcats, so you can download/distribute them
- [show screenshot of gitlab pipeline]


# Demo Fred

# Bonus - Codesigning
- codesign your application to skip warnings
  - isn't free...

# Wrap up

::: incremental

- Qt framework is amazing, if you need to make a GUI application, and want to use python, it is an amazing way to go
- fbs can turn your GUI application into an installable application by leveraging pyinstaller and other dependencies
- process is _very_ fragile, care must be taken to ensure your application was bundled successfully
- pin your runtime dependencies
- use a CI service, this is really a pain to do manually

:::

# Future Work
- Create a cookie cutter template that generates the right directory strcture and does simple CI configs from the get go