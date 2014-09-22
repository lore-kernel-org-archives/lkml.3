Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIVG7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:59:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36508 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaIVG7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:59:37 -0400
X-AuditID: cbfee68f-f791c6d000004834-6e-541fc8d72178
Message-id: <541FC8D6.7020403@samsung.com>
Date: Mon, 22 Sep 2014 15:59:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] extcon: max77693: Use resource managed interrupt line
References: <1410527797-14027-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1410527797-14027-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSpHv9hHyIwcGHfBYbZ6xntXj9wtDi
	bNMbdovLu+awWaw9cpfd4nbjCjYHNo++LasYPT5vkgtgiuKySUnNySxLLdK3S+DKuHF+AVPB
	cvGKS0camRoYpwt1MXJwSAiYSGx9wtrFyAlkiklcuLeerYuRi0NIYCmjxL9j/9khEiYSjx/1
	MkIkpjNKbF3ygBXCec0oseziFGaQKl4BLYlVf8+zgkxlEVCVmNwXDhJmAwrvf3GDDcQWFQiT
	WDn9CgtEuaDEj8n3wGwRAUOJg7u3M4HMZBa4yyixavNSsISwgJfE3au3wc4TEnCXuDRlDZjN
	KeAhcXfOW7DrmAV0JPa3TmODsOUlNq95ywwySEJgE7vE141vwRIsAgIS3yYfYoF4WVZi0wFm
	iM8kJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAqPp
	9L9n/TsY7x6wPsQowMGoxMP7o0U+RIg1say4MvcQoynQFROZpUST84Exm1cSb2hsZmRhamJq
	bGRuaaYkzrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYgj/eTbE5Vxmht91p6q3sv
	04IDybxrUtJfiC3o81TiYrRisGz6HfjGaPLHF8v/anGtNxfQTZ9RyOpZePt+7rMqt0+BvvdW
	3d+4Lf7pgj39U2xf2wuqXs273PDRfs7/rWvkDea+m6a2XNKIoeG22L+pf4/ejmxpuFvgfTql
	M3nzi6LwMNmf6oeUWIozEg21mIuKEwEEnomWoQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd3rJ+RDDE5MYrfYOGM9q8XrF4YW
	Z5vesFtc3jWHzWLtkbvsFrcbV7A5sHn0bVnF6PF5k1wAU1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8aN8wuYCpaLV1w60sjUwDhdqIuRk0NCwETi8aNeRghbTOLCvfVs
	XYxcHEIC0xklti55wArhvGaUWHZxCjNIFa+AlsSqv+eBEhwcLAKqEpP7wkHCbEDh/S9usIHY
	ogJhEiunX2GBKBeU+DH5HpgtImAocXD3diaQmcwCdxklVm1eCpYQFvCSuHv1NiuILSTgLnFp
	yhowm1PAQ+LunLfsIDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI7WZ1I7GFc2WBxiFOBgVOLhXdAkHyLEmlhWXJl7iFGCg1lJ
	hPdoDlCINyWxsiq1KD++qDQntfgQoykwBCYyS4km5wMTSV5JvKGxiZmRpZG5oYWRsbmSOO+B
	VutAIYH0xJLU7NTUgtQimD4mDk6pBsZjCS+q3Qqf1lec2RD24vx3+f0Peblj0n20Vnx9/P1Y
	av6DSXxr/czsouISDTwnrenJjlv14Pv5VzyLzBaE9DNOVKxdLl3y/tOqe8dOrwvnX7rFdvUz
	7yRhZZ6GhS9POP6S/88jcrdqlkC4zYNtlprMwZx8yRvMcmWfNiSz8W53PPl3Uf/cqlQlluKM
	REMt5qLiRADQ6f457AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 10:16 PM, Krzysztof Kozlowski wrote:
> Use resource managed interrupt line devm_request_threaded_irq() to
> simplify a little cleanup paths:
>  - no goto to cleanup label,
>  - simpler remove function.
> 
> Overall the driver size is decreased by 11 line of code.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied.

Thanks,
Chanwoo Choi

> ---
>  drivers/extcon/extcon-max77693.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 77460f2c1ca1..0574154a94a9 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1155,13 +1155,11 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  
>  		virq = regmap_irq_get_virq(max77693->irq_data_muic,
>  					muic_irq->irq);
> -		if (!virq) {
> -			ret = -EINVAL;
> -			goto err_irq;
> -		}
> +		if (!virq)
> +			return -EINVAL;
>  		muic_irq->virq = virq;
>  
> -		ret = request_threaded_irq(virq, NULL,
> +		ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
>  				max77693_muic_irq_handler,
>  				IRQF_NO_SUSPEND,
>  				muic_irq->name, info);
> @@ -1170,7 +1168,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  				"failed: irq request (IRQ: %d,"
>  				" error :%d)\n",
>  				muic_irq->irq, ret);
> -			goto err_irq;
> +			return ret;
>  		}
>  	}
>  
> @@ -1179,15 +1177,14 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  					      max77693_extcon_cable);
>  	if (IS_ERR(info->edev)) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
> -		ret = -ENOMEM;
> -		goto err_irq;
> +		return -ENOMEM;
>  	}
>  	info->edev->name = DEV_NAME;
>  
>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
> -		goto err_irq;
> +		return ret;
>  	}
>  
>  	/* Initialize MUIC register by using platform data or default data */
> @@ -1265,7 +1262,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  			MAX77693_MUIC_REG_ID, &id);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read revision number\n");
> -		goto err_irq;
> +		return ret;
>  	}
>  	dev_info(info->dev, "device ID : 0x%x\n", id);
>  
> @@ -1285,20 +1282,12 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  			delay_jiffies);
>  
>  	return ret;
> -
> -err_irq:
> -	while (--i >= 0)
> -		free_irq(muic_irqs[i].virq, info);
> -	return ret;
>  }
>  
>  static int max77693_muic_remove(struct platform_device *pdev)
>  {
>  	struct max77693_muic_info *info = platform_get_drvdata(pdev);
> -	int i;
>  
> -	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
> -		free_irq(muic_irqs[i].virq, info);
>  	cancel_work_sync(&info->irq_work);
>  	input_unregister_device(info->dock);
>  
> 

