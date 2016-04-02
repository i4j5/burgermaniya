<?php
namespace Controllers;

use \Base\Controller,
    \Model,
    Gregwar\Image\Image;

/**
 * Контроллер APi 
 */
class Api extends Controller {
    
    /**
     * Получаем каталог
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function getCatalog($request, $response) {
       
        $categories = Model::factory('Models\Category')->find_many();
        $products = Model::factory('Models\Product')->find_many();

        $data = [];

        $url = 'http://' . $_SERVER['HTTP_HOST'];

        $data['about'] = 'О нас ...';

        $data['categories'] = [];
        foreach ($categories as $categoryt) {
            $arr = []; 
            $arr['img'] = null;
            if ($categoryt->image) {
                $arr['img'] = $url . '/_/' . $categoryt->image;
            }
            $arr['id'] = $categoryt->id;
            $arr['title'] = $categoryt->title;
            $data['categories'][] = $arr;
        }

        $data['products'] = [];
        foreach ($products as $product) {
            $arr = []; 
            $arr['img'] = null;
            if ($product->image) {
                $arr['img'] = $url . '/_/' . $product->image;
            }
            $arr['id'] = $product->id;
            $arr['title'] = $product->title;
            $arr['description'] = $product->description;
            $arr['price'] = (int) $product->price;
            $arr['categoryID'] = $product->category_id;

            $data['products'][] = $arr;
        }

        $response->withHeader('Content-type', 'application/json');
        // $response->withHeader('Access-Control-Allow-Origin', '*');
        header('Access-Control-Allow-Origin: *');
        return $response->write( json_encode($data) );
    }

}