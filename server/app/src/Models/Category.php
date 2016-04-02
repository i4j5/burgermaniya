<?php

namespace Models;

/**
 * Модель категории 
 */
class Category extends \Model{

  /**
   * Таблица категорий
   * @var string
   */
  public static $_table = 'categories';

  /**
   * Первичный ключ
   * @var string
   */
  public static $_id_column = 'id';
  
  public function values(array $values)
  {
    foreach ($values as $key => $val)
    {
      $this->set($key, $val);
    }

    return $this;
  }

}