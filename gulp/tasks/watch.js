var gulp   = require('gulp');
var config = require('../config');

gulp.task('watch', function(){

  gulp.watch(config.coffeescripts.src, ['coffeescripts']);
  gulp.watch(config.stylus.src, ['stylus']);
  gulp.watch(config.jade.src, ['jade']);

});
