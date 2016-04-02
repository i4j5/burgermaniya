<?php

$loader = require_once  DOCROOT . 'vendor/autoload.php';
$loader->add('', DOCROOT . 'app/src');

setlocale(LC_TIME, 'Russian');

session_start();

ORM::configure('sqlite:' . DOCROOT . 'app/db.db');

$app = \Base\App::instance();

foreach ( glob(DOCROOT . 'app/src/Routes/*.php') as $path ) {
    $class = str_replace([
			DOCROOT . 'app/src',
			'.php',
			'/'
    ], [
			'',
			'',
			'\\'
    ], $path);

    (new $class)->init($app);
}

$app->run();