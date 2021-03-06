<?php
/*
 * Copyright (C) 2015 EComProcessing™
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
 * @author      EComProcessing™
 * @copyright   2015 EComProcessing™
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

/**
 * Class EComProcessingNotificationModuleFrontController
 *
 * Notifications Front-End Controller
 */
class EComProcessingNotificationModuleFrontController extends ModuleFrontController
{
	/** @var EComProcessing */
	public $module;

    /**
     * Supported transaction types for Order Status
     *
     * @var array
     */
    public $types = array(
		\Genesis\API\Constants\Transaction\Types::ABNIDEAL,
		\Genesis\API\Constants\Transaction\Types::AUTHORIZE,
		\Genesis\API\Constants\Transaction\Types::AUTHORIZE_3D,
		\Genesis\API\Constants\Transaction\Types::CASHU,
		\Genesis\API\Constants\Transaction\Types::NETELLER,
		\Genesis\API\Constants\Transaction\Types::PAYSAFECARD,
		\Genesis\API\Constants\Transaction\Types::PPRO,
		\Genesis\API\Constants\Transaction\Types::SALE,
		\Genesis\API\Constants\Transaction\Types::SALE_3D,
		\Genesis\API\Constants\Transaction\Types::SOFORT,
    );

	/**
	 * @see FrontController::initContent()
	 */
	public function initContent()
	{
		parent::initContent();

        $this->module->applyGenesisConfig();

		if (Tools::getIsset('signature')) {
			if (Tools::getIsset('wpf_unique_id')) {
				$this->processCheckoutIPN();
			}
			else {
				$this->processDirectIPN();
			}
		}

		exit(0);
	}

	/**
	 * Process Notification for the Direct API
	 */
	private function processDirectIPN()
	{
		try {
			/** @var \Genesis\API\Notification $notification */
			$notification = new \Genesis\API\Notification($_POST);

			if ( $notification->isAuthentic() ) {
				$notification->initReconciliation();

                $reconcile = $notification->getReconciliationObject();

				if (isset($reconcile->unique_id)) {

                    $transaction = EComProcessingTransaction::getByUniqueId( $reconcile->unique_id );

                    if (isset( $transaction->id_unique ) && $transaction->id_unique == $reconcile->unique_id) {
                        if (in_array($reconcile->transaction_type, $this->types)) {
                            $status = $this->module->getPrestaStatus($reconcile->status);
                        } else {
                            $status = $this->module->getPrestaBackendStatus($reconcile->transaction_type);
                        }

                        $transaction->importResponse( $reconcile );
                        $transaction->updateOrderHistory( $status, true );
                        $transaction->save();
                    }

                    $notification->renderResponse();
                }
			}
		}
		catch (\Exception $exception) {
			if (class_exists('Logger')) {
				Logger::addLog( $exception->getMessage(), 4, $exception->getCode(), $this->module->displayName, $this->module->id, true );
			}
		}
	}

	/**
	 * Process Notifications for the Checkout (WPF) API
	 */
	private function processCheckoutIPN()
	{
		try {
			/** @var \Genesis\API\Notification $notification */
			$notification = new \Genesis\API\Notification($_POST);

			if ( $notification->isAuthentic() ) {
				$notification->initReconciliation();

                $checkout_reconcile = $notification->getReconciliationObject();

				if (isset($checkout_reconcile->unique_id)) {

					$checkout_transaction = EComProcessingTransaction::getByUniqueId($checkout_reconcile->unique_id);

					if (isset($checkout_transaction->id_unique)) {

                        $checkout_transaction->type = 'checkout';
                        $checkout_transaction->importResponse($checkout_reconcile);

						if ( isset( $checkout_reconcile->payment_transaction ) ) {
                            $payment_reconcile = $checkout_reconcile->payment_transaction;

                            /** @var EComProcessingTransaction $transaction */
							$payment_transaction = EComProcessingTransaction::getByUniqueId( $payment_reconcile->unique_id );

							if ( $payment_transaction ) {
								$payment_transaction->importResponse( $payment_reconcile );
								$payment_transaction->save();
							} else {
								$payment_transaction = new EComProcessingTransaction();

								$payment_transaction->id_parent = $checkout_transaction->id_unique;
								$payment_transaction->ref_order = $checkout_transaction->ref_order;
								$payment_transaction->importResponse( $payment_reconcile );
								$payment_transaction->add();
							}

                            if (in_array($payment_reconcile->transaction_type, $this->types)) {
                                $status = $this->module->getPrestaStatus($payment_reconcile->status);
                            } else {
                                $status = $this->module->getPrestaBackendStatus($payment_reconcile->transaction_type);
                            }

                            $checkout_transaction->updateOrderHistory( $status, true );
						}

                        $checkout_transaction->save();

						$notification->renderResponse();
					}
				}
			}
		}
		catch (Exception $exception) {
			if (class_exists('Logger')) {
				Logger::addLog( $exception->getMessage(), 4, $exception->getCode(), $this->module->displayName, $this->module->id, true );
			}
		}
	}
}