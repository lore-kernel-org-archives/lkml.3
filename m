Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaFXA6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:58:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48157 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaFXA63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:58:29 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-84-53a8cd325436
Message-id: <53A8CD31.6090506@samsung.com>
Date: Tue, 24 Jun 2014 09:58:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, jic23@kernel.org,
        My self <ch.naveen@samsung.com>, t.figa@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-3-git-send-email-cw00.choi@samsung.com>
 <53A146A8.7050501@gmail.com> <53A37EDA.2030403@samsung.com>
 <53A37F34.1010808@gmail.com> <53A38016.1000308@samsung.com>
 <53A380AD.3090307@gmail.com>
 <CAHfPSqD73W7tdNxgmb4BaVCazYkuNY5Q87=dT7PtZTsPfqMx9g@mail.gmail.com>
In-reply-to: <CAHfPSqD73W7tdNxgmb4BaVCazYkuNY5Q87=dT7PtZTsPfqMx9g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSqGt0dkWwwfSdOhZ3nx9mtJh/5Byr
	Rf+bhawW516tZLR40LSKyaJ3wVU2i4VtS1gs5h15x2JxedccNosZ5/cxWSy9fpHJYtG2/8wW
	E6avZbF4e2c6i0Xr3iPsFif/9DJarJ/xmsVi1a4/jA5CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+w
	eWxeoeWxaVUnm8eda3vYPPq2rGL0+LxJLoAzissmJTUnsyy1SN8ugSvjxMkupoKd9hVz52Q0
	MP437GLk5JAQMJFo2vaSDcIWk7hwbz2QzcUhJLCUUWLOlhXsMEV/mm6yQySmM0r03V/BCuG8
	ZpRYMGsZK0gVr4CWxIcLX8BGsQioSpw6dh6smw0ovv/FDbC4qECYxMrpV1gg6gUlfky+B2aL
	CBhJzHywkBFkKLPAH2aJL9NWMoEkhAUyJda9W88Ese0xk8Sim5vAJnEKBEt8OrscbDOzgLrE
	pHmLmCFseYnNa94ygzRICOzhkPj5ah4zxEkCEt8mHwJaxwGUkJXYdIAZ4jdJiYMrbrBMYBSb
	heSoWUjGzkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwHRw+t+z3h2Mtw9YH2JM
	Blo5kVlKNDkfmE7ySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoGxMrVfpTC3OGtb3Kkw2a0ujdOETa8dbNE/EnL83Sm1rF9iO3RUV7T3bb//ff+6
	5VP0m6aY9n44FijI2T0vP1bu9rSsZVxr76Xlqzx+KsS7XJ6bJ6hgslLd7ObrSl27o0O559Wt
	ED+4QL3lzi0lk+jH6VHnfnv8eer39DZjqP1azWNiAle3R4opsRRnJBpqMRcVJwIA41uMfx0D	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV2jsyuCDZ42KlncfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLBa2LWGxmHfkHYvF5V1z2CxmnN/HZLH0+kUmi0Xb/jNb
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxaLVbv+MDoIeayZt4bR43JfL5PHzll32T1WLv/C
	5rF5hZbHplWdbB53ru1h8+jbsorR4/MmuQDOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zBygj5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhDWMGSdOdjEV7LSvmDsno4Hxv2EXIyeHhICJxJ+mm+wQtpjEhXvr2boYuTiEBKYz
	SvTdX8EK4bxmlFgwaxkrSBWvgJbEhwtf2EBsFgFViVPHzoN1swHF97+4ARYXFQiTWDn9CgtE
	vaDEj8n3wGwRASOJmQ8WMoIMZRb4wyzxZdpKJpCEsECmxLp365kgtj1mklh0cxPYJE6BYIlP
	Z5eDbWYWUJeYNG8RM4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgpPNM6kdjCsbLA4xCnAwKvHwMvivCBZiTSwrrsw9xCjBwawkwhu4ASjEm5JY
	WZValB9fVJqTWnyI0RQYBhOZpUST84GJMK8k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6Yklq
	dmpqQWoRTB8TB6dUA+OEqDei909N+vLMu6xIeWfyz7maPRPr1gTO8tjQMuGdcE7jnZzc1k2L
	ngaLSrx4e+3Vw9kad/5GS5/t26Kj1JPTVBjaGRs9I2F52aUz2vufVff2eTDMVpgcmvNe26q6
	jif3uu/+3YvSjmv2ts8N2CVouH3O7ObM1A0/3jwuWtKZ4yHEXHRCpEOJpTgj0VCLuag4EQDa
	6yL6TAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/20/2014 12:21 PM, Naveen Krishna Ch wrote:
