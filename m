Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaDPBNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:13:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49578 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDPBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:13:38 -0400
X-AuditID: cbfee68f-b7f156d00000276c-0d-534dd940abba
Message-id: <534DD943.8050707@samsung.com>
Date: Wed, 16 Apr 2014 10:13:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 1/2] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
 <1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkQNfhpm+wwfZpvBZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	S69fZLKYMH0ti8XbO9NZLFr3HmG3WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOoGM
	JfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlbFrukvBU+OKp2tfMTcwntfsYuTkkBAwkZg1
	8wEzhC0mceHeerYuRi4OIYGljBLrbv1ggSn6++8nC0RiEaPEhld72SGc14wSzV0L2UCqeAW0
	JDZc2wo2ikVAVeLIuzfsIDYbUHz/ixtgNaICYRIrp19hgagXlPgx+R6YLSKgITHz7xVGkKHM
	AkuZJY5uuwDWICyQKfH9+1ZGiG2NjBI3Zl4HSnBwcAq4SSz6JQpSwyygI7G/dRobhC0vsXnN
	W2aQegmBtRwSS/t+sUJcJCDxbfIhFpBeCQFZiU0HoH6WlDi44gbLBEaxWUhumoVk7CwkYxcw
	Mq9iFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIz70/+e9e9gvHvA+hBjMtDKicxSosn5wLSR
	VxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYq1hP
	dQgcEcjoWSezen9UnUCJZcqNvreepesnLH9zsGRGc/mlved7mgJsD/e9Y2Tb4DH5+R+HDP+U
	/cxflmRa/jVsVBJU0ONdr6vF3+N24nRhteCJCDHjFV7ut2MC4hfueGq593Pzy6U/3hh3Xjfd
	PKuQc695w9ftAZlOheZPFq/8ZnTNtD1DiaU4I9FQi7moOBEAbgrN8REDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAV2Hm77BBku0LO4+P8xocf3Lc1aL
	+UfOsVr0v1nIanHu1UpGiwdNq5gsehdcZbPY9Pgaq8XCtiUsFvOOvGOxuLxrDpvFjPP7mCyW
	Xr/IZDFh+loWi7d3prNYtO49wm6xfsZrFgdBjzXz1jB6XO7rZfJYufwLm8fmFVoem1Z1AhlL
	6j36tqxi9Pi8SS6AI6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6AslhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8au6S4F
	T40rnq59xdzAeF6zi5GTQ0LAROLvv58sELaYxIV769m6GLk4hAQWMUpseLWXHcJ5zSjR3LWQ
	DaSKV0BLYsO1rcwgNouAqsSRd2/YQWw2oPj+FzfAakQFwiRWTr/CAlEvKPFj8j0wW0RAQ2Lm
	3yuMIEOZBZYySxzddgGsQVggU+L7962MENsaGSVuzLwOlODg4BRwk1j0SxSkhllAR2J/6zQ2
	CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp5Rn
	UjsYVzZYHGIU4GBU4uGdkeMbLMSaWFZcmXuIUYKDWUmEd0MLUIg3JbGyKrUoP76oNCe1+BBj
	MjAIJjJLiSbnA9NdXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwqrF1NxvV77wnsn/t5b/3zCJXc/3gCJJaM7fDpumz8FJd+aIN8xV0LWc3fUo8lMMzT3DV
	EYHn/hqcBl6r5OY/jJno6Ohy8fuWt9s3LF70/eX3rPdbT3g/veNnKfjt1bKP/DUlr8yPzpqn
	siDxwVRpx7iCmRp6L+/HvLJf+Cf5xz+T60cZhI6k8yuxFGckGmoxFxUnAgCvU625bQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Any comment of this patchset?

Best Regards,
Chanwoo Choi

