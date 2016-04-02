<?php

namespace Base;

/**
 * Абстрактный контроллер
 */
abstract class Controller {

    protected $view = null;
    protected $flash = null;
    protected $container = null;

    /**
     * [__construct description]
     * @param \Slim\Container $container
     */
    public function __construct(\Slim\Container $container) {

      $this->container = $container;
      $this->view = $container->view;
      $this->flash = $container->flash;

    }

    /**
     * Вывод шаблона
     * @param  string $template Путь к шаблону
     * @param  array $data Ассоциативный массив переменных шаблона
     */
    public function render($template, $data = []) {

			return $this->container->view->render(
				$this->container->response, 
				$template, 
				$data
			);

    }
}