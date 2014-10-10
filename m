Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaJJIqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:46:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29714 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJJIqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:46:31 -0400
X-AuditID: cbfee691-f79b86d000004a5a-5e-54379ce52ccc
Message-id: <54379CE5.5090908@samsung.com>
Date: Fri, 10 Oct 2014 17:46:29 +0900
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
Subject: Re: [PATCH fixes 1/2] mfd: max77693: Use proper regmap for handling
 MUIC interrupts
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkWPfpHPMQg0u3NSw2zljPavH6haHF
	2aY37Bb3vx5ltLi8aw6bxdojd9ktbjeuYLM43c1qsWDjI0YHTo871/awecw7GejRt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGRunTGctWMNdcerqUsYGxmWcXYycHBICJhJfjx5jg7DFJC7c
	Ww9kc3EICSxllPhzdzpTFyMHWNHsdm+I+HRGiUcdG5hBGoQEXjNKXPxtBGLzCmhJHDj6nAXE
	ZhFQldi98h9YDRtQfP+LG2ALRAXCJFZOv8ICUS8o8WPyPTBbRMBQ4uDu7UwgC5gF9jNJHD69
	gQ1ksbBAnMSDH5oQu9wl7h65BzaHU8BDYu/SU6wgNrOAjsT+1mlsELa8xOY1b5lB5kgIXGKX
	uP/iEhvEQQIS3yYfYoF4RlZi0wFmiIclJQ6uuMEygVFsFpKTZiEZOwvJ2AWMzKsYRVMLkguK
	k9KLTPWKE3OLS/PS9ZLzczcxAiPv9L9nE3cw3j9gfYhRgINRiYf3gox5iBBrYllxZe4hRlOg
	KyYyS4km5wPjO68k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsbjiz8/YnW4ontk4wHelFS70MsxeRJmj48zGLHP49KKrC5u/nzIruB4L9t34YU6a29P
	23OyU+dN+tqJSSEeq0qC7t2vEPIXea3WunL2FIs7JwU9hL1XcZ7m25xVmLLd+E7h5oipk5od
	2l5neFpvmnRJP+7+sdvMTzgiFn9ttQgVnFrO3XiqT1yJpTgj0VCLuag4EQCIC0t/twIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jQd2nc8xDDBreK1hsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2i7VH7rJb3G5cwWZxupvVYsHGR4wOnB53ru1h85h3MtCjb8sqRo/P
	m+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
	gC5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZsnDKdtWANd8Wpq0sZ
	GxiXcXYxcnBICJhIzG737mLkBDLFJC7cW8/WxcjFISQwnVHiUccGZpCEkMBrRomLv41AbF4B
	LYkDR5+zgNgsAqoSu1f+A6thA4rvf3GDDcQWFQiTWDn9CgtEvaDEj8n3wGwRAUOJg7u3M4Es
	YBbYzyRx+PQGNpAjhAXiJB780ITY5S5x98g9sDmcAh4Se5eeYgWxmQV0JPa3TmODsOUlNq95
	yzyBUWAWkhWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwXD+T2sG4ssHi
	EKMAB6MSD+8FGfMQIdbEsuLK3EOMEhzMSiK8+qZAId6UxMqq1KL8+KLSnNTiQ4ymwBCYyCwl
	mpwPTDl5JfGGxiZmRpZG5oYWRsbmSuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoYdy075HGc
	Rbvv31vLS371P4+FM7AV1LZafig0vijbzSSh4Bluxd/wX9An/ob1u7KNum2XOnYk6Kp8bVBM
	jE+K9b5rU/J6/lX2ENma7h2fZszY16K0xe6NZKhi8lOu2C2y/zdvOLrmM9Pbl2k1Xd/L5txb
	uPFM39XaVT85Cvb/ZlCt1XmTO89ViaU4I9FQi7moOBEAYuRs+gEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 05:22 PM, Krzysztof Kozlowski wrote:
> Interrupts coming from Maxim77693 MUIC block (MicroUSB Interface
> Controller) were not handled at all because wrong regmap was used for
> MUIC's regmap_irq_chip.
> 
> The MUIC component of Maxim 77693 uses different I2C address thus second
> regmap is created and used by max77693 extcon driver. The registers for
> MUIC interrupts are also in that block and should be handled by that
> second regmap.
> 
> However the regmap irq chip for MUIC was configured with default regmap
> which could not read MUIC registers.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> ---
>  drivers/mfd/max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 2277a11b6629..4b54da1ff7ab 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -243,7 +243,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		goto err_irq_charger;
>  	}
>  
> -	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +	ret = regmap_add_irq_chip(max77693->regmap_muic, max77693->irq,
>  				IRQF_ONESHOT | IRQF_SHARED |
>  				IRQF_TRIGGER_FALLING, 0,
>  				&max77693_muic_irq_chip,
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
