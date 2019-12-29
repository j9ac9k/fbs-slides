---
author: Ogi Moore
title: Packaging a python GUI Application
date: December 28, 2019
---

## Who I Am...

Ogi Moore

@ogimoore

github.com/j9ac9k

Technologist at Sensory Inc.

:::

## What are we talking about?

How can we distribute our python GUI applications to a widespread audience...

:::

## Difference between a library and an application

* "library" is meant to be used by other developers
  * numpy, requests, etc..

::: incremental

* "application" is meant to be used by end-users
  * youtube-dl, spyder, qutebrowser...

:::

## Libraries should be packaged for developers

Many ways to go about it
- setuptools, flit, conda-build are all tools used to do this...
- upload to pypi, and then anyone can `pip install <your-library>`

:::

## Applications need to be distributed differently

::: incremental

* users may or may not have python installed

::: incremental

* users may not feel comfortable interacting with the command line

:::

## Slide Detour

What is Qt?

::: incremental

- cross-platform framework to create GUIs
- C++ library with python bindings available (pyside2, pyqt5)
  - best to abstract differences away by using qtpy library
- it's a _huge_ framework
  - offers a lot more than just GUI elements
- [screenshot of Fred]

:::

## How to deploy GUI applications?

- make it into a wheel and upload to pypi? 
  - Sure, but end users may not have python installed
  - End users may not know how to install python... [xkcd reference]
  - it's not a library, end-users may not be developers comfortable working from the command line

::: incremental

- can we create a "native" installer like any other application we install on our machines?

:::

## Sure we can!

but it's tricky....

:::

## The fbs library

* with fbs, we can create native installers (screenshot of windows installer, linux installer, macOS dmg)
* have executables to run to start without command line usage
* has awesome `fbs startproject` command to create a bare minimum example that you can incorporate/modify for your project

:::

## fbs does make requirements of us...

* needs to be a PyQt/PySide2 application
* right directory structure
* build.json
* requirements/base.txt
  * I just run `cp requirements.txt requirements/base.txt` in my CI process
* docs are _very_ good, source code is easy to read too...

:::

## How to use fbs?

- `fbs freeze`
  - Converts your python package into a stand-alone executable

  ::: incremental

- `fbs installer`
  - Bundles your executable into a single file installer (setup.exe, App.dmg, App.deb)

:::

## More considerations

- windows installers can only be created on windows machines
  - same with macOS and linux 
- ubuntu needs a [dependency] to make the .deb packages
- windows needs pypiwin32, windows10 SDK, visual c++ redistributables
- really annoying to setup a bunch of VMs and do manually

:::

## Runs from source != executable will run

- pyinstaller is used when creating the executables
- pin your dependency versions so you can go in your git history and evaluate what dependency update broke things
- it may not grab one of your dependencies and you get a runtime error when trying to launch teh application
  - this happened with numpy 1.17.0
  - scipy 1.3.1 -> 1.3.2+ on Windows
  - many other instances too...
- suggest you test your executable before bundling into the installer

:::

## Testing the Executable
- Start the application wait 10 seconds, kill it by name
  - If you get an error when killing the application, it means it didn't start successfully, and you need to investigate more
  - If it kills without an error code, it means you application was running :thumbsup:
  - trickier on windows, need to make into non-windowed executable first, test, then make into windowed executable
  - [show commands]

## CI to the rescue
- Following services offer (free) cross-platform CI services (for open-source projects)
  - azure pipelines
  - travis
  - github actions
- make installers artifcats, so you can download/distribute them
- [show screenshot of gitlab pipeline]

:::

## Demo Fred

:::

## Bonus - Codesigning
- codesign your application to skip warnings
  - isn't free...

:::

## Wrap up
- Qt framework is amazing, if you need to make a GUI application, and want to use python, it is an amazing way to go
- fbs can turn your GUI application into an installable application by leveraging pyinstaller and other dependencies
- process is _very_ fragile, care must be taken to ensure your application was bundled successfully
- pin your runtime dependencies
- use a CI service, this is really a pain to do manually

:::

## Future Work
- Create a cookie cutter template that generates the right directory strcture and does simple CI configs from the get go