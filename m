Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaDPFLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:11:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50477 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPFK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:10:58 -0400
X-AuditID: cbfee68f-b7f156d00000276c-32-534e10e0bbbf
Message-id: <534E10E4.9030006@samsung.com>
Date: Wed, 16 Apr 2014 14:11:00 +0900
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
 <534E0AA0.6010207@samsung.com> <534E0D35.4060506@samsung.com>
 <CAK9yfHzkiymhsB6gpZMXWnkvuBdMmujePHhSRTg9vAeo0Ug-Vg@mail.gmail.com>
In-reply-to: <CAK9yfHzkiymhsB6gpZMXWnkvuBdMmujePHhSRTg9vAeo0Ug-Vg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSqPtAwC/Y4OR0YYu7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxabH11gtFrYtYbGYd+Qdi8XlXXPYLGac38dksfT6RSaL
	CdPXsli8vTOdxaJ17xF2i5N/ehkt1s94zeIg6LFm3hpGj8t9vUweK5d/YfPYvELLY9OqTjaP
	O9f2AHlL6j36tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr48jCbywFm7QqfjxuZGpgXKrQxcjB
	ISFgInHtRU4XIyeQKSZx4d56ti5GLg4hgaWMEhsuP2aFSJhInL99gAUisYhRouvBB1YI5zWj
	xIIFk8CqeAW0JC6euMEEYrMIqEqceT8LLM4GFN//4gYbiC0qECaxcvoVFoh6QYkfk++B2SJA
	NS+7lzOBDGUW6GKVON3QCZYQFsiU+P59KyPEtvNMEl3T1oNN4hQIlljwawE7iM0soC4xad4i
	ZghbXmLzmrfMIA0SAls4JJpeXIc6SUDi2+RDLBBPy0psOsAM8ZukxMEVN1gmMIrNQnLULCRj
	ZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYAo4/e9Z/w7GuwesDzEmA62cyCwl
	mpwPTCF5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoHR7W2208XTfVztKSc7qhOMkmquLTT/sZnN8kfe4fsCW344lBxXuPFsb5Qdb7xC2PLZFx21
	N/idmNh2Y720ycz88wliOxj6yqo7yi+tdgvbue9yhu20CUd0ZqkG+M/fvqRCh7c66paPaMj/
	YwbzVkpLfj+wwmN2XB1zO+eRp6fUJz/3bmCUW5qvxFKckWioxVxUnAgA5KcVfxcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAd0HAn7BBse2c1jcfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLDY9vsZqsbBtCYvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2B8hbUu/Rt2UVo8fnTXIBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QL8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDOOLPzGUrBJq+LH40amBsalCl2MnBwSAiYS528fYIGwxSQu3FvP1sXIxSEksIhRouvBB1YI
	5zWjxIIFk1hBqngFtCQunrjBBGKzCKhKnHk/CyzOBhTf/+IGG4gtKhAmsXL6FRaIekGJH5Pv
	gdkiQDUvu5czgQxlFuhilTjd0AmWEBbIlPj+fSsjxLbzTBJd09aDTeIUCJZY8GsBO4jNLKAu
	MWneImYIW15i85q3zBMYBWYhWTILSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgSnmGdSOxhXNlgcYhTgYFTi4Z2R4xssxJpYVlyZe4hRgoNZSYT3yxegEG9KYmVValF+fFFp
	TmrxIcZkYBhMZJYSTc4Hpr+8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQW
	wWxh4uCUamAU/5Wc9kff3Xz6liv7a1U6jTqPL+P6ZZ7OMPm9KvvBMOmE/xFsi475ndig1f4w
	JCrS83173qGIOrUn0Svn3+/XkpZeeMQq6098apxMm43x55ID6+O+sXPt8oh+0n3/8L/++ceT
	d7bynnzrYtnDmLp5ixLjr4s2vdl1N98UCK5zmCjrdn++XrYSS3FGoqEWc1FxIgBrM+1ldQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/16/2014 02:04 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 16 April 2014 10:25, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Hi Sachin,
