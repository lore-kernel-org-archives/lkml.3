Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaFTAW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:22:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20562 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaFTAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:22:53 -0400
X-AuditID: cbfee690-b7fb56d000003439-82-53a37eda58fd
Message-id: <53A37EDA.2030403@samsung.com>
Date: Fri, 20 Jun 2014 09:22:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-3-git-send-email-cw00.choi@samsung.com>
 <53A146A8.7050501@gmail.com>
In-reply-to: <53A146A8.7050501@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSpHu7bnGwwZljzBZ3nx9mtJh/5Byr
	Rf+bhawW516tZLR40LSKyaJ3wVU2i4VtS1gs5h15x2JxedccNosZ5/cxWSy9fpHJYsL0tSwW
	b+9MZ7Fo3XuE3eLkn15Gi/UzXrNYrNr1h9FB0GPNvDWMHpf7epk8ds66y+6xcvkXNo/NK7Q8
	Nq3qZPO4c20Pm0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBlXD19lqngj3rFs6eHmRsYZyl0
	MXJwSAiYSNzewtvFyAlkiklcuLeerYuRi0NIYCmjxNkrC5khEiYSF9ceZoJILGKU6Fv0Hsp5
	zSix+NAssCpeAS2JeTe7wWwWAVWJ1Vv7WUBsNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8wW
	EVCX+Dalnx3EZhaYxizRMssHxBYWyJRY9249E4gtJLCAUWLKJQUQm1NAU+LInI+MEPU6Evtb
	p7FB2PISm9e8ZQY5TkJgB4fEjI6L7BAHCUh8m3yIBeJlWYlNB6A+k5Q4uOIGywRGsVlITpqF
	ZOwsJGMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAhMAKf/PZuwg/HeAetDjMlAKycy
	S4km5wMTSF5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MOYfLbddFLSzktf4+ySWXxz7zq6YM6V6iVhz19v851+3V/4Ib9F3Wlo05Y7aEUnBzSbd
	ezXOtNeFtJTdqfQIu3Hsq0+c1P7VPdu5YxqYtu1o5MxZHLF324t2sabwhI28l7c++CW4dlnz
	LAWF4J+mUwxku+rEIy0nHlmTuU0+5arv9ecWp78ozVJiKc5INNRiLipOBAC4uCdfFgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd1bdYuDDTa2mFncfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLBa2LWGxmHfkHYvF5V1z2CxmnN/HZLH0+kUmiwnT17JY
	vL0zncWide8RdouTf3oZLdbPeM1isWrXH0YHQY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2r9Dy
	2LSqk83jzrU9bB59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkD9IySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMePq6bNMBX/UK549PczcwDhLoYuRk0NCwETi4trDTBC2mMSFe+vZuhi5OIQEFjFK9C16
	zwThvGaUWHxoFjNIFa+AlsS8m91gNouAqsTqrf0sIDYbUHz/ixtsILaoQJjEyulXWCDqBSV+
	TL4HZosIqEt8m9LPDmIzC0xjlmiZ5QNiCwtkSqx7tx7sCiGBBYwSUy6BXccpoClxZM5HRoh6
	HYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRnGCeSe1gXNlgcYhRgINRiYe3w3RxsBBrYllxZe4hRgkOZiUR3upYoBBvSmJlVWpRfnxR
	aU5q8SHGZGAITGSWEk3OBya/vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphak
	FsFsYeLglGpgnDF3rs35rPlPJ0+5/Gtzzt6g5w5vw2PO506KDJd996fmJOdKAcV+Z/GGyZxh
	J1k7916J1dxf7r9d90Gmod6Zl5MOxbwrqtS0E9jXZ3rJY07NhR1fhbyWbGTxKjB99u7OjP2z
	/3h8PPHB4ehKlaDpU5qS6suCLxaeuB2rNPXatmvVtzO3BXAGvFNiKc5INNRiLipOBADqYLh0
	dAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/18/2014 04:58 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 18.06.2014 04:20, Chanwoo Choi wrote:
