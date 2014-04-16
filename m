Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaDPEz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:55:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42790 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaDPEzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:55:25 -0400
X-AuditID: cbfee690-b7f266d00000287c-f5-534e0d320b67
Message-id: <534E0D35.4060506@samsung.com>
Date: Wed, 16 Apr 2014 13:55:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, rdunlap@infradead.org,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 1/2] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
 <1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHzdPu67JKrww-VFjFvKni7S_y_hvLKKUdeQe-_pxjoBAQ@mail.gmail.com>
 <534E0AA0.6010207@samsung.com>
In-reply-to: <534E0AA0.6010207@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSqGvE6xdssHGvqMXd54cZLeYfOcdq
	0f9mIavFuVcrGS0eNK1isuhdcJXNYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72OyWHr9IpPF
	hOlrWSze3pnOYtG69wi7xck/vYwW62e8ZnEQ9Fgzbw2jx+W+XiaPlcu/sHlsXqHlsWlVJ5vH
	nWt7gLwl9R59W1YxenzeJBfAGcVlk5Kak1mWWqRvl8CV8ej/J6aCXSoVB+fOZm1g3CLdxcjJ
	ISFgItHa9oIJwhaTuHBvPVsXIxeHkMBSRomrRw4xwxQt+febESIxnVFi0+tHrBDOa0aJtd9X
	sINU8QpoSbycuhOog4ODRUBV4vfDVJAwG1B4/4sbbCC2qECYxMrpV1ggygUlfky+B2aLgLR2
	L2cCmcks0MUqcbqhEywhLJAp8f37VqjNLxkluh91gyU4BbQlHu49DmYzC6hLTJq3iBnClpfY
	vOYtM0iDhMAWDom+ua/AnmMREJD4NvkQC8h1EgKyEpsOQL0mKXFwxQ2WCYxis5AcNQvJ2FlI
	xi5gZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZgCTv97NmEH470D1ocYk4FWTmSWEk3O
	B6aQvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg
	FO2qKahd/4qhLYObZx1H4axCcUbGR26K87J4WpzEe3/51/5gUPz88cQlm965ZyUVA8sfzGlu
	2OyU/UTi4ne7hGWHWfc8UZbeueGZy2aOlb/P3uVYbGy24PLhjf07Q3y3ebtsSpvGurfwjfNi
	lbOTmSKmMT+b8MHvzaED7z14112SP3R3EXtWrRJLcUaioRZzUXEiAGHGvVMXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV0jXr9gg3s3uSzuPj/MaDH/yDlW
	i/43C1ktzr1ayWjxoGkVk0XvgqtsFpseX2O1WNi2hMVi3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbA+Qtqffo27KK0ePzJrkAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoF+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBmP/n9iKtilUnFw7mzWBsYt0l2MnBwSAiYSS/79ZoSwxSQu3FvP1sXIxSEkMJ1RYtPrR6wQ
	zmtGibXfV7CDVPEKaEm8nLqTuYuRg4NFQFXi98NUkDAbUHj/ixtsILaoQJjEyulXWCDKBSV+
	TL4HZouAtHYvZwKZySzQxSpxuqETLCEskCnx/ftWRohlLxkluh91gyU4BbQlHu49DmYzC6hL
	TJq3iBnClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMEJ5pnUDsaVDRaHGAU4GJV4eGfk+AYLsSaWFVfmHmKU4GBWEuH98gUoxJuSWFmVWpQfX1Sa
	k1p8iDEZGAQTmaVEk/OByS+vJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2ampBalF
	MFuYODilGhin9d60OjS7YeLft8KROd6F7+dfMp0zeZb5Rwthu32tl//d9BJ8vbpDbOFyzuN5
	1sd+T7M1m3N5q+/F1K06UrMP7bk+MUt5a/ASSTP2w/VS83JWKGs8uL5X4JSyw5kdTq39arGP
	ekRd8iVknzmsauFkv1nB897S369a7vSTI1yqIvXfN3FsNDJQYinOSDTUYi4qTgQAuwx7rXQD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/16/2014 01:44 PM, Chanwoo Choi wrote:
