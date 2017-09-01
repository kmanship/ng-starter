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

# Install Bootstrap (4.0.0-beta)
npm install --save bootstrap@next
npm install --save jquery
npm install --save popper.js

# Add Bootstrap styles to styles.scss
cat <<EOF >>src/styles.scss

/* Bootstrap - https://getbootstrap.com */
/* Specify variables in '/src/_variables.scss' */
@import 'variables';
@import '../node_modules/bootstrap/scss/bootstrap';

EOF

# Angular Material - Install
npm install --save @angular/material
npm install --save @angular/animations

# Angular Material - Add to styles.scss
cat <<EOF >>src/styles.scss
/* Angular Material - https://material.angular.io */
/* Available pre-built themes: deeppurple-amber.css; indigo-pink.css; pink-bluegrey.css; purple-green.css */
@import '~@angular/material/prebuilt-themes/deeppurple-amber.css';
@import url('https://fonts.googleapis.com/icon?family=Material+Icons');

EOF


# Toastr - Install 
npm install --save toastr

# Toastr - Add to styles.scss
cat <<EOF >>src/styles.scss
/* Toastr - https://github.com/CodeSeven/toastr */
@import '../node_modules/toastr/toastr';

EOF


# Font Awesome - Install 
# npm install --save font-awesome

# Font Awesome. - Add to _variables.scss
#cat <<EOF >>src/_variables.scss
#\$fa-font-path : '../node_modules/font-awesome/fonts';

#EOF

# Font Awesome - Add to styles.scss
#cat <<EOF >>src/styles.scss
#/* Font Awesome - http://fontawesome.io */
#@import '../node_modules/font-awesome/scss/font-awesome';

#EOF

# Add JavaScript files
sed -i.bak 's/"scripts": \[\]/"scripts": \[\
\ \ \ \ \ \ \ \ \"..\/node_modules\/jquery\/dist\/jquery.slim.min.js",\
\ \ \ \ \ \ \ \ \"..\/node_modules\/popper.js\/dist\/umd\/popper.min.js",\
\ \ \ \ \ \ \ \ \"..\/node_modules\/bootstrap\/dist\/js\/bootstrap.min.js",\
\ \ \ \ \ \ \ \ \"..\/node_modules\/toastr\/build\/toastr.min.js"\
\ \ \ \ \ \ \]/' .angular-cli.json
