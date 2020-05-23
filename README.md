# flutterweb_yaml

A command-line application to generate CI/CD yaml templates for Flutter web project.

## Installation

You can install it using pub :

```bash
pub global activate flutterweb_yaml
```

To update flutterweb_yaml, use the same command.

## Usage

flutterweb_yaml generates the YAML file you need to build and deploy your Flutter app (or package example on the web).

```bash
flutterweb_yaml generate
```

This will generate the YAML file for your Flutter app.

If you want to show off your example app for your Flutter package : (assuming your app is in a folder named `example`)

```bash
flutterweb_yaml generate --package
```

Or if your app folder has a custom path within your repository :

```bash
flutterweb_yaml generate --path ./path_to_my_app
```

_Note : For now the only available provider is GitHub, so you don't have to specify the provider in parameters._
