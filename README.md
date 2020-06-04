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

Always run the command from the root of the project.

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

To know more about the GitHub Actions workflow, checkout this [article](https://medium.com/@mattisbrizard/expose-your-flutter-applications-using-github-actions-and-github-pages-e0050101b900).

## Contribution

If you want to add a new provider, you can make a [pull request](https://github.com/MattisBrizard/flutterweb_yaml/pulls).

If you find a bug, please fill an [issue](https://github.com/MattisBrizard/flutterweb_yaml/issues).
