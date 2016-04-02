<?php

namespace Routes;

class Products {
    public function init(\Slim\App $app) {

        $app->group('/products', function() {

            $this->get('','\Controllers\Products:index');

            $this->map(['GET', 'POST'], '/created','\Controllers\Products:created');

            $this->map(['GET', 'POST'], '/edit/{id}','\Controllers\Products:edit');

            $this->map(['GET', 'POST'], '/delete/{id}','\Controllers\Products:delete');

        });
    }
}