Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaJVJJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:09:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52662 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaJVJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:09:44 -0400
X-AuditID: cbfee68e-f79b46d000002b74-ee-54477455b58c
Message-id: <54477456.2040702@samsung.com>
Date: Wed, 22 Oct 2014 18:09:42 +0900
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
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH RESEND 3/3] extcon: max77693: Fix extcon UART on Trats2
 board
References: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
 <1413967540-27626-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1413967540-27626-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkUDesxD3E4PkHZouNM9azWrx+YWhx
	tukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHjcubaHzWPeyUCPvi2rGD0+b5ILYIni
	sklJzcksSy3St0vgyrjbP4O94LJExZ03P9kaGNeIdDFyckgImEj8aV7CBmGLSVy4tx7I5uIQ
	EljKKDFr0WFWmKLjr19AJaYzSnxctJkZJCEk8JpR4twkHxCbV0BL4uqSt+wgNouAqsTNy3uZ
	QGw2oPj+FzfANogKhEmsnH6FBaJeUOLH5HtgtoiAocTB3duZQBYwCyxnknj4ah7YAmGBYIkf
	OxYyQmxuZZTYv+Ic2CROAQ+J7uefwTYwC+hI7G+dxgZhy0tsXvOWGaRBQuAUu8TDP0cZIU4S
	kPg2+RDQOg6ghKzEpgPMEK9JShxccYNlAqPYLCRHzUIydhaSsQsYmVcxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525iBEbd6X/P+nYw3jxgfYhRgINRiYfXgc09RIg1say4MvcQoynQFROZpUST
	84GxnVcSb2hsZmRhamJqbGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Py
	nRXMHhu/G73Ifbo99a9olalE/P6ZdkyWE+PuyWu8WeC84Jbu0rTlPNu7g/yVTzIH3fYsN8/a
	MDWzyH3L/t85+ZeqX9exZ97atCm0YXVcvo5cDf9025nWXHcPa25Sm51stMPHQzNg67+tXpFN
	T1ltq08psLBdEAsx53LssV5w6M/bs3cTXZVYijMSDbWYi4oTAWHjD5S1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQd3QEvcQg0tnLC02zljPavH6haHF
	2aY37Bb3vx5ltLi8aw6bxdojd9ktbjeuYLM43c3qwOFx59oeNo95JwM9+rasYvT4vEkugCWq
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG3f4Z7AWXJSruvPnJ1sC4RqSL
	kZNDQsBE4vjrF2wQtpjEhXvrgWwuDiGB6YwSHxdtZgZJCAm8ZpQ4N8kHxOYV0JK4uuQtO4jN
	IqAqcfPyXiYQmw0ovv/FDbBBogJhEiunX2GBqBeU+DH5HpgtImAocXD3diaQBcwCy5kkHr6a
	B7ZAWCBY4seOhYwQm1sZJfavOAc2iVPAQ6L7+WewDcwCOhL7W6exQdjyEpvXvGWewCgwC8mS
	WUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKafSe1gXNlgcYhRgINRiYfX
	gc09RIg1say4MvcQowQHs5II7710oBBvSmJlVWpRfnxRaU5q8SFGU2AYTGSWEk3OB6abvJJ4
	Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjPuakgLca9Wlm88q2h2a
	615xp8jp3uSiymTOt60771hfOz5xUejpSmbpVNunGzbNUm2UdDF7u1ZzTaGS7tV8MZ35ny9m
	fP7QdSFgpuCD2/tZpzzxPPo+t+RinnzGdYuTpyvnC5y8Eb5FtdzzVNSrltvL/vpM3tH5eJXf
	jpxby/cY91hOM+jRKVBiKc5INNRiLipOBAB5reWd/wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 05:45 PM, Krzysztof Kozlowski wrote:
> When JIG was set to "boot on" mode, the UART connection did not work
> because it was assigned to Dock-Car cable (path: audio), not JIG-UART-ON
> cable.
> 
> This was introduced in 39bf369e4ed3 ("extcon: max77693: Add support dock
> device and buttons") while adding dock features.
> 
> Assign the JIG-UART-ON back to UART path.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I want to change the name of this patch because I don't prefer to use board name on extcon driver patch.
before - extcon: max77693: Fix extcon UART on Trats2 board
after - extcon: max77693: Fix cable name of JIG_UART_ON

Applied it.

Thanks,
Chanwoo Choi

> ---
>  drivers/extcon/extcon-max77693.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 9d21e75a7032..beaa8cd71c3b 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -206,7 +206,7 @@ static const char *max77693_extcon_cable[] = {
>  	[EXTCON_CABLE_JIG_USB_ON]		= "JIG-USB-ON",
>  	[EXTCON_CABLE_JIG_USB_OFF]		= "JIG-USB-OFF",
>  	[EXTCON_CABLE_JIG_UART_OFF]		= "JIG-UART-OFF",
> -	[EXTCON_CABLE_JIG_UART_ON]		= "Dock-Car",
> +	[EXTCON_CABLE_JIG_UART_ON]		= "JIG-UART-ON",
>  	[EXTCON_CABLE_DOCK_SMART]		= "Dock-Smart",
>  	[EXTCON_CABLE_DOCK_DESK]		= "Dock-Desk",
>  	[EXTCON_CABLE_DOCK_AUDIO]		= "Dock-Audio",
> @@ -506,9 +506,6 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
>  		extcon_set_cable_state(info->edev, "Dock-Smart", attached);
>  		extcon_set_cable_state(info->edev, "MHL", attached);
>  		goto out;
> -	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
> -		strcpy(dock_name, "Dock-Car");
> -		break;
>  	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
>  		strcpy(dock_name, "Dock-Desk");
>  		break;
> @@ -643,6 +640,11 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
>  		strcpy(cable_name, "JIG-UART-OFF");
>  		path = CONTROL1_SW_UART;
>  		break;
> +	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* ADC_JIG_UART_ON */
> +		/* PATH:AP_UART */
> +		strcpy(cable_name, "JIG-UART-ON");
> +		path = CONTROL1_SW_UART;
> +		break;
>  	default:
>  		dev_err(info->dev, "failed to detect %s jig cable\n",
>  			attached ? "attached" : "detached");
> @@ -682,13 +684,13 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
>  	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_OFF:
>  	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_ON:
>  	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_OFF:
> +	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:
>  		/* JIG */
>  		ret = max77693_muic_jig_handler(info, cable_type, attached);
>  		if (ret < 0)
>  			return ret;
>  		break;
>  	case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
> -	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
>  	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
>  	case MAX77693_MUIC_ADC_AV_CABLE_NOLOAD:		/* Dock-Audio */
>  		/*
> 

