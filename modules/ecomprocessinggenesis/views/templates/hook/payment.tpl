{*
 * Simplify Commerce module to start accepting payments now. It's that simple.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 * conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of the MasterCard International Incorporated nor the names of its
 * contributors may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *  @author    MasterCard (support@simplify.com)
 *  @version   Release: 1.0.3
 *  @copyright 2014, MasterCard International Incorporated. All rights reserved.
 *  @license   See licence.txt
 *}
<div class="cc-container">
    <div class="payment-errors" {if isset($smarty.get.genesis_error)}style="display:block;"{/if}>
        {if isset($smarty.get.genesis_error)}{$smarty.get.genesis_error|escape:html:'UTF-8'}{/if}
    </div>

    <div class="card-wrapper"></div>

    <div class="form-container form-group active">
        <form action="{$module_dir|escape}validation.php" method="POST">
            <input placeholder="{l s="Card Number" mod="ecomprocessinggenesis"}" class="form-control" type="text" name="ecomprocessinggenesis-number">
            <input placeholder="{l s="Full Name" mod="ecomprocessinggenesis"}" class="form-control" type="text" name="ecomprocessinggenesis-name">
            <input placeholder="{l s="MM/YY" mod="ecomprocessinggenesis"}" class="form-control" type="text" name="ecomprocessinggenesis-expiry">
            <input placeholder="{l s="CVC" mod="ecomprocessinggenesis"}" class="form-control" type="text" name="ecomprocessinggenesis-cvc">
            <input class="form-control submit" type="submit" />
        </form>
    </div>
</div>
<script type="text/javascript">
    $('.active form').card({
        container:       $('.card-wrapper'),
        updateContainer: $('.cc-container'),
        numberInput:    'input[name="ecomprocessinggenesis-number"]',
        nameInput:      'input[name="ecomprocessinggenesis-name"]',
        expiryInput:    'input[name="ecomprocessinggenesis-expiry"]',
        cvcInput:       'input[name="ecomprocessinggenesis-cvc"]',
    });
</script>