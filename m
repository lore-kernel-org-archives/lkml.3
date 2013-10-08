Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3JHQCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:02:33 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:55449 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541Ab3JHQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:02:31 -0400
Message-ID: <52542C4C.5080409@overkiz.com>
Date: Tue, 08 Oct 2013 18:01:16 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v3 12/19] clk: at91: add peripheral clk macros for peripheral
 clk dt bindings
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375945839-9573-1-git-send-email-b.brezillon@overkiz.com> <52542878.5050503@atmel.com>
In-Reply-To: <52542878.5050503@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3203185235203356780
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 17:44, Nicolas Ferre wrote:
> On 08/08/2013 09:10, Boris BREZILLON :
>> This patch adds the peripheral divisors macros (for sam9x5 compatible 
>> IPs)
>> which will be used by peripheral clk dt definitions.
>
> I am in favor for these definitions. So let's keep them (with raw 
> numbers toguether with these macros in documentation).

I guess we should move them elsewhere if these are the only macros we keep.

What about "include/dt-bindings/clk/at91sam9x5-periph.h" ?
>
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   .../clk/at91/at91sam9x5/clk-peripheral.h           |   15 
>> +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>   create mode 100644 
>> include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>>
>> diff --git a/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h 
>> b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>> new file mode 100644
>> index 0000000..a6dd506
>> --- /dev/null
>> +++ b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>> @@ -0,0 +1,15 @@
>> +/*
>> + * This header provides constants for AT91 peripheral clks.
>> + *
>> + * The constants defined in this header are being used in dts.
>> + */
>> +
>> +#ifndef _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
>> +#define _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
>> +
>> +#define AT91SAM9X5_PERIPH_CLK_DIV1    0
>> +#define AT91SAM9X5_PERIPH_CLK_DIV2    1
>> +#define AT91SAM9X5_PERIPH_CLK_DIV4    2
>> +#define AT91SAM9X5_PERIPH_CLK_DIV8    3
>> +
>> +#endif
>>
>
>

