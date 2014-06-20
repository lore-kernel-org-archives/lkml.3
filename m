Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaFTAUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:20:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaFTAU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:20:28 -0400
X-AuditID: cbfee68f-b7fef6d000003970-69-53a37e446817
Message-id: <53A37E44.6040501@samsung.com>
Date: Fri, 20 Jun 2014 09:20:20 +0900
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
Subject: Re: [PATCHv4 1/4] iio: adc: exynos_adc: Add exynos_adc_ops structure
 to improve readability
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-2-git-send-email-cw00.choi@samsung.com>
 <53A145F7.8080000@gmail.com>
In-reply-to: <53A145F7.8080000@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42JZI2JSoOtStzjYYMNWK4u7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hkMWH6WhaL
	t3ems1i07j3CbnHyTy+jxfoZr1ksVu36w+gg6LFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoe
	m1Z1snncubaHzaNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyDk6YwFpw0q7i+J29bA2MP426
	GDk4JARMJA42lHYxcgKZYhIX7q1n62Lk4hASWMoosWffMkaYml+v/CDiixgl7sxYyQ7hvGaU
	+PD6EDtIEa+AlsSGXRwgg1gEVCV+fXjBDmKzAYX3v7jBBmKLCoRJrJx+hQXE5hUQlPgx+R6Y
	LSKgLvFtSj9YPbPANGaJllk+ILawQJrE/33XGEFsIYEFjBLzTuaB2JwCmhJb33exQNTrSOxv
	ncYGYctLbF7zlhnkNgmBPRwSv/8vZIM4SEDi2+RDLBDPyEpsOsAM8bCkxMEVN1gmMIrNQnLS
	LCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYPSf/vesfwfj3QPWhxiTgVZO
	ZJYSTc4HJo+8knhDYzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cC4//zmjWWbNOY1bPlYfNfkRKlwlE/FXZPO4279NxPm+7hNkDjBtjqvL/bPgozL6+xX
	SvUp1MRrrzewMtp++GzRkidiNyUW35904UrSm50uu1fL9+99u/y/iMbpTd4PSxweLs2LfX7y
	wdkXTmvYbT7HPMoTW24SMk35UIf8lj1/MhqZhNcrz8y9o8RSnJFoqMVcVJwIAJeNDcUUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV2XusXBBo8W61vcfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLBa2LWGxmHfkHYvF5V1z2CxmnN/HZLH0+kUmiwnT17JY
	vL0zncWide8RdouTf3oZLdbPeM1isWrXH0YHQY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2r9Dy
	2LSqk83jzrU9bB59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkD9IySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMePghAmsBSftKo7f2cvWwPjTqIuRg0NCwETi1yu/LkZOIFNM4sK99WxdjFwcQgKLGCXu
	zFjJDuG8ZpT48PoQO0gDr4CWxIZdHCANLAKqEr8+vGAHsdmAwvtf3GADsUUFwiRWTr/CAmLz
	CghK/Jh8D8wWEVCX+DalH6yeWWAas0TLLB8QW1ggTeL/vmuMILaQwAJGiXkn80BsTgFNia3v
	u1gg6nUk9rdOY4Ow5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnByeSa1g3Flg8UhRgEORiUe3g7TxcFCrIllxZW5hxglOJiVRHirY4FCvCmJlVWp
	RfnxRaU5qcWHGJOBITCRWUo0OR+Y+PJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgVE2dZq+wfLTbfH+0+8zxzJeFb6ie9Cd5+/n7zuPvfC6le7SkZnPWDfR
	Z8cDnYffjO32XXi8VyI39DafvnrOXlf+2Csfkkoj7G6rq2r6cgjMFqgSWFwV8WTHpfyEl0Ir
	bKc0hpsmzp3dvj8/v5jj1eSdNyaLK+9/8r9h2asuF9n5S3x0jz69UavEUpyRaKjFXFScCAB1
	IjRacgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/18/2014 04:55 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 18.06.2014 04:20, Chanwoo Choi wrote:
>> This patchset add 'exynos_adc_ops' structure which includes some functions
>> to control ADC operation according to ADC version (v1 or v2).
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 174 +++++++++++++++++++++++++++++--------------
>>  1 file changed, 120 insertions(+), 54 deletions(-)
>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index 010578f..c30def6 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -90,6 +90,7 @@ struct exynos_adc {
>>  	struct clk		*clk;
>>  	unsigned int		irq;
>>  	struct regulator	*vdd;
>> +	struct exynos_adc_ops	*ops;
>>  
>>  	struct completion	completion;
>>  
>> @@ -97,6 +98,13 @@ struct exynos_adc {
>>  	unsigned int            version;
>>  };
>>  
>> +struct exynos_adc_ops {
>> +	void (*init_hw)(struct exynos_adc *info);
>> +	void (*clear_irq)(struct exynos_adc *info);
>> +	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
>> +	void (*stop_conv)(struct exynos_adc *info);
>> +};
>> +
>>  static const struct of_device_id exynos_adc_match[] = {
>>  	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>  	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>> @@ -112,30 +120,98 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
>>  	return (unsigned int)match->data;
>>  }
>>  
>> -static void exynos_adc_hw_init(struct exynos_adc *info)
>> +static void exynos_adc_v1_init_hw(struct exynos_adc *info)
>> +{
>> +	u32 con1;
>> +
>> +	/* set default prescaler values and Enable prescaler */
>> +	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
>> +
>> +	/* Enable 12-bit ADC resolution */
>> +	con1 |= ADC_V1_CON_RES;
>> +	writel(con1, ADC_V1_CON(info->regs));
>> +}
>> +
>> +static void exynos_adc_v1_start_conv(struct exynos_adc *info, unsigned long addr)
>> +{
>> +	u32 con1;
>> +
>> +	writel(addr, ADC_V1_MUX(info->regs));
>> +
>> +	con1 = readl(ADC_V1_CON(info->regs));
>> +	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
>> +}
>> +
>> +static void exynos_adc_v1_clear_irq(struct exynos_adc *info)
>> +{
>> +	writel(1, ADC_V1_INTCLR(info->regs));
>> +}
>> +
>> +static void exynos_adc_v1_stop_conv(struct exynos_adc *info)
>> +{
>> +	u32 con;
>> +
>> +	con = readl(ADC_V1_CON(info->regs));
>> +	con |= ADC_V1_CON_STANDBY;
>> +	writel(con, ADC_V1_CON(info->regs));
>> +}
>> +
>> +static struct exynos_adc_ops exynos_adc_v1_ops = {
>> +	.init_hw	= exynos_adc_v1_init_hw,
>> +	.clear_irq	= exynos_adc_v1_clear_irq,
>> +	.start_conv	= exynos_adc_v1_start_conv,
>> +	.stop_conv	= exynos_adc_v1_stop_conv,
>> +};
>> +
>> +static void exynos_adc_v2_init_hw(struct exynos_adc *info)
>>  {
>>  	u32 con1, con2;
>>  
>> -	if (info->version == ADC_V2) {
>> -		con1 = ADC_V2_CON1_SOFT_RESET;
>> -		writel(con1, ADC_V2_CON1(info->regs));
>> +	con1 = ADC_V2_CON1_SOFT_RESET;
>> +	writel(con1, ADC_V2_CON1(info->regs));
>>  
>> -		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
>> -			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
>> -		writel(con2, ADC_V2_CON2(info->regs));
>> +	con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
>> +		ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
>> +	writel(con2, ADC_V2_CON2(info->regs));
>>  
>> -		/* Enable interrupts */
>> -		writel(1, ADC_V2_INT_EN(info->regs));
>> -	} else {
>> -		/* set default prescaler values and Enable prescaler */
>> -		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
>> +	/* Enable interrupts */
>> +	writel(1, ADC_V2_INT_EN(info->regs));
>> +}
>>  
>> -		/* Enable 12-bit ADC resolution */
>> -		con1 |= ADC_V1_CON_RES;
>> -		writel(con1, ADC_V1_CON(info->regs));
>> -	}
>> +static void exynos_adc_v2_start_conv(struct exynos_adc *info, unsigned long addr)
>> +{
>> +	u32 con1, con2;
>> +
>> +	con2 = readl(ADC_V2_CON2(info->regs));
>> +	con2 &= ~ADC_V2_CON2_ACH_MASK;
>> +	con2 |= ADC_V2_CON2_ACH_SEL(addr);
>> +	writel(con2, ADC_V2_CON2(info->regs));
>> +
>> +	con1 = readl(ADC_V2_CON1(info->regs));
>> +	writel(con1 | ADC_CON_EN_START, ADC_V2_CON1(info->regs));
>> +}
>> +
>> +static void exynos_adc_v2_clear_irq(struct exynos_adc *info)
>> +{
>> +	writel(1, ADC_V2_INT_ST(info->regs));
>> +}
>> +
>> +static void exynos_adc_v2_stop_conv(struct exynos_adc *info)
>> +{
>> +	u32 con;
>> +
>> +	con = readl(ADC_V2_CON1(info->regs));
>> +	con &= ~ADC_CON_EN_START;
>> +	writel(con, ADC_V2_CON1(info->regs));
>>  }
>>  
>> +static struct exynos_adc_ops exynos_adc_v2_ops = {
>> +	.init_hw	= exynos_adc_v2_init_hw,
>> +	.start_conv	= exynos_adc_v2_start_conv,
>> +	.clear_irq	= exynos_adc_v2_clear_irq,
>> +	.stop_conv	= exynos_adc_v2_stop_conv,
>> +};
>> +
>>  static int exynos_read_raw(struct iio_dev *indio_dev,
>>  				struct iio_chan_spec const *chan,
>>  				int *val,
>> @@ -144,7 +220,6 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>  {
>>  	struct exynos_adc *info = iio_priv(indio_dev);
>>  	unsigned long timeout;
>> -	u32 con1, con2;
>>  	int ret;
>>  
>>  	if (mask != IIO_CHAN_INFO_RAW)
>> @@ -154,28 +229,15 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>  	reinit_completion(&info->completion);
>>  
>>  	/* Select the channel to be used and Trigger conversion */
>> -	if (info->version == ADC_V2) {
>> -		con2 = readl(ADC_V2_CON2(info->regs));
>> -		con2 &= ~ADC_V2_CON2_ACH_MASK;
>> -		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>> -		writel(con2, ADC_V2_CON2(info->regs));
>> -
>> -		con1 = readl(ADC_V2_CON1(info->regs));
>> -		writel(con1 | ADC_CON_EN_START,
>> -				ADC_V2_CON1(info->regs));
>> -	} else {
>> -		writel(chan->address, ADC_V1_MUX(info->regs));
>> -
>> -		con1 = readl(ADC_V1_CON(info->regs));
>> -		writel(con1 | ADC_CON_EN_START,
>> -				ADC_V1_CON(info->regs));
>> -	}
>> +	if (info->ops->start_conv)
>> +		info->ops->start_conv(info, chan->address);
>>  
>>  	timeout = wait_for_completion_timeout
>>  			(&info->completion, EXYNOS_ADC_TIMEOUT);
>>  	if (timeout == 0) {
>>  		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
>> -		exynos_adc_hw_init(info);
>> +		if (info->ops->init_hw)
>> +			info->ops->init_hw(info);
>>  		ret = -ETIMEDOUT;
>>  	} else {
>>  		*val = info->value;
>> @@ -193,13 +255,11 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>>  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
>>  
>>  	/* Read value */
>> -	info->value = readl(ADC_V1_DATX(info->regs)) &
>> -						ADC_DATX_MASK;
>> +	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
>> +
>>  	/* clear irq */
>> -	if (info->version == ADC_V2)
>> -		writel(1, ADC_V2_INT_ST(info->regs));
>> -	else
>> -		writel(1, ADC_V1_INTCLR(info->regs));
>> +	if (info->ops->clear_irq)
>> +		info->ops->clear_irq(info);
>>  
>>  	complete(&info->completion);
>>  
>> @@ -277,6 +337,19 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>  
>>  	info = iio_priv(indio_dev);
>>  
>> +	info->version = exynos_adc_get_version(pdev);
>> +	switch (info->version) {
>> +	case ADC_V1:
>> +		info->ops = &exynos_adc_v1_ops;
>> +		break;
>> +	case ADC_V2:
>> +		info->ops = &exynos_adc_v2_ops;
>> +		break;
>> +	default:
>> +		dev_err(&pdev->dev, "failed to identify ADC version\n");
>> +		return -EINVAL;
>> +	};
> 
> Just drop the enum completely and assign the struct pointer directly to
> driver data fields in match tables. I also suspect that the struct
> should be "variant" not "ops", because it will also require other data
> than function pointers, e.g. "needs_sclk".

OK, I will use "variant" structure instead of "ops" and drop enum vairable of ADC version.

Best Regards,
Chanwoo Choi