>>
>> On 04/16/2014 01:44 PM, Chanwoo Choi wrote:
>>> Hi Sachin,
>>>
>>> On 04/16/2014 12:48 PM, Sachin Kamat wrote:
>>>> Hi Chanwoo,
>>>>
>>>> On 14 April 2014 14:37, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>>> This patch control special clock for ADC in Exynos series's FSYS block.
>>>>> If special clock of ADC is registerd on clock list of common clk framework,
>>>>> Exynos ADC drvier have to control this clock.
>>>>>
>>>>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>>>>> - 'adc' clock: bus clock for ADC
>>>>>
>>>>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>>>>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>>>>>
>>>>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
>>>>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
>>>>> clock in FSYS_BLK.
>>>>>
>>>>> Cc: Jonathan Cameron <jic23@kernel.org>
>>>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>>>> Cc: Naveen Krishna Chatradhi
>>>>> Cc: linux-iio@vger.kernel.org
>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> ---
>>>>>  drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
>>>>>  1 file changed, 41 insertions(+), 13 deletions(-)
>>>>>
>>>>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>>>>> index d25b262..3c99243 100644
>>>>> --- a/drivers/iio/adc/exynos_adc.c
>>>>> +++ b/drivers/iio/adc/exynos_adc.c
>>>>> @@ -40,8 +40,9 @@
>>>>>  #include <linux/iio/driver.h>
>>>>>
>>>>>  enum adc_version {
>>>>> -       ADC_V1,
>>>>> -       ADC_V2
>>>>> +       ADC_V1 = 0x1,
>>>>> +       ADC_V2 = 0x2,
>>>>> +       ADC_V3 = (ADC_V1 | ADC_V2),
>>>>
>>>> Can't this be simply 0x3? Or is this not really a h/w version?
>>>
>>> Even thought ADC_V3 isn't h/w revision, ADC_V3 include all featues of ADC_V2
>>> and only one difference of clock(sclk_tsadc) from ADC_V2.
>>> I want to describethat ADC_V3 include ADC_V2 feature So, I add as following:
>>>       >> +       ADC_V3 = (ADC_V1 | ADC_V2),
>>>
>>>>
>>>>>  };
>>>>>
>>>>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>>>>> @@ -88,6 +89,7 @@ struct exynos_adc {
>>>>>         void __iomem            *regs;
>>>>>         void __iomem            *enable_reg;
>>>>>         struct clk              *clk;
>>>>> +       struct clk              *sclk;
>>>>>         unsigned int            irq;
>>>>>         struct regulator        *vdd;
>>>>>
>>>>> @@ -100,6 +102,7 @@ struct exynos_adc {
>>>>>  static const struct of_device_id exynos_adc_match[] = {
>>>>>         { .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>>>>         { .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>>>>> +       { .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>>>>>         {},
>>>>>  };
>>>>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>>>>> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>>>>         mutex_lock(&indio_dev->mlock);
>>>>>
>>>>>         /* Select the channel to be used and Trigger conversion */
>>>>> -       if (info->version == ADC_V2) {
>>>>> +       if (info->version & ADC_V2) {
>>>>
>>>> So, now this would be applicable for ADC_V3 too, right?
>>
>> ADC_V3 isn't h/w version. So, I think this code is proper instead of using ADC_V3 direclty.
>> I want to use ADC_V3 version on checking clock(sclk_tsadc).
> 
> OK. Just a readability concern. Probably a check something like
> (version >= ADC_V2) would
> have made it more explicit.

OK I'll modify it as your comment.
	(version >= ADC_V2)

> 
>>
>>>>
>>>>
>>>>>                 con2 = readl(ADC_V2_CON2(info->regs));
>>>>>                 con2 &= ~ADC_V2_CON2_ACH_MASK;
>>>>>                 con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>>>>> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>>>>>         info->value = readl(ADC_V1_DATX(info->regs)) &
>>>>>                                                 ADC_DATX_MASK;
>>>>>         /* clear irq */
>>>>> -       if (info->version == ADC_V2)
>>>>> +       if (info->version & ADC_V2)
>>>>>                 writel(1, ADC_V2_INT_ST(info->regs));
>>>>>         else
>>>>>                 writel(1, ADC_V1_INTCLR(info->regs));
>>>>> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>>>>>         return 0;
>>>>>  }
>>>>>
>>>>> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
>>>>> +{
>>>>> +       if (enable) {
>>>>> +               clk_prepare_enable(info->clk);
>>>>
>>>> This could fail. Is it OK without any checks?
>>>
>>> OK, I'll check return value.
>>
>> Do you want to check return value always?
> 
> It is a good practice to check the return values for errors. Having
> said that it depends on
> your s/w design and the h/w requirements. If proceeding with the error
> does not cause any
> functional issues, then it is OK to ignore them. However I would
> atleast prefer to print
> a warning/info about such failures.

OK, I'll fix it.

Thanks,
Chanwoo Choi

