{*
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
 * @author      EComProcessing
 * @copyright   2015 EComProcessing™
 * @license     http://opensource.org/licenses/gpl-2.0.php GNU General Public License, version 2 (GPL-2.0)
 *}

{if version_compare($ecomprocessing['presta']['version'], '1.5', '>=') && version_compare($ecomprocessing['presta']['version'], '1.6', '<') }

    <style>
        .text-left { text-align:left; }
        .text-center { text-align:center; }
        .text-right { text-align:right; }
    </style>

    <br/>

    <fieldset {if isset($ecomprocessing['presta']['version']) && ($ecomprocessing['presta']['version'] < '1.5')}style="width: 400px"{/if}>
        <legend><img src="{$ecomprocessing['presta']['url']}/modules/{$ecomprocessing['name']['module']}/logo.png" style="width:16px" alt="" />{l s='EComProcessing Transactions' mod='ecomprocessing'}</legend>
        {* System errors, impacting the module functionallity *}
        {if $ecomprocessing['warning']}
            <div class="warn">{$ecomprocessing['warning']|escape:html:'UTF-8'}</div>
        {else}
            {* Transaction errors *}
            {if $ecomprocessing['transactions']['error']}
                <div class="error">{$ecomprocessing['transactions']['error']}</div>
            {/if}

            <div class="row">
                <div class="col-xs-3"></div>
                <div class="col-xs-6">
                    <div class="warn">
                        {l s="Full/Partial refunds through Prestashop's UI are local and WILL NOT REFUND the original transaction." mod="ecomprocessing"}
                    </div>
                </div>
                <div class="col-xs-3"></div>
            </div>

            <form method="post" action="{$smarty.server.REQUEST_URI|escape:'htmlall':'UTF-8'}">
                <table class="table tree" width="100%" cellspacing="0" cellpadding="0" id="shipping_table">
                    <colgroup>
                        <col width="18%"/>
                        <col width="5%"/>
                        <col width="5%"/>
                        <col width="5%"/>
                        <col width="5%"/>
                        <col width="5%"/>
                        <col width="2%"/>
                        <col width="2%"/>
                        <col width="2%"/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th>{l s="Id"       mod="ecomprocessing"}</th>
                        <th>{l s="Type"     mod="ecomprocessing"}</th>
                        <th>{l s="Date"     mod="ecomprocessing"}</th>
                        <th>{l s="Amount"   mod="ecomprocessing"}</th>
                        <th>{l s="Status"   mod="ecomprocessing"}</th>
                        <th>{l s="Message"  mod="ecomprocessing"}</th>
                        <th colspan="3" style="text-align: center;">{l s="Action" mod="ecomprocessing"}</th>
                    </tr>
                    </thead>
                    <tbody>
                    {foreach from=$ecomprocessing['transactions']['tree'] item=transaction}
                        <tr class="treegrid-{$transaction['id_unique']} {if $transaction['id_parent']}treegrid-parent-{$transaction['id_parent']}{/if}">
                            <td class="text-left">{$transaction['id_unique']}</td>
                            <td class="text-left">{$transaction['type']}</td>
                            <td class="text-center">{$transaction['date_add']}</td>
                            <td class="text-center">{$transaction['amount']}</td>
                            <td class="text-center">{$transaction['status']}</td>
                            <td class="text-center">{$transaction['message']}</td>
                            <td class="text-center">
                                {if $transaction['can_capture']}
                                    <div class="transaction-action-button">
                                        <a class="btn btn-transaction btn-success button-capture button" role="button" data-type="capture" data-id-unique="{$transaction['id_unique']}" data-amount="{$transaction['amount']}" >
                                            <i class="fa fa-check fa-large"></i>
                                        </a>
                                    </div>
                                {/if}
                            </td>
                            <td class="text-center">
                                {if $transaction['can_refund']}
                                    <div class="transaction-action-button">
                                        <a class="btn btn-transaction btn-warning button-refund button" role="button" data-type="refund" data-id-unique="{$transaction['id_unique']}" data-amount="{$transaction['amount']}">
                                            <i class="fa fa-reply fa-large"></i>
                                        </a>
                                    </div>
                                {/if}
                            </td>
                            <td class="text-center">
                                {if $transaction['can_void']}
                                    <div class="transaction-action-button">
                                        <a class="btn btn-transaction btn-danger button-void button" role="button" data-type="void" data-id-unique="{$transaction['id_unique']}">
                                            <i class="fa fa-remove fa-large"></i>
                                        </a>
                                    </div>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                    <tr id="{$ecomprocessing['name']['module']}_action_bar" class="current-edit" style="display:none;">
                        <td colspan="1" id="{$ecomprocessing['name']['module']}_transaction_amount_placeholder" style="vertical-align:middle">
                            <label for="{$ecomprocessing['name']['module']}_transaction_amount" style="width:20%;">{l s="Amount:" mod="ecomprocessing"}</label>
                            <input type="text" id="{$ecomprocessing['name']['module']}_transaction_amount" name="{$ecomprocessing['name']['module']}_transaction_amount" placeholder="{l s="Amount..." mod="ecomprocessing"}" value="{{$ecomprocessing['transactions']['order']['amount']}}" style="width:70%;" />
                        </td>
                        <td colspan="5" id="{$ecomprocessing['name']['module']}_transaction_usage_placeholder" style="vertical-align:middle">
                            <label for="{$ecomprocessing['name']['module']}_transaction_usage" style="width:20%;">{l s="Usage:" mod="ecomprocessing"}</label>
                            <input type="text" id="{$ecomprocessing['name']['module']}_transaction_usage" name="{$ecomprocessing['name']['module']}_transaction_usage" placeholder="{l s="Usage..." mod="ecomprocessing"}" style="width:70%;" />
                        </td>
                        <td colspan="3" style="text-align:center;vertical-align:middle">
                            <input type="hidden" id="{$ecomprocessing['name']['module']}_transaction_id" name="{$ecomprocessing['name']['module']}_transaction_id" value="" />
                            <input type="hidden" id="{$ecomprocessing['name']['module']}_transaction_type" name="{$ecomprocessing['name']['module']}_transaction_type" value="" />
                            <button type="submit" class="btn btn-success">
                                <i class="fa fa-arrow-right fa-large"></i>
                                {l s="Submit" mod="ecomprocessing"}
                            </button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <p class="text-right">
                <b>{l s='Information:' mod='ecomprocessing'}</b> {l s="For more complex workflows/functionallity, please visit our Merchant Portal!" mod="ecomprocessing"}
            </p>
        {/if}
    </fieldset>
    <script type="text/javascript">
        $(document).ready(function() {
            $('.tree').treegrid({
                expanderExpandedClass:  'fa fa-chevron-circle-down',
                expanderCollapsedClass: 'fa fa-chevron-circle-right'
            });
            $('.btn-transaction').click(function () {
                transactionBar($(this).attr('data-type'), $(this).attr('data-id-unique'), $(this).attr('data-amount'));
            });
        });

        function transactionBar(type, id_unique, amount) {
            modalObj = $('#{$ecomprocessing['name']['module']}_action_bar');

            modalObj.fadeOut(300, function() {
                switch(type) {
                    case 'capture':
                        modalObj.find('#{$ecomprocessing['name']['module']}_transaction_amount_placeholder').css('visibility', 'visible');
                        break;
                    case 'refund':
                        modalObj.find('#{$ecomprocessing['name']['module']}_transaction_amount_placeholder').css('visibility', 'visible');
                        break;
                    case 'void':
                        modalObj.find('#{$ecomprocessing['name']['module']}_transaction_amount_placeholder').css('visibility', 'hidden');
                        break;
                    default:
                        return;
                }

                modalObj.find('#{$ecomprocessing['name']['module']}_transaction_type').attr('value', type);

                modalObj.find('#{$ecomprocessing['name']['module']}_transaction_id').attr('value', id_unique);

                modalObj.find('#{$ecomprocessing['name']['module']}_transaction_amount').attr('value', amount);
            });

            modalObj.fadeIn(300, function() {

            });
        }
    </script>
{/if}

