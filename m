Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3JHMNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:13:48 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:48278 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755331Ab3JHMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:13:45 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 08:13:45 EDT
Message-ID: <5253F4AC.8050407@overkiz.com>
Date: Tue, 08 Oct 2013 14:03:56 +0200
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
Subject: Re: [PATCH v3 07/19] clk: at91: add pll id macros for pll dt bindings
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375942160-8881-1-git-send-email-b.brezillon@overkiz.com> <5253DEBD.7010904@atmel.com>
In-Reply-To: <5253DEBD.7010904@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17642007117299284076
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 12:30, Nicolas Ferre wrote:
> On 08/08/2013 08:09, Boris BREZILLON :
>> This patch adds the PLL id macros which will be used by pll dt 
>> definitions.
>
> It is not needed, drop it. Just document the values in the DT biding 
> and it will be fine.

I'll drop (and document) it.

>
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   include/dt-bindings/clk/at91/common/clk-pll.h |   13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>   create mode 100644 include/dt-bindings/clk/at91/common/clk-pll.h
>>
>> diff --git a/include/dt-bindings/clk/at91/common/clk-pll.h 
>> b/include/dt-bindings/clk/at91/common/clk-pll.h
>> new file mode 100644
>> index 0000000..93ec849
>> --- /dev/null
>> +++ b/include/dt-bindings/clk/at91/common/clk-pll.h
>> @@ -0,0 +1,13 @@
>> +/*
>> + * This header provides constants for AT91 pll ids.
>> + *
>> + * The constants defined in this header are being used in dts.
>> + */
>> +
>> +#ifndef _DT_BINDINGS_CLK_AT91_PLL_H
>> +#define _DT_BINDINGS_CLK_AT91_PLL_H
>> +
>> +#define AT91_PLLA_CLK        0    /* PLLA clk id */
>> +#define AT91_PLLB_CLK        1    /* PLLB clk id */
>> +
>> +#endif
>>
>
>