> Hi Sachin,
> 
> On 04/16/2014 12:48 PM, Sachin Kamat wrote:
>> Hi Chanwoo,
>>
>> On 14 April 2014 14:37, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> This patch control special clock for ADC in Exynos series's FSYS block.
>>> If special clock of ADC is registerd on clock list of common clk framework,
>>> Exynos ADC drvier have to control this clock.
>>>
>>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>>> - 'adc' clock: bus clock for ADC
>>>
>>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>>>
>>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
>>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
>>> clock in FSYS_BLK.
>>>
>>> Cc: Jonathan Cameron <jic23@kernel.org>
>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>> Cc: Naveen Krishna Chatradhi
>>> Cc: linux-iio@vger.kernel.org
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
>>>  1 file changed, 41 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>>> index d25b262..3c99243 100644
>>> --- a/drivers/iio/adc/exynos_adc.c
>>> +++ b/drivers/iio/adc/exynos_adc.c
>>> @@ -40,8 +40,9 @@
>>>  #include <linux/iio/driver.h>
>>>
>>>  enum adc_version {
>>> -       ADC_V1,
>>> -       ADC_V2
>>> +       ADC_V1 = 0x1,
>>> +       ADC_V2 = 0x2,
>>> +       ADC_V3 = (ADC_V1 | ADC_V2),
>>
>> Can't this be simply 0x3? Or is this not really a h/w version?
> 
> Even thought ADC_V3 isn't h/w revision, ADC_V3 include all featues of ADC_V2
> and only one difference of clock(sclk_tsadc) from ADC_V2.
> I want to describethat ADC_V3 include ADC_V2 feature So, I add as following:
> 	>> +       ADC_V3 = (ADC_V1 | ADC_V2),
> 
>>
>>>  };
>>>
>>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>>> @@ -88,6 +89,7 @@ struct exynos_adc {
>>>         void __iomem            *regs;
>>>         void __iomem            *enable_reg;
>>>         struct clk              *clk;
>>> +       struct clk              *sclk;
>>>         unsigned int            irq;
>>>         struct regulator        *vdd;
>>>
>>> @@ -100,6 +102,7 @@ struct exynos_adc {
>>>  static const struct of_device_id exynos_adc_match[] = {
>>>         { .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>>         { .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>>> +       { .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>>>         {},
>>>  };
>>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>>> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>>         mutex_lock(&indio_dev->mlock);
>>>
>>>         /* Select the channel to be used and Trigger conversion */
>>> -       if (info->version == ADC_V2) {
>>> +       if (info->version & ADC_V2) {
>>
>> So, now this would be applicable for ADC_V3 too, right?

ADC_V3 isn't h/w version. So, I think this code is proper instead of using ADC_V3 direclty.
I want to use ADC_V3 version on checking clock(sclk_tsadc).

>>
>>
>>>                 con2 = readl(ADC_V2_CON2(info->regs));
>>>                 con2 &= ~ADC_V2_CON2_ACH_MASK;
>>>                 con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>>> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>>>         info->value = readl(ADC_V1_DATX(info->regs)) &
>>>                                                 ADC_DATX_MASK;
>>>         /* clear irq */
>>> -       if (info->version == ADC_V2)
>>> +       if (info->version & ADC_V2)
>>>                 writel(1, ADC_V2_INT_ST(info->regs));
>>>         else
>>>                 writel(1, ADC_V1_INTCLR(info->regs));
>>> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>>>         return 0;
>>>  }
>>>
>>> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
>>> +{
>>> +       if (enable) {
>>> +               clk_prepare_enable(info->clk);
>>
>> This could fail. Is it OK without any checks?
> 
> OK, I'll check return value.

Do you want to check return value always?
I think again, Some device drivers in mainline would not check
return value of clock function. If maintainer confirm this modification,
I'll fix it as your comment.

Best Regards,
Chanwoo Choi
