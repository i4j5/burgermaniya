var gulp   = require('gulp');
var usemin = require('gulp-usemin');

var minifyCSS = require('gulp-minify-css');
var minifyHtml = require('gulp-minify-html');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');

var handleError = require('../utils/handleErrors');
var config = require('../config').usemin;

gulp.task('usemin', function(){
 
	return gulp
		.src(config.src)
    .pipe(usemin({
      css: [
        minifyCSS({
          compatibility: 'ie8'
        }),
        'concat'
      ],

      html: [
        function () {
          return minifyHtml({ empty: true });
        }
      ],

      js: [uglify()]
    }))
    .on('error', handleError)
    .pipe( gulp.dest(config.dest) );

});