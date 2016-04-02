<?php

namespace Models;

class Product extends \Model{

  public static $_table = 'products';
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