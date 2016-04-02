<?php

namespace Routes;

use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;

class Categories {
    public function init(\Slim\App $app) {

        $app->group('/categories', function() {

            $this->get('','\Controllers\Categories:index');

            $this->map(['GET', 'POST'], '/created','\Controllers\Categories:created');

            $this->map(['GET', 'POST'], '/edit/{id}','\Controllers\Categories:edit');

            $this->map(['GET', 'POST'], '/delete/{id}','\Controllers\Categories:delete');

        });
    }
}