Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaDPEoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:44:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44089 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaDPEoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:44:14 -0400
X-AuditID: cbfee68f-b7f156d00000276c-ff-534e0a9c7176
Message-id: <534E0AA0.6010207@samsung.com>
Date: Wed, 16 Apr 2014 13:44:16 +0900
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
In-reply-to: <CAK9yfHzdPu67JKrww-VFjFvKni7S_y_hvLKKUdeQe-_pxjoBAQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSrDuHyy/Y4OVdXYu7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxabH11gtFrYtYbGYd+Qdi8XlXXPYLGac38dksfT6RSaL
	CdPXsli8vTOdxaJ17xF2i5N/ehkt1s94zeIg6LFm3hpGj8t9vUweK5d/YfPYvELLY9OqTjaP
	O9f2AHlL6j36tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr49mVBawFG/Qq1i68z9bA2KzYxcjJ
	ISFgIrHn1D8WCFtM4sK99WxdjFwcQgJLGSV2vj7CCFO0/F0HWJGQwHRGiafvTCGKXjNKPNqy
	lRkkwSugJXH85RsmEJtFQFWi6f88sDgbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosA1bzs
	Xs4EMpRZoItV4nRDJ1hCWCBT4vv3rYwQ204wSlxZ8JC9i5GDg1MgWKL3TyJIDbOAusSkeYuY
	IWx5ic1r3jKD1EsIbOGQ2HT6OCvERQIS3yYfYgHplRCQldh0gBniM0mJgytusExgFJuF5KZZ
	SMbOQjJ2ASPzKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzABHD637P+HYx3D1gfYkwGWjmR
	WUo0OR+YQPJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA6PK6q/hD44H2WrEvFt2q/zjduVX/b/Mn/6w9/ItfxjxJ7xjdaJMlPysD8fWPZQLv72x
	NOdfotHim/+P5lvG3pFss+M83ay9LNWw0e7Yrvecy2dpLzk5q+O71ISpR828E1b8vSP4zvPZ
	9N5Ts0x8E1I0v8cHTkp4L/Phe5/Q/qMv5SbdEIxoWNShxFKckWioxVxUnAgArrZ4ghYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jQd05XH7BBg2TlS3uPj/MaDH/yDlW
	i/43C1ktzr1ayWjxoGkVk0XvgqtsFpseX2O1WNi2hMVi3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbA+Qtqffo27KK0ePzJrkAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoF+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBnPrixgLdigV7F24X22BsZmxS5GTg4JAROJ5e86WCBsMYkL99azgdhCAtMZJZ6+M+1i5AKy
	XzNKPNqylRkkwSugJXH85RsmEJtFQFWi6f88sDgbUHz/ixtgzaICYRIrp19hgagXlPgx+R6Y
	LQJU87J7ORPIUGaBLlaJ0w2dYAlhgUyJ79+3MkJsO8EocWXBQ/YuRg4OToFgid4/iSA1zALq
	EpPmLWKGsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZwenkmvYNxVYPFIUYBDkYlHt6ZOb7BQqyJZcWVuYcYJTiYlUR4v3wBCvGmJFZWpRblxxeV
	5qQWH2JMBgbBRGYp0eR8YOrLK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFq
	EcwWJg5OqQZG/TW/knWz/nt/cH7xWTZPxPbI7/LwD7ITdc8kPpVTUlG5zvm02z7e767Tp8TT
	Ww9kv+eezn1/iszKiTK+u+b5TljDuLf2WZTyF42IJ1tT1rzZE/nTWeZPXlV0rWFNStF7I6n3
	dlKZavJe/Iq77pwJ3fzq+fPOTzyOMht3ZPVznznFk/RWS2qrEktxRqKhFnNRcSIA0SqLHHMD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/16/2014 12:48 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 14 April 2014 14:37, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch control special clock for ADC in Exynos series's FSYS block.
