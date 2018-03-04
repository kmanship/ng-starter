#!/usr/bin/env bash

# Install Angular with Bootstrap pre-configured

# Pre-requisites
ng -v >/dev/null 2>&1 || {
	echo >&2 "Angular CLI is not installed. Installing..."

	npm -v >/dev/null 2>&1 || {
		echo >&2 "NPM is required and is not installed. Installing..."

		brew -v >/dev/null 2>&1 || {
			echo >&2 "Homebrew is not installed. Exiting."
			exit 1
		}

		brew update
		brew install node
	}

	npm install -g @angular/cli
}

# number of input arguments passed in
if [ $# -eq 0 ]
  then
    echo "Application name must be specified."
    echo "e.g. './ng-starter.sh my-app'"
    exit 1
fi

# check if argument is an empty string or not 
if [ -z "$1" ]
  then
    echo "Empty string is not permitted. Application name must be specified."
    echo "e.g. './ng-starter.sh my-app'"
    exit 1
fi

# First argument should be application name
APP_NAME=$1

# Create project
ng new --style scss --routing true --prefix app $APP_NAME

cd $APP_NAME

# Using SASS - create _variables.scss file
cat <<EOF >src/_variables.scss
/* see https://github.com/twbs/bootstrap/blob/v4-dev/scss/_variables.scss for all variables */

EOF

# Install Bootstrap (4.0.0)
npm install --save jquery popper.js bootstrap

# Add Bootstrap styles to styles.scss
cat <<EOF >>src/styles.scss

/* Bootstrap - https://getbootstrap.com */
/* Specify variables in '/src/_variables.scss' */
@import 'variables';
@import '../node_modules/bootstrap/scss/bootstrap';

EOF

# Angular Material - Install
npm install --save @angular/material @angular/cdk
npm install --save @angular/animations

# Moment - Date Adapter
npm install --save moment
npm install --save @angular/material-moment-adapter

# Angular Material - Add to styles.scss
cat <<EOF >>src/styles.scss
/* Angular Material - https://material.angular.io */
/* Available pre-built themes: deeppurple-amber.css; indigo-pink.css; pink-bluegrey.css; purple-green.css */
@import '~@angular/material/prebuilt-themes/deeppurple-amber.css';
@import url('https://fonts.googleapis.com/icon?family=Material+Icons');

EOF

# Add JavaScript files
sed -i.bak 's/"scripts": \[\]/"scripts": \[\
\ \ \ \ \ \ \ \ \"..\/node_modules\/jquery\/dist\/jquery.slim.min.js",\
\ \ \ \ \ \ \ \ \"..\/node_modules\/bootstrap\/dist\/js\/bootstrap.min.js"\
\ \ \ \ \ \ \]/' .angular-cli.json

# Add locale and aot when starting server
sed -i.bak 's/"ng serve"/"ng serve --aot --locale en-au"/' package.json

# Add app.module template
cp ../app.module.base  ./src/app/app.module.ts