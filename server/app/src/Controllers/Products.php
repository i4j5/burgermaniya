<?php

namespace Controllers;

use \Base\Controller,
    \Model,
    Gregwar\Image\Image;

/**
 * Контроллер продуктов 
 */
class Products extends Controller{

    /**
     * Ширина изображения 
     * @var integer
     */
    private $image_width = 300;

    /**
     * Высота изображения
     * @var integer
     */
    private $image_height = 300;

    /**
     * Все продукты
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function index($request, $response) {
       
        $products = Model::factory('Models\Product')->find_many();

        return $this->render('products/index.html', 
            ['products' => $products]
        );
    }

    /**
     * Добавление продукта
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function created($request, $response) {


        $categories = Model::factory('Models\Category')->find_many();

        if ( isset($_POST['submit']) ) {

            $product = Model::factory('Models\Product');
            
            $data = \Ohanzee\Helper\Arr::extract($_POST,[
                'title',
                'description',
                'price',
                'category_id'
            ], '');

            if (!empty($_FILES['image']['name'])) {
                $image = Image::open($_FILES['image']['tmp_name']);

                $image->scaleResize($this->image_width, $this->image_height, '0xffffff' );

                $filename = md5(base64_encode($image->get('png', 100))) . '.png';

                $image->save(DOCROOT . '/../aleksandr-sazhin.myjino.ru/_/' . $filename);
                $data['image'] = $filename;
            }

            $product = Model::factory('Models\Product')->create($data);
            $product->save();

            return $response->withRedirect('/products/edit/' . $product->id);
        }

        return $this->render('products/created.html', 
            [
                'product' => $product,
                'categories' => $categories
            ]
        );
    }

    /**
     * Редактирование продукта 
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function edit($request, $response) {

        $id = $request->getAttribute('id');

        if( !isset($id) ) {
            return $response->withRedirect('/products');
        }

        $id = (int) $id;
        $product = Model::factory('Models\Product')->find_one($id);

        $data = $product->as_array();

        $categories = Model::factory('Models\Category')->find_many();

        if( !isset($product->id) ) {
            return $response->withRedirect('/products');
        }

        if ( isset($_POST['submit']) ) {

            $data = \Ohanzee\Helper\Arr::extract($_POST,[
                'title',
                'description',
                'price',
                'category_id'
            ], '');

            if (!empty($_FILES['image']['name'])) {
                $image = Image::open($_FILES['image']['tmp_name']);

                $image->scaleResize($this->image_width, $this->image_height, '0xffffff' );

                $filename = md5(base64_encode($image->get('png', 100))) . '.png';

                $image->save(DOCROOT . '/../aleksandr-sazhin.myjino.ru/_/' . $filename);
                $data['image'] = $filename;
            }

            $product->values($data);
            $product->save();

            return $response->withRedirect('/products/edit/' . $product->id);
        }

        return $this->render('products/edit.html', 
            [
                'product' => $product,
                'categories' => $categories
            ]
        );
    }

    /**
     * Удаление продукта
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function delete($request, $response) {

        $id = $request->getAttribute('id');

        if( !isset($id) ) {
            return $response->withRedirect('/products');
        }

        $id = (int) $id;
        $product = Model::factory('Models\Product')->find_one($id);

        if( !isset($product->id) ) {
            return $response->withRedirect('/products');
        }

        $product->delete();

        return $response->withRedirect('/products');
    }

}
