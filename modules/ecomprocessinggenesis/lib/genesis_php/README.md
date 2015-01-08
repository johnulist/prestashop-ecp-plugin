Overview
===========

PHP Client Library interface for communication with E-ComProcessing's Payment Processing Gateway - Genesis. You can use this library to integrate your current system with Genesis Payment Gateway. Its highly recommended to checkout "Genesis Payment Gateway API Documentation" first, to get an overview of Genesis's Payment Gateway API and functionality.

Requirements
------------

* PHP >= 5.3 (built w/ libxml)
* PHP Extensions: cURL (optionally you can use Streams, but its not recommended on PHP < 5.6)
* Composer

Installation
------------

* clone this repo / download the archive
````bash
git clone http://github.com/E-ComProcessing/genesis_php genesis_php && cd genesis_php
````

* install [Composer]
````bash
curl -sS https://getcomposer.org/installer | php
````

* fetch all required packages
````bash
php composer.phar install
````

* optionally, you may run: ````vendor/bin/phpspec run````, in order to ensure everything is working as intended

* optionally, update the credentials needed to access Genesis inside ```settings_sample.ini``` and place it in a safe, non web-accessible, directory


Example
------

````php
<?php
require 'vendor/autoload.php';

// init/ Work inside the Genesis Workspace
use \Genesis;

// or, you can list only the classes you need
use \Genesis\Genesis as Genesis;
use \Genesis\GenesisConfg as GenesisConf;

// load the pre-configured ini file
GenesisConfig::loadSettings('<path-to-your-ini-file>');

// optionally you can set each of the credentials manually
GenesisConfig::setToken('<enter_your_token>');
GenesisConfig::setUsername('<enter_your_username>');
GenesisConfig::setPassword('<enter_your_password>');
GenesisConfig::setEnvironment('sandbox|production');

// create a new Genesis instance with desired API request
$genesis = new Genesis('Financial\Authorize');

// set request parameters
$genesis
    ->request()
        ->setTransactionId('<transaction_id>')
        ->setUsage('<usage>')
        ->setRemoteIp('<remote_ip>')
        ->setReferenceId('<reference_id>')
        ->setCurrency('<currency>')
        ->setAmount('<amount>')
        // Customer Details
        ->setCustomerEmail('<customer_email>')
        ->setCustomerPhone('<customer_phone>')
        // Credit Card Details
        ->setCardHolder('<card_holder>')
        ->setCardNumber('<card_number>')
        ->setExpirationMonth('<expiration_month>')
        ->setExpirationYear('<expiration_year>')
        ->setCvv('<cvv>')
        // Billing/Invoice Details
        ->setBillingFirstName('<billing_first_name>')
        ->setBillingLastName('<billing_last_name>')
        ->setBillingAddress1('<billing_address1>'
        ->setBillingZipCode('<billing_zip_code>')
        ->setBillingCity('<billing_city>')
        ->setBillingCountry('<billing_country>');
            
// send the request
$genesis->execute();

// check if our request is successful
if ($genesis->response()->isSuccessful()) {
    $response_obj  = $genesis->response()->getResponseObject();
    // process the payment as successful
}
else {
    $error_message = $genesis->response()->getErrorDescription();
    // handle payment errors
}
?>
````

Note: the file ```vendor/autoload.php``` is located inside the directory where you cloned the repo and it is auto-generated by [Composer]. If the file is missing, just run ```php composer.phar update``` inside the cloned directory


Request types
-------------

You can use the following request types to initialize the Genesis interface:

````
Financial\Authorize
Financial\Authorize3D
Financial\Capture
Financial\Credit
Financial\Payout
Financial\Refund
Financial\Sale
Financial\Sale3D
Financial\Void

Financial\Recurring\InitRecurringSale
Financial\Recurring\InitRecurringSale3D
Financial\Recurring\RecurringSale

FraudRelated\Chargeback\DateRange
FraudRelated\Chargeback\Transaction

FraudRelated\Retrieval\DateRange
FraudRelated\Retrieval\Transaction

FraudRelated\Blacklist

NonFinancial\AccountVerification
NonFinancial\AVS

Reconcile\DateRange
Reconcile\Transaction

WPF\Create
WPF\Reconcile
````

More information about each one of the request types can be found in the Genesis API Documentation and the Wiki

API Examples
------------

You can explore Genesis's API, test parameters or get examples for different transaction types with: [Genesis Client Integration]


[Composer]: https://getcomposer.org/
[Genesis Client Integration]: https://github.com/E-ComProcessing/genesis_api_examples