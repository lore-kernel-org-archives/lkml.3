Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaJJK4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:56:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48189 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaJJK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:56:45 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-f2-5437bb6b49fa
Message-id: <5437BB6A.6060402@samsung.com>
Date: Fri, 10 Oct 2014 19:56:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH fixes v2] mfd: max77693: Fix always masked MUIC interrupts
References: <1412938115-11606-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1412938115-11606-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkWDd7t3mIQddtHouNM9azWrx+YWhx
	tukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7NaLNj4iNGB0+POtT1sHvNOBnr0bVnF6PF5
	k1wASxSXTUpqTmZZapG+XQJXxvofb5kK+iQqJr+fwdbAeF24i5GTQ0LAROLk6ueMELaYxIV7
	69m6GLk4hASWMkrMuX2LEaZo95s+FojEIkaJFx8nQTmvGSU+b17HBFLFK6Alce3cbTYQm0VA
	VeLfzl5mEJsNKL7/xQ2wuKhAmMTK6VdYIOoFJX5MvgdmiwgYShzcvZ0JZCizwH4micOnN4A1
	CAv4Sex98BhsgZCAu0TX+Q1gDZwCHhK/vs9kBbGZBXQk9rdOY4Ow5SU2r3nLDDJIQuASu8S+
	O7PYIS4SkPg2+RBQMwdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguK
	k9KLTPSKE3OLS/PS9ZLzczcxAuPv9L9nE3Yw3jtgfYhRgINRiYf3gox5iBBrYllxZe4hRlOg
	KyYyS4km5wOjPK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYyMbiH/VzxKbjd8yiX8xLnAtP9NpsmvwPs8hZd0+p6qPF960/KfZ0aVn/r/zz5qN8W5
	1s54Xvr21M3ZH3TlW9N+LVFa0hV96vvfydLt5zqynsyf93tRFEtMcVfq1if9WfeOMFytd9fK
	fm+9TWWWkMvxduEnvivrXvX1La7+363cl6T4/XrHDA8lluKMREMt5qLiRAChYHDiugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t9jAd3s3eYhBjuvsFhsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2i7VH7rJb3G5cwWZxupvVYsHGR4wOnB53ru1h85h3MtCjb8sqRo/P
	m+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
	gC5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGas//GWqaBPomLy+xls
	DYzXhbsYOTkkBEwkdr/pY4GwxSQu3FvP1sXIxSEksIhR4sXHSSwQzmtGic+b1zGBVPEKaElc
	O3ebDcRmEVCV+LezlxnEZgOK739xAywuKhAmsXL6FRaIekGJH5PvgdkiAoYSB3dvZwIZyiyw
	n0ni8OkNYA3CAn4Sex88BlsgJOAu0XV+A1gDp4CHxK/vM1lBbGYBHYn9rdPYIGx5ic1r3jJP
	YBSYhWTHLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHN3PpHYwrmywOMQo
	wMGoxMN7QcY8RIg1say4MvcQowQHs5IIr+4WoBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSWEk3O
	ByaevJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjFrJaTXSRsaO
	XKIcoVOzEu9NaD4x5+L3K2ci3rzbKpJzgpXvoUEeS+3sioz9VRNq97t93REvJbJy/YZbvUxr
	n+fVFfmILYxMyt64cytTd+LRy5cVXh6SWiPyY3EMx58Tvct+Hkmew/J2w9+Dn4xfHUs5++7P
	5HcfwrVLC86q7JiyZc7m5Cb9pFolluKMREMt5qLiRAC6jcsvBAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 07:48 PM, Krzysztof Kozlowski wrote:
> All interrupts coming from MUIC were ignored because interrupt source
> register was masked.
> 
> The Maxim 77693 has a "interrupt source" - a separate register and interrupts
> which give information about PMIC block triggering the individual
> interrupt (charger, topsys, MUIC, flash LED).
> 
> By default bootloader could initialize this register to "mask all"
> value. In such case (observed on Trats2 board) MUIC interrupts won't be
> generated regardless of their mask status. Regmap irq chip was unmasking
> individual MUIC interrupts but the source was masked
> 
> Before introducing regmap irq chip this interrupt source was unmasked,
> read and acked. Reading and acking is not necessary but unmasking is.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> 
> ---
> 
> Changes since v1:
> 1. Do the unmasking in main MFD driver. Additionally unmask all
>    interrupts, not only MUIC. Suggested by Chanwoo Choi.
> ---
>  drivers/mfd/max77693.c               | 12 ++++++++++++
>  include/linux/mfd/max77693-private.h |  7 +++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 4b54da1ff7ab..4e4e6a1a6301 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -253,6 +253,17 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		goto err_irq_muic;
>  	}
>  
> +	/* Unmask interrupts from all blocks in interrupt source register */
> +	ret = regmap_update_bits(max77693->regmap,
> +				MAX77693_PMIC_REG_INTSRC_MASK,
> +				SRC_IRQ_ALL, ~SRC_IRQ_ALL);
> +	if (ret < 0) {
> +		dev_err(max77693->dev,
> +			"Could not unmask interrupts in INTSRC: %d\n",
> +			ret);
> +		goto err_intsrc;
> +	}
> +
>  	pm_runtime_set_active(max77693->dev);
>  
>  	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
> @@ -264,6 +275,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  
>  err_mfd:
>  	mfd_remove_devices(max77693->dev);
> +err_intsrc:
>  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
>  err_irq_muic:
>  	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index e1b2b61285b9..15fed5365a20 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -438,6 +438,13 @@ enum max77693_irq_source {
>  	MAX77693_IRQ_GROUP_NR,
>  };
>  
> +#define SRC_IRQ_CHARGER			BIT(0)
> +#define SRC_IRQ_TOP			BIT(1)
> +#define SRC_IRQ_FLASH			BIT(2)
> +#define SRC_IRQ_MUIC			BIT(3)
> +#define SRC_IRQ_ALL			(SRC_IRQ_CHARGER | SRC_IRQ_TOP \
> +						| SRC_IRQ_FLASH | SRC_IRQ_MUIC)
> +
>  #define LED_IRQ_FLED2_OPEN		BIT(0)
>  #define LED_IRQ_FLED2_SHORT		BIT(1)
>  #define LED_IRQ_FLED1_OPEN		BIT(2)
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