> Hello Tomasz,
> 
> On 20 June 2014 06:00, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> On 20.06.2014 02:28, Chanwoo Choi wrote:
>>> On 06/20/2014 09:24 AM, Tomasz Figa wrote:
>>>> On 20.06.2014 02:22, Chanwoo Choi wrote:
>>>>> Hi Tomasz,
>>>>>
>>>>> On 06/18/2014 04:58 PM, Tomasz Figa wrote:
>>>>>> Hi Chanwoo,
>>>>>>
>>>>>> On 18.06.2014 04:20, Chanwoo Choi wrote:
>>>>>>> This patch control special clock for ADC in Exynos series's FSYS block.
>>>>>>> If special clock of ADC is registerd on clock list of common clk framework,
>>>>>>> Exynos ADC drvier have to control this clock.
>>>>>>>
>>>>>>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>>>>>>> - 'adc' clock: bus clock for ADC
>>>>>>>
>>>>>>> Exynos3250 has additional 'sclk_adc' clock as following:
>>>>>>> - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC
>>>>>>>
>>>>>>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_adc' clock
>>>>>>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_adc'
>>>>>>> clock in FSYS_BLK.
>>>>>>>
>>>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>>> ---
>>>>>>>  drivers/iio/adc/exynos_adc.c | 93 ++++++++++++++++++++++++++++++++++++++------
>>>>>>>  1 file changed, 81 insertions(+), 12 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>>>>>>> index c30def6..6b026ac 100644
>>>>>>> --- a/drivers/iio/adc/exynos_adc.c
>>>>>>> +++ b/drivers/iio/adc/exynos_adc.c
>>>>>>> @@ -41,7 +41,8 @@
>>>>>>>
>>>>>>>  enum adc_version {
>>>>>>>   ADC_V1,
>>>>>>> - ADC_V2
>>>>>>> + ADC_V2,
>>>>>>> + ADC_V2_EXYNOS3250,
>>>>>>>  };
>>>>>>>
>>>>>>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>>>>>>> @@ -85,9 +86,11 @@ enum adc_version {
>>>>>>>  #define EXYNOS_ADC_TIMEOUT       (msecs_to_jiffies(100))
>>>>>>>
>>>>>>>  struct exynos_adc {
>>>>>>> + struct device           *dev;
>>>>>>>   void __iomem            *regs;
>>>>>>>   void __iomem            *enable_reg;
>>>>>>>   struct clk              *clk;
>>>>>>> + struct clk              *sclk;
>>>>>>>   unsigned int            irq;
>>>>>>>   struct regulator        *vdd;
>>>>>>>   struct exynos_adc_ops   *ops;
>>>>>>> @@ -96,6 +99,7 @@ struct exynos_adc {
>>>>>>>
>>>>>>>   u32                     value;
>>>>>>>   unsigned int            version;
>>>>>>> + bool                    needs_sclk;
>>>>>>
>>>>>> This should be rather a part of the variant struct. See my comments to
>>>>>> patch 1/4.
>>>>>
>>>>> OK, I'll include 'needs_sclk' in "variant" structure.
>>>>>
>>>>>>
>>>>>>>  };
>>>>>>>
>>>>>>>  struct exynos_adc_ops {
>>>>>>> @@ -103,11 +107,21 @@ struct exynos_adc_ops {
>>>>>>>   void (*clear_irq)(struct exynos_adc *info);
>>>>>>>   void (*start_conv)(struct exynos_adc *info, unsigned long addr);
>>>>>>>   void (*stop_conv)(struct exynos_adc *info);
>>>>>>> + void (*disable_clk)(struct exynos_adc *info);
>>>>>>> + int (*enable_clk)(struct exynos_adc *info);
>>>>>>>  };
>>>>>>>
>>>>>>>  static const struct of_device_id exynos_adc_match[] = {
>>>>>>> - { .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>>>>>> - { .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>>>>>>> + {
>>>>>>> +         .compatible = "samsung,exynos-adc-v1",
>>>>>>> +         .data = (void *)ADC_V1,
>>>>>>> + }, {
>>>>>>> +         .compatible = "samsung,exynos-adc-v2",
>>>>>>> +         .data = (void *)ADC_V2,
>>>>>>> + }, {
>>>>>>> +         .compatible = "samsung,exynos3250-adc-v2",
>>>>>>> +         .data = (void *)ADC_V2_EXYNOS3250,
>>>>>>> + },
>>>>>>>   {},
>>>>>>>  };
>>>>>>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>>>>>>> @@ -156,11 +170,42 @@ static void exynos_adc_v1_stop_conv(struct exynos_adc *info)
>>>>>>>   writel(con, ADC_V1_CON(info->regs));
>>>>>>>  }
>>>>>>>
>>>>>>> +static void exynos_adc_disable_clk(struct exynos_adc *info)
>>>>>>> +{
>>>>>>> + if (info->needs_sclk)
>>>>>>> +         clk_disable_unprepare(info->sclk);
>>>>>>> + clk_disable_unprepare(info->clk);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int exynos_adc_enable_clk(struct exynos_adc *info)
>>>>>>> +{
>>>>>>> + int ret;
>>>>>>> +
>>>>>>> + ret = clk_prepare_enable(info->clk);
>>>>>>> + if (ret) {
>>>>>>> +         dev_err(info->dev, "failed enabling adc clock: %d\n", ret);
>>>>>>> +         return ret;
>>>>>>> + }
>>>>>>> +
>>>>>>> + if (info->needs_sclk) {
>>>>>>> +         ret = clk_prepare_enable(info->sclk);
>>>>>>> +         if (ret) {
>>>>>>> +                 clk_disable_unprepare(info->clk);
>>>>>>> +                 dev_err(info->dev,
>>>>>>> +                         "failed enabling sclk_tsadc clock: %d\n", ret);
>>>>>>> +         }
>>>>>>> + }
>>>>>>> +
>>>>>>> + return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>>  static struct exynos_adc_ops exynos_adc_v1_ops = {
>>>>>>>   .init_hw        = exynos_adc_v1_init_hw,
>>>>>>>   .clear_irq      = exynos_adc_v1_clear_irq,
>>>>>>>   .start_conv     = exynos_adc_v1_start_conv,
>>>>>>>   .stop_conv      = exynos_adc_v1_stop_conv,
>>>>>>> + .disable_clk    = exynos_adc_disable_clk,
>>>>>>> + .enable_clk     = exynos_adc_enable_clk,
>>>>>>>  };
>>>>>>>
>>>>>>>  static void exynos_adc_v2_init_hw(struct exynos_adc *info)
>>>>>>> @@ -210,6 +255,8 @@ static struct exynos_adc_ops exynos_adc_v2_ops = {
>>>>>>>   .start_conv     = exynos_adc_v2_start_conv,
>>>>>>>   .clear_irq      = exynos_adc_v2_clear_irq,
>>>>>>>   .stop_conv      = exynos_adc_v2_stop_conv,
>>>>>>> + .disable_clk    = exynos_adc_disable_clk,
>>>>>>> + .enable_clk     = exynos_adc_enable_clk,
>>>>>>
>>>>>> Based on the fact that all variants use the same function, I don't think
>>>>>> there is a reason to add .{disable,enable}_clk in the ops struct. If
>>>>>> they diverge in future, they could be added later, but right now it
>>>>>> doesn't have any value.
>>>>>
>>>>> OK, I'll not add .{disable,enable}_clk and then just use following functions for clock control:
>>>>> - exynos_adc_prepare_clk() : once execute this function in _probe()
>>>>> - exynos_adc_unprepare_clk() : once execute this function in _remove()
>>>>> - exynos_adc_enable_clk()
>>>>> - exynos_adc_disable_clk()
>>>>
>>>> Is there any need to separate prepare/unprepare from enable/disable?
>>>> Otherwise sounds good, thanks.
>>>
>>> Naveen Krishna Chatradhi want to execute once prepare/unpreare in probe/remove function.
>>>
>>> - Following comment of Naveen Krishna Chatradhi
>>>> +static void exynos_adc_disable_clk(struct exynos_adc *info)
>>>> +{
>>>> +       if (info->needs_sclk)
>>>> +               clk_disable_unprepare(info->sclk);
>>>> +       clk_disable_unprepare(info->clk);
>>>
>>> (Just a nit pick) As a part of cleanup can we also change to use
>>> clk_disable() here and clk_unprepare() once and for all at the end.
>>>
>>>> +}
>>>> +
>>>> +static int exynos_adc_enable_clk(struct exynos_adc *info)
>>>> +{
>>>> +       int ret;
>>>> +
>>>> +       ret = clk_prepare_enable(info->clk);
>>>> +       if (ret) {
>>>> +               dev_err(info->dev, "failed enabling adc clock: %d\n", ret);
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       if (info->needs_sclk) {
>>>> +               ret = clk_prepare_enable(info->sclk);
>>> Can we use clk_enable() here and clk_prepare() some where during the probe.
>>
>> I still don't see any reason to do it. Naveen, what's the motivation for
>> this change? For me, it only complicates the code, without any added value.
> 
> clk_prepare() and clk_unprepare() maintains the clk prepare count.
> Which we may not need for every transaction.
> 
> We just need to  clk_enable() and clk_disable() the clock carefully.
> 
> Thus, using clk_prepare() and clk_unprepare() once should reduce a set of
> instructions for every transaction. Right ?

Any other comment?

Best Regards,
Chanwoo Choi