{if version_compare($ecomprocessing['presta']['version'], '1.6', '>=') && version_compare($ecomprocessing['presta']['version'], '1.7', '<') }

    <div class="row">
        <div class="col-lg-12">
            <div class="panel">
                <div class="panel-heading">
                    <img src="{$ecomprocessing['presta']['url']}/modules/{$ecomprocessing['name']['module']}/logo.png" alt="" style="width:16px;" />
                    <span>{l s='EComProcessing Transactions' mod='ecomprocessing'}</span>
                </div>
                <div class="panel-collapse collapse in">

                    {* System errors, impacting the module functionallity *}
                    {if $ecomprocessing['warning']}
                        <div class="alert alert-warning alert-dismissable error-wrapper">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            {$ecomprocessing['warning']|escape:html:'UTF-8'}
                        </div>
                    {/if}

                    {* Transaction errors *}
                    {if $ecomprocessing['transactions']['error']}
                        <div class="alert alert-danger alert-dismissable error-wrapper">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            {$ecomprocessing['transactions']['error']|escape:html:'UTF-8'}
                        </div>
                    {/if}

                    <div class="row">
                        <div class="col-xs-3"></div>
                        <div class="col-xs-6">
                            <div class="alert alert-info">
                                {l s="You must process full/partial refunds only through this panel!" mod="ecomprocessing"}
                                <br/>
                                {l s="Full/Partial refunds through Prestashop's UI are local and WILL NOT REFUND the original transaction." mod="ecomprocessing"}
                            </div>
                        </div>
                        <div class="col-xs-3"></div>
                    </div>

                    {if $ecomprocessing['transactions']['tree']}
                        <table class="table table-hover tree">
                            <thead>
                            <tr>
                                <th>{l s="Id"       mod="ecomprocessing"}</th>
                                <th>{l s="Type"     mod="ecomprocessing"}</th>
                                <th>{l s="Date"     mod="ecomprocessing"}</th>
                                <th>{l s="Amount"   mod="ecomprocessing"}</th>
                                <th>{l s="Status"   mod="ecomprocessing"}</th>
                                <th>{l s="Message"  mod="ecomprocessing"}</th>
                                <th>{l s="Capture"  mod="ecomprocessing"}</th>
                                <th>{l s="Refund"   mod="ecomprocessing"}</th>
                                <th>{l s="Cancel"   mod="ecomprocessing"}</th>
                            </tr>
                            </thead>
                            <tbody>
                            {foreach from=$ecomprocessing['transactions']['tree'] item=transaction}
                                <tr class="treegrid-{$transaction['id_unique']} {if $transaction['id_parent']}treegrid-parent-{$transaction['id_parent']}{/if}">
                                    <td class="text-left">
                                        {$transaction['id_unique']}
                                    </td>
                                    <td class="text-left">
                                        {$transaction['type']}
                                    </td>
                                    <td class="text-left">
                                        {$transaction['date_add']}
                                    </td>
                                    <td class="text-right">
                                        {$transaction['amount']}
                                    </td>
                                    <td class="text-left">
                                        {$transaction['status']}
                                    </td>
                                    <td class="text-left">
                                        {$transaction['message']}
                                    </td>
                                    <td class="text-center">
                                        {if $transaction['can_capture']}
                                            <div class="transaction-action-button">
                                                <a class="btn btn-transaction btn-success button-capture button" role="button" data-type="capture" data-id-unique="{$transaction['id_unique']}" data-amount="{$transaction['available_amount']}">
                                                    <i class="icon-check icon-large"></i>
                                                </a>
                                            </div>
                                        {/if}
                                    </td>
                                    <td class="text-center">
                                        {if $transaction['can_refund']}
                                            <div class="transaction-action-button">
                                                <a class="btn btn-transaction btn-warning button-refund button" role="button" data-type="refund" data-id-unique="{$transaction['id_unique']}" data-amount="{$transaction['available_amount']}">
                                                    <i class="icon-reply icon-large"></i>
                                                </a>
                                            </div>
                                        {/if}
                                    </td>
                                    <td class="text-center">
                                        {if $transaction['can_void']}
                                            <div class="transaction-action-button">
                                                <a class="btn btn-transaction btn-danger button-void button" role="button" data-type="void" data-id-unique="{$transaction['id_unique']}" data-amount="0">
                                                    <i class="icon-remove icon-large"></i>
                                                </a>
                                            </div>
                                        {/if}
                                    </td>
                                </tr>
                            {/foreach}
                            </tbody>
                        </table>
                    {/if}
                    <div class="disclaimer" style="text-align:right;margin-top:16px;">
                        {l s="Note: For more complex workflows/functionallity, please visit our Merchant Portal!" mod="ecomprocessing"}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="{$ecomprocessing['name']['module']}-modal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        <i class="icon-times"></i>
                    </button>
                    <img src="{$ecomprocessing['presta']['url']}modules/{$ecomprocessing['name']['module']}/logo.png" style="width:16px;" />
                    <h3 class="{$ecomprocessing['name']['module']}-modal-title" style="margin:0;display:inline-block;"></h3>
                </div>
                <div class="modal-body">
                    <form id="{$ecomprocessing['name']['module']}-modal-form" class="form modal-form" action="" method="post">
                        <input type="hidden" name="{$ecomprocessing['name']['module']}_transaction_id" value="" />
                        <input type="hidden" name="{$ecomprocessing['name']['module']}_transaction_type" value="" />

                        <div class="form-group amount-input">
                            <label for="{$ecomprocessing['name']['module']}_transaction_amount">{l s="Amount:" mod="ecomprocessing"}</label>
                            <div class="input-group">
                                <span class="input-group-addon" data-toggle="{$ecomprocessing['name']['module']}-tooltip" data-placement="top" title="{{$ecomprocessing['transactions']['order']['currency']['iso_code']}}">{{$ecomprocessing['transactions']['order']['currency']['sign']}}</span>
                                <input type="text" class="form-control" id="{$ecomprocessing['name']['module']}_transaction_amount" name="{$ecomprocessing['name']['module']}_transaction_amount" placeholder="{l s="Amount..." mod="ecomprocessing"}" value="{{$ecomprocessing['transactions']['order']['amount']}}" />
                            </div>
                            <span class="help-block" id="{$ecomprocessing['name']['module']}-amount-error-container"></span>
                        </div>

                        <div class="form-group usage-input">
                            <label for="{$ecomprocessing['name']['module']}_transaction_usage">{l s='Message (optional):' mod="ecomprocessing"}</label>
                            <textarea class="form-control form-message" rows="3" id="{$ecomprocessing['name']['module']}_transaction_usage" name="{$ecomprocessing['name']['module']}_transaction_usage" placeholder="{l s='Message' mod="ecomprocessing"}"></textarea>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <span class="form-loading hidden">
                        <i class="icon-spinner icon-spin icon-large"></i>
                    </span>
                    <span class="form-buttons">
                        <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">{l s="Cancel" mod="ecomprocessing"}</button>
                        <button id="{$ecomprocessing['name']['module']}-modal-submit" class="btn btn-submit btn-primary btn-capture" value="partial">{l s="Submit" mod="ecomprocessing"}</button>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        var modalPopupDecimalValueFormatConsts = {
            decimalPlaces       : {$ecomprocessing['transactions']['order']['currency']['decimalPlaces']},
            decimalSeparator    : "{$ecomprocessing['transactions']['order']['currency']['decimalSeparator']}",
            thousandSeparator   : "{$ecomprocessing['transactions']['order']['currency']['thousandSeparator']}"
        };

        (function($) {
            jQuery.exists = function(selector) {
                return ($(selector).length > 0);
            }

            $.fn.bootstrapValidator.i18n.transactionAmount = $.extend($.fn.bootstrapValidator.i18n.transactionAmount || {}, {
                'default': 'Please enter a valid transaction amount. (Ex. %s)'
            });

            $.fn.bootstrapValidator.validators.transactionAmount = {
                html5Attributes: {
                    message: 'message',
                    exampleValue: 'exampleValue'
                },

                validate: function(validator, $field, options) {
                    var fieldValue 	    = $field.val(),
                            regexp          = /^(([0-9]*)|(([0-9]*)\.([0-9]*)))$/i,
                            isValid    	    = true,
                            errorMessage    = options.message || $.fn.bootstrapValidator.i18n.transactionAmount['default'],
                            exampleValue    = options.exampleValue || "123.45";

                    errorMessage = $.fn.bootstrapValidator.helpers.format(errorMessage, [exampleValue]);

                    isValid = regexp.test(fieldValue);

                    return {
                        valid: isValid,
                        message: errorMessage
                    };
                }
            }
        }(window.jQuery));

        function formatTransactionAmount(amount) {
            if ((typeof amount == 'undefined') || (amount == null))
                amount = 0;

            return $.number(amount, modalPopupDecimalValueFormatConsts.decimalPlaces,
                                    modalPopupDecimalValueFormatConsts.decimalSeparator,
                                    modalPopupDecimalValueFormatConsts.thousandSeparator);
        }

        function destroyBootstrapValidator(submitFormId) {
            $(submitFormId).bootstrapValidator('destroy');
        }

        function createBootstrapValidator(submitFormId) {
            var submitForm = $(submitFormId),
                    transactionAmount = formatTransactionAmount($('#{$ecomprocessing['name']['module']}_transaction_amount').val());

            destroyBootstrapValidator(submitFormId);

            var transactionAmountControlSelector = '#{$ecomprocessing['name']['module']}_transaction_amount';
            
            var shouldCreateValidator = $.exists(transactionAmountControlSelector);
            
            /* it is not needed to create attach the bootstapValidator, when the field to validate is not visible (Void Transaction) */
            if (!shouldCreateValidator) 
                return false;
                
            submitForm.bootstrapValidator({
                fields: {
                    fieldAmount: {
                        selector: transactionAmountControlSelector,
                        container: '#{$ecomprocessing['name']['module']}-amount-error-container',
                        trigger: 'keyup',
                        validators: {
                            notEmpty: {
                                message: 'The transaction amount is a required field!'
                            },
                            stringLength: {
                                max: 10
                            },
                            greaterThan: {
                                value: 0,
                                inclusive: false
                            },
                            lessThan: {
                                value: transactionAmount,
                                inclusive: true
                            },
                            transactionAmount: {
                                exampleValue: transactionAmount,
                            }
                        }
                    }
                }
            })
            .on('error.field.bv', function(e, data) {
                $('#{$ecomprocessing['name']['module']}-modal-submit').attr('disabled', 'disabled');
            })
            .on('success.field.bv', function(e) {
                $('#{$ecomprocessing['name']['module']}-modal-submit').removeAttr('disabled');
            })
            .on('success.form.bv', function(e) {
                e.preventDefault(); // Prevent the form from submitting

                /* submits the transaction form (No validators have failed) */
                submitForm.bootstrapValidator('defaultSubmit');
            });
            
            return true;
        }

        function executeBootstrapFieldValidator(formId, validatorFieldName) {
            var submitForm = $(formId);

            submitForm.bootstrapValidator('validateField', validatorFieldName);
            submitForm.bootstrapValidator('updateStatus', validatorFieldName, 'NOT_VALIDATED');
        }

        $(document).ready(function() {

            $('[data-toggle="{$ecomprocessing['name']['module']}-tooltip"]').tooltip();

            $('.tree').treegrid({
                expanderExpandedClass:  'icon icon-chevron-sign-down',
                expanderCollapsedClass: 'icon icon-chevron-sign-right'
            });

            $('.btn-transaction').click(function() {
                transactionModal($(this).attr('data-type'), $(this).attr('data-id-unique'), $(this).attr('data-amount'));
            });

            var modalObj = $('#{$ecomprocessing['name']['module']}-modal'),
                transactionAmountInput = $('#{$ecomprocessing['name']['module']}_transaction_amount', modalObj);

            $('#{$ecomprocessing['name']['module']}-modal-submit').click(function() {
                $('#{$ecomprocessing['name']['module']}-modal-form').submit();
            });

            modalObj.on('hide.bs.modal', function() {
                destroyBootstrapValidator('#{$ecomprocessing['name']['module']}-modal-form');
            });

            modalObj.on('shown.bs.modal', function() {
                /* enable the submit button just in case (if the bootstrapValidator is enabled it will disable the button if necessary */
                $('#{$ecomprocessing['name']['module']}-modal-submit').removeAttr('disabled');
                
                if (createBootstrapValidator('#{$ecomprocessing['name']['module']}-modal-form')) {
                    executeBootstrapFieldValidator('#{$ecomprocessing['name']['module']}-modal-form', 'fieldAmount');
                }
            });

            transactionAmountInput.number(true, modalPopupDecimalValueFormatConsts.decimalPlaces,
                                                modalPopupDecimalValueFormatConsts.decimalSeparator,
                                                modalPopupDecimalValueFormatConsts.thousandSeparator);

        });

        function transactionModal(type, id_unique, amount) {
            if ((typeof amount == 'undefined') || (amount == null))
                amount = 0;

            var modalObj = $('#{$ecomprocessing['name']['module']}-modal');

            var modalTitle = $('h3.{$ecomprocessing['name']['module']}-modal-title', modalObj),
                modalAmountInputContainer = $('div.amount-input', modalObj),
                transactionAmountInput = $('#{$ecomprocessing['name']['module']}_transaction_amount', modalObj);

            switch(type) {
                case 'capture':
                    modalTitle.text('{l s="Capture transaction" mod="ecomprocessing"}');
                    break;

                case 'refund':
                    modalTitle.text('{l s="Refund transaction" mod="ecomprocessing"}');
                    break;

                case 'void':
                    modalTitle.text('{l s="Cancel transaction" mod="ecomprocessing"}');
                    break;
                default:
                    return;
            }

            updateTransModalControlState([modalAmountInputContainer], (type !== 'void'));

            modalObj.find('input[name="{$ecomprocessing['name']['module']}_transaction_type"]').val(type);

            modalObj.find('input[name="{$ecomprocessing['name']['module']}_transaction_id"]').val(id_unique);

            transactionAmountInput.val(amount);

            modalObj.modal('show');

        }

        function updateTransModalControlState(controls, visibilityStatus) {
            $.each(controls, function(index, control){
                if (!$.exists(control))
                    return; /* continue to the next item */

                if (visibilityStatus)
                    control.fadeIn('fast');
                else
                    control.fadeOut('fast');
            });
        }

    </script>

    <style type="text/css">
        .bootstrap .tooltip-inner {
            padding: 5px 20px;
        }
    </style>

{/if}