<?php

namespace Routes;

class Api
{
    public function init(\Slim\App $app)
    {
        $app->group('/api', function() {

            $this->get('/get-catalog','\Controllers\Api:getCatalog');
            
        });
    }
}