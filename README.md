# BBBLogger

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub release](https://img.shields.io/github/release/takayoshiotake/BBBLogger.svg)](https://github.com/takayoshiotake/BBBLogger/releases)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Platforms](http://img.shields.io/badge/platforms-macOS-lightgrey.svg?style=flat)
![Swift 3.0.x](http://img.shields.io/badge/Swift-3.0.x-orange.svg?style=flat)

**BBBLogger** provides simple logging API.

You can change log output, see `setup(logOutput:)` and `BBBLogOutput` protocol for more information.

Default log output is `BBBDefaultLogOutput` writes into the standard output.


## Usage

``` swift
BBBLog(.verbose, "Hello, world!")
```
