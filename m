Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaDOGgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:36:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60943 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaDOGgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:36:43 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-00-534cd37909bd
Message-id: <534CD37D.9030809@samsung.com>
Date: Tue, 15 Apr 2014 15:36:45 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <1397467040-30502-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1397467040-30502-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkSLfysk+wwde/GhYbZ6xntZj68Amb
	xesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFmsPXKX3eJ24wo2i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8a06ZNZC6aIVHz89oGpgfG0QBcj
	B4eEgInEtdcBXYycQKaYxIV769m6GLk4hASWMkqsuNjJCJEwkdjyeSMzRGIRo8TPxR1QVa8Z
	JWZN7mUGqeIV0JL4fq2VCcRmEVCVOPviMFicDSi+/8UNNhBbVCBMYuX0KywQ9YISPybfA7NF
	BAwlDu7ezgQylFngPZPE1tkzwQYJC3hL/Po0kR1iWyujxKtTU1lBEpwCHhLrvqwE28AsoCOx
	v3UaG4QtL7F5zVuwWyUEXrJL7H/9BeokAYlvkw+xQDwtK7HpADPEb5ISB1fcYJnAKDYLyVGz
	kIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB0Xn637OJOxjvH7A+xJgMtHIi
	s5Rocj4wuvNK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgVFqAWt8gVZp186GAPdZSr1clqzM05Q21NUF32r290pfaT/l6zVLL43TJ3r62T3rmn87
	TAk5enn1P6b9/yV17qgoXZz9omLnSz3OVWWq5Ywdcm2Pn0hbKho2tYkdTr3BKHQ9WPyXqYqW
	fM0R155Lx8917pxl9K3HqEzl6N2XNzkty26XrGs5pMRSnJFoqMVcVJwIAE/bE+rkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd3Kyz7BBlvmKFhsnLGe1WLqwyds
	Fq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2ax9shddovbjSvYLE53szpweeycdZfdY9OqTjaP
	O9f2sHnMOxno0bdlFaPH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzpk2fzFowRaTi47cPTA2MpwW6GDk5JARMJLZ83sgMYYtJXLi3nq2LkYtDSGARo8TPxR1Q
	zmtGiVmTe8GqeAW0JL5fa2UCsVkEVCXOvjgMFmcDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffA
	bBEBQ4mDu7czgQxlFnjPJLF19kywQcIC3hK/Pk1kh9jWyijx6tRUVpAEp4CHxLovK8E2MAvo
	SOxvncYGYctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95Pzc
	TYzg6H8mtYNxZYPFIUYBDkYlHl6PCT7BQqyJZcWVuYcYJTiYlUR4XycDhXhTEiurUovy44tK
	c1KLDzEmA8NgIrOUaHI+MDHllcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEggPbEkNTs1tSC1
	CGYLEwenVAOj+82oyz2KwqHKMxgOXFx8vXbi00IV/kV/Cg6x2jeW6OdX539gub7g8C+epID8
	1IQfaivSj9w/F8kTuXrLnMitEhaC/9XrUtpLN1RYvG952Z2oyyzN8S9PZuW92Ml8XlFCy6a+
	6WAzXBI863XCkip2/t8hi369tPL6lHxwb8APwx9vv+85f3+OEktxRqKhFnNRcSIA6z304EID	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 04/14/2014 06:17 PM, Krzysztof Kozlowski wrote:
> Add muic prefix to regmap config to differentiate between another regmap
> config for MAX77836 PMIC node. Additionally remove unused
> symbols: MAX14577_REG_INVALID and max14577_irq_source.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max14577.c               | 9 +++++----
>  include/linux/mfd/max14577-private.h | 4 +---
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 5f13cefe8def..d180fae8e317 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -37,7 +37,7 @@ static struct mfd_cell max14577_devs[] = {
>  	{ .name = "max14577-charger", },
>  };
>  
> -static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
> +static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
>  {
>  	switch (reg) {
>  	case MAX14577_REG_INT1 ... MAX14577_REG_STATUS3:
> @@ -48,10 +48,10 @@ static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
>  	return false;
>  }
>  
> -static const struct regmap_config max14577_regmap_config = {
> +static const struct regmap_config max14577_muic_regmap_config = {
>  	.reg_bits	= 8,
>  	.val_bits	= 8,
> -	.volatile_reg	= max14577_volatile_reg,
> +	.volatile_reg	= max14577_muic_volatile_reg,
>  	.max_register	= MAX14577_REG_END,
>  };
>  
> @@ -113,7 +113,8 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
>  	max14577->i2c = i2c;
>  	max14577->irq = i2c->irq;
>  
> -	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
> +	max14577->regmap = devm_regmap_init_i2c(i2c,
> +			&max14577_muic_regmap_config);
>  	if (IS_ERR(max14577->regmap)) {
>  		ret = PTR_ERR(max14577->regmap);
>  		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
> diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
> index c9b332fb0d5d..97b78d94f92f 100644
> --- a/include/linux/mfd/max14577-private.h
> +++ b/include/linux/mfd/max14577-private.h
> @@ -22,9 +22,7 @@
>  #include <linux/i2c.h>
>  #include <linux/regmap.h>
>  
> -#define MAX14577_REG_INVALID		(0xff)
> -
> -/* Slave addr = 0x4A: Interrupt */
> +/* Slave addr = 0x4A: MUIC and Charger */
>  enum max14577_reg {
>  	MAX14577_REG_DEVICEID		= 0x00,
>  	MAX14577_REG_INT1		= 0x01,
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Cheers,
Chanwoo Choi
