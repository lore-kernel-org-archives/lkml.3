Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaENNpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:45:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58721 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaENNpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:45:38 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-52-5373737ec47d
Message-id: <53737379.1060504@samsung.com>
Date: Wed, 14 May 2014 15:45:29 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ben-linux@fluff.org, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: Re: [PATCHv4 5/7] clk: samsung: exynos3250: Add clocks using common
 clock framework
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-6-git-send-email-cw00.choi@samsung.com>
 <535B004F.3090000@gmail.com> <537206BD.6020407@samsung.com>
 <5372483D.8080009@samsung.com> <537313F6.9010807@samsung.com>
In-reply-to: <537313F6.9010807@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHefcd9k0dfZtab1oJiyK0NCnhLUq6CPoKEkGC6qJabqnl1Pal
	ZqDNqakzdankFEnNQ7iWh2mgoikqWoYnpk7KJjXFFYrZJOdhVnNdePd7+P+ew8VDYUIL7kVF
	xTyQymPE0SLSBf+4NTBxLIVlw45vNAqQvaCfiwrquznI0OWHjCvzBCrvGyZQ/kIlgaw/07lo
	+EcdQAUzahxNrT8h0GBtFwflVkyQaEi5wEV68ySBDO1lJNKMvOOgzwY+sk9vkajGOMZBc+ox
	Eg0arSRSF7/BUUZnHxf1LmQS6MNmLkCzvcsE0hR+J1G/phogbfsmQJn2ThJ1thWCcz6M7oUO
	MOlpT0lmY70AMIa8XA5j11owpq30C5epe7VCMnptNslMT3aQTHP1Y2b8vZJg8lq0gLHqD4Ty
	r7uckUijoxKk8oDgWy6RTVYbNy4r5OFyUxZQgKyzKsCjIH0SGtWvMSfvhqOmBlIFXCghXQNg
	WqPqf2EF0KIq4jgsPu0LG/NnCQfj9CFo+5oKHEzSh6FV8Y108K5/jk5pxFWAojzpq9A8KnS2
	CqCt0IQ72IM+Akvs48AxH6PzuTBnbGk7cKdvQMuLMuBc/AfApfqq7YBH+8Hfv0a2j8Doo7Ar
	4znpZB/YrFvE1EBQumNJ6Q6tdIdWATAt8JTGh8extyNkgf6sWMbGx0T4h8fK9MD5HSutoKr/
	dA+gKSBy49u08jAhIU5gk2Q9AFKYyIM/IGPDhHyJOOmRVB57Ux4fLWV7AIfieSlAsDl7PjNb
	hue1xrsu8hLvBwiMvlaD8tKpFjRdrPFOSFytqPXxejvBDTqYI7uSrFPzAldDxSGMt6vi2b7F
	6c17a3dy59SDwqLLEpNuxvXa1EWzYWj/bEOwpNJSUp4idpN/EsRdcH95vpuqC0o4kWFKzljb
	W75nhddxV5Ta2+wpwtlIcaAvJmfFfwEgOglZ+wIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo

On 14.05.2014 08:57, Chanwoo Choi wrote:
> On 05/14/2014 01:28 AM, Tomasz Figa wrote:
>> On 13.05.2014 13:49, Chanwoo Choi wrote:
>>> On 04/26/2014 09:39 AM, Tomasz Figa wrote:
>>>> On 25.04.2014 03:16, Chanwoo Choi wrote:
>>>>> +    /* GATE_BLOCK */
>>>>> +    GATE(CLK_BLOCK_LCD, "block_lcd", "div_aclk_160", GATE_BLOCK, 4, 0, 0),
>>>>> +    GATE(CLK_BLOCK_G3D, "block_g3d", "div_aclk_200", GATE_BLOCK, 3, 0, 0),
>>>>
>>>> Are there only 2 gate block clocks? By the way, how are they going to be handled by respective drivers? There is no mainline support for them right now, but you should be aware that adding them will cause common clock framework to disable them if not claimed by any driver.
>>>
>>> OK, I'll add remaing clock gate of GATE_BLOCK as following.
>>> - CLK_BLOCK_MFC MFC_BLK
>>> - CLK_BLOCK_CAM CAM_BLK
>>>
>>
>> I agree that in the end the block gates will have to be added. However
>> currently drivers do not request block gates and enable them.
>> Considering that common clock framework disables all unused clocks by
>> default, this will lead to all the gate block clocks being disabled,
>> which is not desired.
> 
> You're right.
> 
>>
>> My opinion on this is that block gate clocks should be added in separate
>> patch along with patches adding code to get and enable them.
> 
> OK, I'll remove the clocks of GATE_BLOCK on next posting(v6)
> 

