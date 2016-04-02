<?php

namespace Base;

class App {
    
    private static $slim;

    public static function instance() {

        if (self::$slim === null) {

            $configuration = [
                'settings' => [
                    'displayErrorDetails' => true,
                ],
            ];

            $c = new \Slim\Container($configuration);
            
            $app = new \Slim\App($c);

            $container = $app->getContainer();

            $container['view'] = function ($c) {
                $view = new \Slim\Views\Twig(
                    DOCROOT . 'app/views', 
                    [
                        //'cache' => DOCROOT . 'app/cache'
                    ]
                );

                $view->addExtension(new \Slim\Views\TwigExtension(
                    $c['router'],
                    $c['request']->getUri()
                ));

                return $view;
            };

            $container['flash'] = function () {
                return new \Slim\Flash\Messages();
            };

            self::$slim = $app;

        }

        return self::$slim;
    }

}