>> This patch control special clock for ADC in Exynos series's FSYS block.
>> If special clock of ADC is registerd on clock list of common clk framework,
>> Exynos ADC drvier have to control this clock.
>>
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>>
>> Exynos3250 has additional 'sclk_adc' clock as following:
>> - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC
>>
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_adc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_adc'
>> clock in FSYS_BLK.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 93 ++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 81 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index c30def6..6b026ac 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -41,7 +41,8 @@
>>  
>>  enum adc_version {
>>  	ADC_V1,
>> -	ADC_V2
>> +	ADC_V2,
>> +	ADC_V2_EXYNOS3250,
>>  };
>>  
>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>> @@ -85,9 +86,11 @@ enum adc_version {
>>  #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
>>  
>>  struct exynos_adc {
>> +	struct device		*dev;
>>  	void __iomem		*regs;
>>  	void __iomem		*enable_reg;
>>  	struct clk		*clk;
>> +	struct clk		*sclk;
>>  	unsigned int		irq;
>>  	struct regulator	*vdd;
>>  	struct exynos_adc_ops	*ops;
>> @@ -96,6 +99,7 @@ struct exynos_adc {
>>  
>>  	u32			value;
>>  	unsigned int            version;
>> +	bool			needs_sclk;
> 
> This should be rather a part of the variant struct. See my comments to
> patch 1/4.

OK, I'll include 'needs_sclk' in "variant" structure.

> 
>>  };
>>  
>>  struct exynos_adc_ops {
>> @@ -103,11 +107,21 @@ struct exynos_adc_ops {
>>  	void (*clear_irq)(struct exynos_adc *info);
>>  	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
>>  	void (*stop_conv)(struct exynos_adc *info);
>> +	void (*disable_clk)(struct exynos_adc *info);
>> +	int (*enable_clk)(struct exynos_adc *info);
>>  };
>>  
>>  static const struct of_device_id exynos_adc_match[] = {
>> -	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>> -	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>> +	{
>> +		.compatible = "samsung,exynos-adc-v1",
>> +		.data = (void *)ADC_V1,
>> +	}, {
>> +		.compatible = "samsung,exynos-adc-v2",
>> +		.data = (void *)ADC_V2,
>> +	}, {
>> +		.compatible = "samsung,exynos3250-adc-v2",
>> +		.data = (void *)ADC_V2_EXYNOS3250,
>> +	},
>>  	{},
>>  };
>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>> @@ -156,11 +170,42 @@ static void exynos_adc_v1_stop_conv(struct exynos_adc *info)
>>  	writel(con, ADC_V1_CON(info->regs));
>>  }
>>  
>> +static void exynos_adc_disable_clk(struct exynos_adc *info)
>> +{
>> +	if (info->needs_sclk)
>> +		clk_disable_unprepare(info->sclk);
>> +	clk_disable_unprepare(info->clk);
>> +}
>> +
>> +static int exynos_adc_enable_clk(struct exynos_adc *info)
>> +{
>> +	int ret;
>> +
>> +	ret = clk_prepare_enable(info->clk);
>> +	if (ret) {
>> +		dev_err(info->dev, "failed enabling adc clock: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	if (info->needs_sclk) {
>> +		ret = clk_prepare_enable(info->sclk);
>> +		if (ret) {
>> +			clk_disable_unprepare(info->clk);
>> +			dev_err(info->dev,
>> +				"failed enabling sclk_tsadc clock: %d\n", ret);
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static struct exynos_adc_ops exynos_adc_v1_ops = {
>>  	.init_hw	= exynos_adc_v1_init_hw,
>>  	.clear_irq	= exynos_adc_v1_clear_irq,
>>  	.start_conv	= exynos_adc_v1_start_conv,
>>  	.stop_conv	= exynos_adc_v1_stop_conv,
>> +	.disable_clk	= exynos_adc_disable_clk,
>> +	.enable_clk	= exynos_adc_enable_clk,
>>  };
>>  
>>  static void exynos_adc_v2_init_hw(struct exynos_adc *info)
>> @@ -210,6 +255,8 @@ static struct exynos_adc_ops exynos_adc_v2_ops = {
>>  	.start_conv	= exynos_adc_v2_start_conv,
>>  	.clear_irq	= exynos_adc_v2_clear_irq,
>>  	.stop_conv	= exynos_adc_v2_stop_conv,
>> +	.disable_clk	= exynos_adc_disable_clk,
>> +	.enable_clk	= exynos_adc_enable_clk,
> 
> Based on the fact that all variants use the same function, I don't think
> there is a reason to add .{disable,enable}_clk in the ops struct. If
> they diverge in future, they could be added later, but right now it
> doesn't have any value.

OK, I'll not add .{disable,enable}_clk and then just use following functions for clock control:
- exynos_adc_prepare_clk() : once execute this function in _probe()
- exynos_adc_unprepare_clk() : once execute this function in _remove()
- exynos_adc_enable_clk()
- exynos_adc_disable_clk()

Best Regards,
Chanwoo Choi