OK, thanks.

By the way, if there are no other comments to v5 series than to this
patch, then you can simply send v6 of this single patch as a reply to v5.

>>
>>>>
>>>>> +};
>>>>> +
>>>>> +/* APLL & MPLL & BPLL & UPLL */
>>>>> +static struct samsung_pll_rate_table exynos3250_pll_rates[] = {
>>>>> +    PLL_35XX_RATE(1200000000, 400, 4, 1),
>>>>> +    PLL_35XX_RATE(1100000000, 275, 3, 1),
>>>>> +    PLL_35XX_RATE(1066000000, 533, 6, 1),
>>>>> +    PLL_35XX_RATE(1000000000, 250, 3, 1),
>>>>> +    PLL_35XX_RATE( 960000000, 320, 4, 1),
>>>>> +    PLL_35XX_RATE( 900000000, 300, 4, 1),
>>>>> +    PLL_35XX_RATE( 850000000, 425, 6, 1),
>>>>> +    PLL_35XX_RATE( 800000000, 200, 3, 1),
>>>>> +    PLL_35XX_RATE( 700000000, 175, 3, 1),
>>>>> +    PLL_35XX_RATE( 667000000, 667, 12, 1),
>>>>> +    PLL_35XX_RATE( 600000000, 400, 4, 2),
>>>>> +    PLL_35XX_RATE( 533000000, 533, 6, 2),
>>>>> +    PLL_35XX_RATE( 520000000, 260, 3, 2),
>>>>> +    PLL_35XX_RATE( 500000000, 250, 3, 2),
>>>>> +    PLL_35XX_RATE( 400000000, 200, 3, 2),
>>>>> +    PLL_35XX_RATE( 200000000, 200, 3, 3),
>>>>> +    PLL_35XX_RATE( 100000000, 200, 3, 4),
>>>>> +    { /* sentinel */ }
>>>>> +};
>>>>> +
>>>>> +/* VPLL */
>>>>> +static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
>>>>> +    PLL_36XX_RATE(600000000, 100, 2, 1,     0),
>>>>> +    PLL_36XX_RATE(533000000, 267, 3, 2, 32668),
>>
>> The TRM actually lists this as 267, 3, 2, 32768, and according to the
>> equation it will be 535000015 Hz. Looks like a typo in the data sheet,
>> as 266, 3, 2, 32768 gives 533000015, which is almost exactly 533 MHz.
>>
>>>>> +    PLL_36XX_RATE(519231000, 173, 2, 2,  5046),
>>
>> 519230991
>>
>>>>> +    PLL_36XX_RATE(500000000, 250, 3, 2,     0),
>>>>> +    PLL_36XX_RATE(445500000, 149, 2, 2, 32768),
>>
>> 448500022
>>
>> Also looks like a typo in the TRM, as 148, 2, 2, 32768 gives 445500022,
>> which is almost exactly 445.5 MHz.
>>
>>
>>>>> +    PLL_36XX_RATE(445055000, 148, 2, 2, 23047),
>>
>> 445055024
>>
>>>>> +    PLL_36XX_RATE(400000000, 200, 3, 2,     0),
>>>>> +    PLL_36XX_RATE(371250000, 124, 2, 2, 49512),
>>
>> The TRM lists this as 124, 2, 2, 49152 and calculated frequency is
>> 374250034. This one also looks like a typo. 123, 2, 2, 49512 would give
>> 371250034.
> 
> When I calculated fout with following data:
> - 124, 2, 2, 49512 would give 374266514.1
> - 123, 2, 2, 49512 would give 371266514.1.
> 
> I think below value is proper. 
> - 123, 2, 2, 49512 would give 371266514.1.
> 

