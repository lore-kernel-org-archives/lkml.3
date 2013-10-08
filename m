Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab3JHQPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:15:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:62336 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3JHQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:15:24 -0400
Message-ID: <52542F95.5050603@atmel.com>
Date: Tue, 8 Oct 2013 18:15:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 12/19] clk: at91: add peripheral clk macros for peripheral
 clk dt bindings
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375945839-9573-1-git-send-email-b.brezillon@overkiz.com> <52542878.5050503@atmel.com> <52542C4C.5080409@overkiz.com>
In-Reply-To: <52542C4C.5080409@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 18:01, boris brezillon :
> On 08/10/2013 17:44, Nicolas Ferre wrote:
>> On 08/08/2013 09:10, Boris BREZILLON :
>>> This patch adds the peripheral divisors macros (for sam9x5 compatible
>>> IPs)
>>> which will be used by peripheral clk dt definitions.
>>
>> I am in favor for these definitions. So let's keep them (with raw
>> numbers toguether with these macros in documentation).
>
> I guess we should move them elsewhere if these are the only macros we keep.
>
> What about "include/dt-bindings/clk/at91sam9x5-periph.h" ?

Well, what about a more generic clk binding file for all at91-related 
definitions (if more come). We can still differentiate among devices 
into the file itself...

What do you think about:
include/dt-bindings/clk/at91.h
is it too generic?

BTW, I see the clk and clock directories. What is the difference?


>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> ---
>>>    .../clk/at91/at91sam9x5/clk-peripheral.h           |   15
>>> +++++++++++++++
>>>    1 file changed, 15 insertions(+)
>>>    create mode 100644
>>> include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>>>
>>> diff --git a/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>>> b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>>> new file mode 100644
>>> index 0000000..a6dd506
>>> --- /dev/null
>>> +++ b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>>> @@ -0,0 +1,15 @@
>>> +/*
>>> + * This header provides constants for AT91 peripheral clks.
>>> + *
>>> + * The constants defined in this header are being used in dts.
>>> + */
>>> +
>>> +#ifndef _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
>>> +#define _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
>>> +
>>> +#define AT91SAM9X5_PERIPH_CLK_DIV1    0
>>> +#define AT91SAM9X5_PERIPH_CLK_DIV2    1
>>> +#define AT91SAM9X5_PERIPH_CLK_DIV4    2
>>> +#define AT91SAM9X5_PERIPH_CLK_DIV8    3
>>> +
>>> +#endif
>>>
>>
>>
>
>
>


-- 
Nicolas Ferre
