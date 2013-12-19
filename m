Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3LSPrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:47:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:32716 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3LSPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:47:12 -0500
Message-ID: <52B314FA.6090206@atmel.com>
Date: Thu, 19 Dec 2013 16:47:06 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: at91: fix pmc_clk_ids data type attriubte
References: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com> <52B01A50.4080209@atmel.com> <20131219075725.18119.80803@quantum>
In-Reply-To: <20131219075725.18119.80803@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/2013 08:57, Mike Turquette :
> Quoting Nicolas Ferre (2013-12-17 01:33:04)
>> On 16/12/2013 22:25, Boris BREZILLON :
>>> Fix pmc_clk_ids data type attribute (__initdata -> __initconst).
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> I take it in at91-3.14-cleanup2 branch and send it upstream through
>> arm-soc like any other CCF material for AT91 for the 3.14 release.
>>
>> I guess that even without Mike Acked-by, this little fix can follow this
>> path.
> 
> I can take it into the clk tree if you prefer.

Do not bother Mike, I take this little one for having all CCF AT91
material in one place before 3.14-rc1.

After that milestone, we will take the usual patch using your tree.

Bye,

>>> ---
>>>  drivers/clk/at91/pmc.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
>>> index 7b9db60..4c03eda 100644
>>> --- a/drivers/clk/at91/pmc.c
>>> +++ b/drivers/clk/at91/pmc.c
>>> @@ -228,7 +228,7 @@ out_free_pmc:
>>>       return NULL;
>>>  }
>>>  
>>> -static const struct of_device_id pmc_clk_ids[] __initdata = {
>>> +static const struct of_device_id pmc_clk_ids[] __initconst = {
>>>       /* Main clock */
>>>       {
>>>               .compatible = "atmel,at91rm9200-clk-main",
>>>
>>
>>
>> -- 
>> Nicolas Ferre
> 


-- 
Nicolas Ferre