On 04/14/2014 06:07 PM, Chanwoo Choi wrote:
> This patch control special clock for ADC in Exynos series's FSYS block.
> If special clock of ADC is registerd on clock list of common clk framework,
> Exynos ADC drvier have to control this clock.
> 
> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
> - 'adc' clock: bus clock for ADC
> 
> Exynos3250 has additional 'sclk_tsadc' clock as following:
> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
> 
> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
> clock in FSYS_BLK.
> 
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Naveen Krishna Chatradhi
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 41 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index d25b262..3c99243 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -40,8 +40,9 @@
>  #include <linux/iio/driver.h>
>  
>  enum adc_version {
> -	ADC_V1,
> -	ADC_V2
> +	ADC_V1 = 0x1,
> +	ADC_V2 = 0x2,
> +	ADC_V3 = (ADC_V1 | ADC_V2),
>  };
>  
>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
> @@ -88,6 +89,7 @@ struct exynos_adc {
>  	void __iomem		*regs;
>  	void __iomem		*enable_reg;
>  	struct clk		*clk;
> +	struct clk		*sclk;
>  	unsigned int		irq;
>  	struct regulator	*vdd;
>  
> @@ -100,6 +102,7 @@ struct exynos_adc {
>  static const struct of_device_id exynos_adc_match[] = {
>  	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>  	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
> +	{ .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>  	mutex_lock(&indio_dev->mlock);
>  
>  	/* Select the channel to be used and Trigger conversion */
> -	if (info->version == ADC_V2) {
> +	if (info->version & ADC_V2) {
>  		con2 = readl(ADC_V2_CON2(info->regs));
>  		con2 &= ~ADC_V2_CON2_ACH_MASK;
>  		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>  	info->value = readl(ADC_V1_DATX(info->regs)) &
>  						ADC_DATX_MASK;
>  	/* clear irq */
> -	if (info->version == ADC_V2)
> +	if (info->version & ADC_V2)
>  		writel(1, ADC_V2_INT_ST(info->regs));
>  	else
>  		writel(1, ADC_V1_INTCLR(info->regs));
> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>  	return 0;
>  }
>  
> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
> +{
> +	if (enable) {
> +		clk_prepare_enable(info->clk);
> +		if (info->version == ADC_V3)
> +			clk_prepare_enable(info->sclk);
> +
> +	} else {
> +		if (info->version == ADC_V3)
> +			clk_disable_unprepare(info->sclk);
> +		clk_disable_unprepare(info->clk);
> +	}
> +}
> +
>  static void exynos_adc_hw_init(struct exynos_adc *info)
>  {
>  	u32 con1, con2;
>  
> -	if (info->version == ADC_V2) {
> +	if (info->version & ADC_V2) {
>  		con1 = ADC_V2_CON1_SOFT_RESET;
>  		writel(con1, ADC_V2_CON1(info->regs));
>  
> @@ -300,6 +317,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  
>  	writel(1, info->enable_reg);
>  
> +	info->version = exynos_adc_get_version(pdev);
> +
>  	info->clk = devm_clk_get(&pdev->dev, "adc");
>  	if (IS_ERR(info->clk)) {
>  		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
> @@ -308,6 +327,17 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  		goto err_irq;
>  	}
>  
> +	if (info->version == ADC_V3) {
> +		info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
> +		if (IS_ERR(info->sclk)) {
> +			dev_warn(&pdev->dev,
> +				"failed getting sclk clock, err = %ld\n",
> +				PTR_ERR(info->sclk));
> +			ret = PTR_ERR(info->sclk);
> +			goto err_irq;
> +		}
> +	}
> +
>  	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>  	if (IS_ERR(info->vdd)) {
>  		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
> @@ -316,8 +346,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  		goto err_irq;
>  	}
>  
> -	info->version = exynos_adc_get_version(pdev);
> -
>  	platform_set_drvdata(pdev, indio_dev);
>  
>  	indio_dev->name = dev_name(&pdev->dev);
> @@ -340,7 +368,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_iio_dev;
>  
> -	clk_prepare_enable(info->clk);
> +	exynos_adc_enable_clock(info, true);
>  
>  	exynos_adc_hw_init(info);
>  
> @@ -356,7 +384,7 @@ err_of_populate:
>  	device_for_each_child(&pdev->dev, NULL,
>  				exynos_adc_remove_devices);
>  	regulator_disable(info->vdd);
> -	clk_disable_unprepare(info->clk);
> +	exynos_adc_enable_clock(info, false);
>  err_iio_dev:
>  	iio_device_unregister(indio_dev);
>  err_irq:
> @@ -372,7 +400,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
>  	device_for_each_child(&pdev->dev, NULL,
>  				exynos_adc_remove_devices);
>  	regulator_disable(info->vdd);
> -	clk_disable_unprepare(info->clk);
> +	exynos_adc_enable_clock(info, false);
>  	writel(0, info->enable_reg);
>  	iio_device_unregister(indio_dev);
>  	free_irq(info->irq, info);
> @@ -387,7 +415,7 @@ static int exynos_adc_suspend(struct device *dev)
>  	struct exynos_adc *info = iio_priv(indio_dev);
>  	u32 con;
>  
> -	if (info->version == ADC_V2) {
> +	if (info->version & ADC_V2) {
>  		con = readl(ADC_V2_CON1(info->regs));
>  		con &= ~ADC_CON_EN_START;
>  		writel(con, ADC_V2_CON1(info->regs));
> @@ -397,7 +425,7 @@ static int exynos_adc_suspend(struct device *dev)
>  		writel(con, ADC_V1_CON(info->regs));
>  	}
>  
> -	clk_disable_unprepare(info->clk);
> +	exynos_adc_enable_clock(info, false);
>  	writel(0, info->enable_reg);
>  	regulator_disable(info->vdd);
>  
> @@ -415,7 +443,7 @@ static int exynos_adc_resume(struct device *dev)
>  		return ret;
>  
>  	writel(1, info->enable_reg);
> -	clk_prepare_enable(info->clk);
> +	exynos_adc_enable_clock(info, true);
>  
>  	exynos_adc_hw_init(info);
>  
> 