Sorry, my bad, I made a typo as well ;). It should be 123, 2, 2, 49152.
The value I got was correct - 371250034.

>>
>>>>> +    PLL_36XX_RATE(370879000, 185, 3, 2, 28803),
>>
>> 370879011
>>
>>>>> +    PLL_36XX_RATE(340000000, 170, 3, 2,     0),
>>>>> +    PLL_36XX_RATE(335000000, 112, 2, 2, 43691),
>>
>> 338000045
>>
>> 111, 2, 2, 43691 would give 335000045. A typo in TRM?
>>
>>>>> +    PLL_36XX_RATE(333000000, 111, 2, 2,     0),
>>>>> +    PLL_36XX_RATE(330000000, 110, 2, 2,     0),
>>>>> +    PLL_36XX_RATE(320000000, 107, 2, 2, 43691),
>>
>> 323000045
>>
>> 106, 2, 2, 43691 would give 320000045.
>>
>>>>> +    PLL_36XX_RATE(300000000, 100, 2, 2,     0),
>>>>> +    PLL_36XX_RATE(275000000, 275, 3, 3,     0),
>>>>> +    PLL_36XX_RATE(222750000, 149, 2, 3, 32768),
>>
>> 224250011
>>
>> 148, 2, 3, 32768 would give 222750011.
>>
>>>>> +    PLL_36XX_RATE(222528000, 148, 2, 3, 23069),
>>
>> 222528015
>>
>>>>> +    PLL_36XX_RATE(160000000, 160, 3, 3,     0),
>>>>> +    PLL_36XX_RATE(148500000,  99, 2, 3,     0),
>>>>> +    PLL_36XX_RATE(148352000,  99, 2, 3, 59070),
>>
>> 149852025
>>
>> 98, 2, 3, 59070 would give 148352025.
>>
>>>>> +    PLL_36XX_RATE(108000000, 144, 2, 4,     0),
>>>>> +    PLL_36XX_RATE( 74250000,  99, 2, 4,     0),
>>>>> +    PLL_36XX_RATE( 74176000,  99, 3, 4, 59070),
>>
>> The TRM seems to list this as 99, 2, 4 and calculated frequency will be
>> 74926012, but 98, 2, 4, 59070 would give 74176012.
>>
>>>>> +    PLL_36XX_RATE( 54054000, 216, 3, 5, 14156),
>>
>> 54054001
>>
>>>>> +    PLL_36XX_RATE( 54000000, 144, 2, 5,     0),
>>>>
>>>> Are all these frequencies above calculated exactly? For correct operation of rate setting code, it is necessary for frequency values specified in these arrays to be exact, not rounded.
>>>
>>> When I implemnted exynos3250_vpll_rates array, I used 'VPLL PMS Value' in Exynos3250 TRM without modification.
>>> This rate value of exynos3250_vpll_rates is correct.
>>
>> Well, after checking the values using PLL equation for VPLL, as
>> specified in TRM and used by clk-pll.c, the values don't match.
>>
>> Keep in mind that the values must be exact, _not_ rounded, while in the
>> TRM they are rounded. Moreover it looks like several frequencies in TRM
>> are off by 1 in M coefficient. Please see above.
> 
> Thanks for your point out.
> 
> So, I calculated fout of VPLL using PLL equation in Exynos3250 TRM.
> 
> Following table show fout(Recalc rate) with fin_pll/mdiv/pdiv/sdiv/kdiv:
> fin_pll		Recalc rate	TRM rate	mdiv	pdiv	sdiv	kdiv
> 24000000	600000000	600000000	100	2	1	0
> 24000000	533000015.3	533000000	266	3	2	32768
> 24000000	519230991.1	519231000	173	2	2	5046
> 24000000	500000000	500000000	250	3	2	0
> 24000000	445500022.9	445500000	148	2	2	32768
> 24000000	445055024	445055000	148	2	2	23047
> 24000000	400000000	400000000	200	3	2	0
> 24000000	371266514.1	371250000	123	2	2	49512
> 24000000	370879011.2	370879000	185	3	2	28803
> 24000000	340000000	340000000	170	3	2	0
> 24000000	335000045.8	335000000	111	2	2	43691
> 24000000	333000000	333000000	111	2	2	0
> 24000000	330000000	330000000	110	2	2	0
> 24000000	320000045.8	320000000	106	2	2	43691
> 24000000	300000000	300000000	100	2	2	0
> 24000000	275000000	275000000	275	3	3	0
> 24000000	222750011.4	222750000	148	2	3	32768
> 24000000	222528015.6	222528000	148	2	3	23069
> 24000000	160000000	160000000	160	3	3	0
> 24000000	148500000	148500000	99	2	3	0
> 24000000	148352025.6	148352000	98	2	3	59070
> 24000000	108000000	108000000	144	2	4	0
> 24000000	74250000	74250000	99	2	4	0
> 24000000	74176012.82	74176000	98	2	4	59070
> 24000000	54054001.68	54054000	216	3	5	14156
> 24000000	54000000	54000000	144	2	5	0
> 
> 
> If you ok, I'll modify vpll_rates table as following:
> +static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
> +	PLL_36XX_RATE(600000000, 100, 2, 1,     0),
> +	PLL_36XX_RATE(533000000, 266, 3, 2, 32768),

