<?php

namespace Controllers;

use \Base\Controller,
    \Model,
    Gregwar\Image\Image;

/**
 * Контроллер категорий 
 */
class Categories extends Controller {
    
    /**
     * Ширина изображения 
     * @var integer
     */
    private $image_width = 100;

    /**
     * Высота изображения
     * @var integer
     */
    private $image_height = 100;
    
    /**
     * Все категории
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function index($request, $response) {
       
        $categories = Model::factory('Models\Category')->find_many();

        return $this->render('categories/index.html', 
            ['categories' => $categories]
        );
    }

    /**
     * Добавление категории 
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function created($request, $response) {

        if ( isset($_POST['submit']) ) {

            $data = \Ohanzee\Helper\Arr::extract($_POST,[
                'title'
            ], '');

            if (!empty($_FILES['image']['name'])) {
                $image = Image::open($_FILES['image']['tmp_name']);

                $image->scaleResize($this->image_width, $this->image_height, '0xffffff' );

                $filename = md5(base64_encode($image->get('png', 100))) . '.png';

                $image->save(DOCROOT . '/../aleksandr-sazhin.myjino.ru/_/' . $filename);
                $data['image'] = $filename;
            }

            $category = Model::factory('Models\Category')->create($data);
            $category->save();

            return $response->withRedirect('/categories/edit/' . $category->id);
        }


        return $this->render('categories/created.html', 
            ['category' => $category]
        );
    }

    /**
     * Редактирование категории 
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function edit($request, $response) {

        $id = $request->getAttribute('id');
        
        if( !isset($id) ) {
            return $response->withRedirect('/categories');
        } 

        $id = (int) $id;
        $category = Model::factory('Models\Category')->find_one($id);

        if( !isset($category->id) ) {
            return $response->withRedirect('/categories');
        } 

        if ( isset($_POST['submit']) ) {

            $data = \Ohanzee\Helper\Arr::extract($_POST,[
                'title'
            ], '');

            if (!empty($_FILES['image']['name'])) {
                $image = Image::open($_FILES['image']['tmp_name']);

                $image->scaleResize($this->image_width, $this->image_height, '0xffffff' );

                $filename = md5(base64_encode($image->get('png', 100))) . '.png';

                $image->save(DOCROOT . '/../aleksandr-sazhin.myjino.ru/_/' . $filename);
                $data['image'] = $filename;
            }

            $category->values($data);
            $category->save();

           return $response->withRedirect('/categories/edit/' . $category->id);
        }

       return $this->render('categories/edit.html', 
            ['category' => $category]
        );
    }

    /**
     * Удаление категории 
     * @param  \Psr\Http\Message\ServerRequestInterface $request
     * @param  \Psr\Http\Message\ResponseInterface  $response
     */
    public function delete($request, $response) {

        $id = $request->getAttribute('id');

        if( !isset($id) ) {
            return $response->withRedirect('/categories');
        }

        $id = (int) $id;
        $category = Model::factory('Models\Category')->find_one($id);

        if( !isset($category->id) ) {
            return $response->withRedirect('/categories');
        }

        $category->delete();

        return $response->withRedirect('/categories');
    }
    
}