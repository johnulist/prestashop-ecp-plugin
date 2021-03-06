<?php
/*
 * Copyright (C) 2015 E-Comprocessing™
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * @author      E-Comprocessing™
 * @copyright   2015 E-Comprocessing™
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

/**
 * Class EComProcessingInstall
 *
 * Perform module installation/un-installation
 */
class EComProcessingInstall
{
	private $status = true;

	private $hooks = array(
		'header',
		'payment',
		'paymentTop',
		'orderConfirmation',
		'adminOrder',
		'BackOfficeHeader',
	);

	/**
	 * Create the table/tables required by the module
	 */
	public function createSchema()
	{
        $schema = '
            CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'ecomprocessing_transactions`
              (
                 `id_entry`  INT NOT NULL auto_increment,
                 `id_unique` VARCHAR(255) NOT NULL,
                 `id_parent` VARCHAR(255) NOT NULL,
                 `ref_order` VARCHAR(9) NOT NULL,
                 `type`      VARCHAR(255) NOT NULL,
                 `status`    VARCHAR(255) NOT NULL,
                 `message`   VARCHAR(255) NULL,
                 `currency`  VARCHAR(3) NULL,
                 `amount`    DECIMAL(10, 2) NULL,
                 `terminal`  VARCHAR(255) NULL,
                 `date_add`  DATETIME DEFAULT NULL,
                 `date_upd`  TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                 PRIMARY KEY (`id_entry`)
              )
            engine=`' . _MYSQL_ENGINE_ . '`
            DEFAULT charset=utf8;';

		if (!Db::getInstance()->execute($schema)) {
			$this->status = false;
            throw new PrestaShopException('Module Install: Unable to create MySQL Database');
		}
	}

	/**
	 * Register all Hooks required by the module
	 *
	 * @param $instance EComProcessing
	 *
	 * @throws PrestaShopException
	 */
	public function registerHooks($instance)
	{
		foreach ($this->hooks as $hook) {
			if (!$instance->registerHook($hook)) {
				$this->status = false;
				throw new PrestaShopException('Module Install: Hook (' . $hook . ') can\'t be registered!');
			}
		}
	}

	/**
	 * Delete the table/tables required by the module
	 */
	public function dropSchema()
	{
		$schema = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'ecomprocessing_transactions`';

		if (!Db::getInstance()->execute($schema)) {
			$this->status = false;
            throw new PrestaShopException('Module Uninstall: Unable to DROP transactions table!');
		}
	}

	/**
	 * Delete registered hooks
	 *
	 * @param $instance EComProcessing
	 *
	 * @throws PrestaShopException
	 */
	public function dropHooks($instance)
	{
		foreach ($this->hooks as $hook) {
			if (!$instance->unregisterHook($hook)) {
				$this->status = false;
				throw new PrestaShopException('Module Uninstall: Hook (' . $hook . ') can\'t be unregistered!');
			}
		}
	}

    /**
     * Delete module configuration
     *
     * @param EComProcessing $instance
     * @throws PrestaShopException
     */
	public function dropKeys($instance)
	{
		foreach ($instance->getConfigKeys() as $key) {
			if (!Configuration::deleteByName($key)) {
				$this->status = false;
                throw new PrestaShopException('Module Uninstall: Unable to remove configuration keys');
			}
		}
	}

	/**
	 * Return the status of all processed methods
	 * @return bool
	 */
	public function isSuccessful() {
		return $this->status;
	}
}