According to the table above, shouldn't it be 533000015?

> +	PLL_36XX_RATE(519230991, 173, 2, 2,  5046),
> +	PLL_36XX_RATE(500000000, 250, 3, 2,     0),
> +	PLL_36XX_RATE(445500022, 148, 2, 2, 32768),
> +	PLL_36XX_RATE(445055024, 148, 2, 2, 23047),
> +	PLL_36XX_RATE(400000000, 200, 3, 2,     0),
> +	PLL_36XX_RATE(371266514, 123, 2, 2, 49512),
> +	PLL_36XX_RATE(370879011, 185, 3, 2, 28803),
> +	PLL_36XX_RATE(340000000, 170, 3, 2,     0),
> +	PLL_36XX_RATE(335000045, 111, 2, 2, 43691),
> +	PLL_36XX_RATE(333000000, 111, 2, 2,     0),
> +	PLL_36XX_RATE(330000000, 110, 2, 2,     0),
> +	PLL_36XX_RATE(320000045, 106, 2, 2, 43691),
> +	PLL_36XX_RATE(300000000, 100, 2, 2,     0),
> +	PLL_36XX_RATE(275000000, 275, 3, 3,     0),
> +	PLL_36XX_RATE(222750011, 148, 2, 3, 32768),
> +	PLL_36XX_RATE(222528015, 148, 2, 3, 23069),
> +	PLL_36XX_RATE(160000000, 160, 3, 3,     0),
> +	PLL_36XX_RATE(148500000,  99, 2, 3,     0),
> +	PLL_36XX_RATE(148352025,  98, 2, 3, 59070),
> +	PLL_36XX_RATE(108000000, 144, 2, 4,     0),
> +	PLL_36XX_RATE( 74250000,  99, 2, 4,     0),
> +	PLL_36XX_RATE( 74176012,  98, 2, 4, 59070),
> +	PLL_36XX_RATE( 54054012, 216, 3, 5, 14156),
> +	PLL_36XX_RATE( 54000000, 144, 2, 5,     0),
> +	{ /* sentinel */ }
> +};

There is one more thing, I found when analyzing this. clk-pll.c actually
uses 65536 (actually shift by 16) instead of 65535 in the equation given
in TRM and this gives better values. See samsung_pll36xx_recalc_rate().

By using script

>>> fin = 24000000
>>> def pll(m,p,s,k):
...     print (fin * (m * 65536 + k)) / (65536 * p * 2**s)
...

I'm getting better values, e.g.

>>> pll(266, 3, 2, 32768)
533000000

>>> pll(123, 2, 2, 49152)
371250000

Considering the fact that for PLL36xx Exynos5250 TRM uses 65536 as well,
this is probably the right equation. So please recalculate the values
again using:

FOUT = (MDIV + K/65536) x FIN/(PDIV x 2^SDIV)

or just my script above run in Python 2.x interpreter.

Best regards,
Tomasz