>> If special clock of ADC is registerd on clock list of common clk framework,
>> Exynos ADC drvier have to control this clock.
>>
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>>
>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>>
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
>> clock in FSYS_BLK.
>>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Naveen Krishna Chatradhi
>> Cc: linux-iio@vger.kernel.org
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 41 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index d25b262..3c99243 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -40,8 +40,9 @@
>>  #include <linux/iio/driver.h>
>>
>>  enum adc_version {
>> -       ADC_V1,
>> -       ADC_V2
>> +       ADC_V1 = 0x1,
>> +       ADC_V2 = 0x2,
>> +       ADC_V3 = (ADC_V1 | ADC_V2),
> 
> Can't this be simply 0x3? Or is this not really a h/w version?

Even thought ADC_V3 isn't h/w revision, ADC_V3 include all featues of ADC_V2
and only one difference of clock(sclk_tsadc) from ADC_V2.
I want to describethat ADC_V3 include ADC_V2 feature So, I add as following:
	>> +       ADC_V3 = (ADC_V1 | ADC_V2),

> 
>>  };
>>
>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>> @@ -88,6 +89,7 @@ struct exynos_adc {
>>         void __iomem            *regs;
>>         void __iomem            *enable_reg;
>>         struct clk              *clk;
>> +       struct clk              *sclk;
>>         unsigned int            irq;
>>         struct regulator        *vdd;
>>
>> @@ -100,6 +102,7 @@ struct exynos_adc {
>>  static const struct of_device_id exynos_adc_match[] = {
>>         { .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>         { .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>> +       { .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>>         {},
>>  };
>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>         mutex_lock(&indio_dev->mlock);
>>
>>         /* Select the channel to be used and Trigger conversion */
>> -       if (info->version == ADC_V2) {
>> +       if (info->version & ADC_V2) {
> 
> So, now this would be applicable for ADC_V3 too, right?
> 
> 
>>                 con2 = readl(ADC_V2_CON2(info->regs));
>>                 con2 &= ~ADC_V2_CON2_ACH_MASK;
>>                 con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>>         info->value = readl(ADC_V1_DATX(info->regs)) &
>>                                                 ADC_DATX_MASK;
>>         /* clear irq */
>> -       if (info->version == ADC_V2)
>> +       if (info->version & ADC_V2)
>>                 writel(1, ADC_V2_INT_ST(info->regs));
>>         else
>>                 writel(1, ADC_V1_INTCLR(info->regs));
>> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>>         return 0;
>>  }
>>
>> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
>> +{
>> +       if (enable) {
>> +               clk_prepare_enable(info->clk);
> 
> This could fail. Is it OK without any checks?

OK, I'll check return value.
> 
>> +               if (info->version == ADC_V3)
>> +                       clk_prepare_enable(info->sclk);
> 
> ditto.

ditto.

> 
>> +
>> +       } else {
>> +               if (info->version == ADC_V3)
>> +                       clk_disable_unprepare(info->sclk);
>> +               clk_disable_unprepare(info->clk);
>> +       }
>> +}
>> +
>>  static void exynos_adc_hw_init(struct exynos_adc *info)
>>  {
>>         u32 con1, con2;
>>
>> -       if (info->version == ADC_V2) {
>> +       if (info->version & ADC_V2) {
>>                 con1 = ADC_V2_CON1_SOFT_RESET;
>>                 writel(con1, ADC_V2_CON1(info->regs));
>>
>> @@ -300,6 +317,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>
>>         writel(1, info->enable_reg);
>>
>> +       info->version = exynos_adc_get_version(pdev);
>> +
>>         info->clk = devm_clk_get(&pdev->dev, "adc");
>>         if (IS_ERR(info->clk)) {
>>                 dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>> @@ -308,6 +327,17 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>                 goto err_irq;
>>         }
>>
>> +       if (info->version == ADC_V3) {
>> +               info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
>> +               if (IS_ERR(info->sclk)) {
>> +                       dev_warn(&pdev->dev,
>> +                               "failed getting sclk clock, err = %ld\n",
>> +                               PTR_ERR(info->sclk));
>> +                       ret = PTR_ERR(info->sclk);
> 
> nit: you could move this line above dev_warn and use 'ret' in the print
> statement.

As I knew, usually show log meesage and then initialize return value.
But If you find this code ugly, I can fix it.

Thanks for your review.

Best Regards,
Chanwoo Choi


