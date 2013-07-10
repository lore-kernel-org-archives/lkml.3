Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3GJGz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:55:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33823 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3GJGzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:55:54 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b5-51dd05789ed0
Message-id: <51DD0578.6090804@samsung.com>
Date: Wed, 10 Jul 2013 15:55:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH V2 4/4] extcon: palmas: Option to disable ID/VBUS detection
 based on platform
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
 <1373436959-32444-5-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373436959-32444-5-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkSLeS9W6gQWeixYHZD1kt+re4WFx4
	2sNmsXTfahaLhW1LWCwu75rDZnG7cQWbxbqX01kcODxerZ7J6nF+xkJGj97md2wefVtWMXpM
	nfKX0eP4je1MHp83yQWwR3HZpKTmZJalFunbJXBlNH/5zlQwz7Riz9Z7bA2My7S7GDk5JARM
	JH7eX8gOYYtJXLi3ng3EFhJYyijx9JUKTM3MNc1MXYxcQPFFjBKT5m1jh3BeMUqsOdEL1sEr
	oCWx+/VHsEksAqoSTet/g8XZgOL7X9wAs0UFwiRWTr/CAlEvKPFj8j0wWwSo5tuBf8wgQ5kF
	NjFKrJo2ixkkISyQLHGz8yuQzQG0rV6iYV8ASJhTwFWi90s7WC+zgDrQQYuYIWx5ic1r3jJD
	XH2PXeJCqx7EPQIS3yYfYgEZIyEgK7HpAFSJpMTBFTdYJjCKzUJy0SwkU2chmbqAkXkVo2hq
	QXJBcVJ6kYlecWJucWleul5yfu4mRmA8nv73bMIOxnsHrA8xJgOtnMgsJZqcD4znvJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwWgfyXjnoq9fw
	YvcLFQNrjotrMr7Pfinx72jB98lzg39tzxJ/K70syS0sbDbLnfkvavOf9y3cNNG2ymdd2Fl7
	gT1fbmZql3RnhVfOKr2WtlUw2vp07D47N+FVDjmeRiGV609yz1I2a/MzV+Cb+S/GLSXVPXh3
	M6Pzm1jD5PBtkz+uKVcyMWZSYinOSDTUYi4qTgQAPC5V2d0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd0K1ruBBj1fjC0OzH7IatG/xcXi
	wtMeNoul+1azWCxsW8JicXnXHDaL240r2CzWvZzO4sDh8Wr1TFaP8zMWMnr0Nr9j8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+gqJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG
	85fvTAXzTCv2bL3H1sC4TLuLkZNDQsBEYuaaZiYIW0ziwr31bF2MXBxCAosYJSbN28YO4bxi
	lFhzopcNpIpXQEti9+uP7CA2i4CqRNP632BxNqD4/hc3wGxRgTCJldOvsEDUC0r8mHwPzBYB
	qvl24B8zyFBmgU2MEqumzWIGSQgLJEvc7PwKZHMAbauXaNgXABLmFHCV6P3SDtbLLKAOdNAi
	ZghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf8
	M6kdjCsbLA4xCnAwKvHwHlC4EyjEmlhWXJl7iFGCg1lJhPffJaAQb0piZVVqUX58UWlOavEh
	xmRgCExklhJNzgemo7ySeENjEzMjSyNzQwsjY3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYNzvpq1rurrkrM+s5eZmu1gKv2eEaV1LT0o1S3AVDLHibL0aF2D/qfqLoemdf5f2Vcdd
	2O3s4bLk4Yd2zR6L3v/O//82Pta1PZlnY8X2lFl/wSXnTzUb6+YEvhCNt80/cm2X9Lf4ls1a
	MhNiXhXFOTuyRprcZr7td11AbIu21b2DbM4buP6tUGIpzkg01GIuKk4EAKpD5iE9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman, 

On 07/10/2013 03:15 PM, Laxman Dewangan wrote:
> Based on system design, platform needs to detect the VBUS or ID or
> both. Provide option to select this through platform data to
> disable part of cable detection through palmas-usb.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
> No changes from V1.
> 
>  .../devicetree/bindings/extcon/extcon-palmas.txt   |    2 +
>  drivers/extcon/extcon-palmas.c                     |   65 +++++++++++++-------
>  include/linux/mfd/palmas.h                         |    4 +
>  3 files changed, 48 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> index f110e75..8e593ec 100644
> --- a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> +++ b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> @@ -6,6 +6,8 @@ Required Properties:
>  
>  Optional Properties:
>   - ti,wakeup : To enable the wakeup comparator in probe
> + - ti,disable-id-detection: Do not perform ID detection.
> + - ti,disable-vbus-detection: Do not pwerform VBUS detection.

Fix typo.
- pwerform -> perform

>  
>  palmas-usb {
>         compatible = "ti,twl6035-usb", "ti,palmas-usb";
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index dc7ebf3..4747d11 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -122,11 +122,14 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
>  		PALMAS_USB_ID_INT_EN_HI_SET_ID_GND |
>  		PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
>  
> -	palmas_vbus_irq_handler(palmas_usb->vbus_irq, palmas_usb);
> +	if (palmas_usb->enable_vbus_detection)
> +		palmas_vbus_irq_handler(palmas_usb->vbus_irq, palmas_usb);
>  
>  	/* cold plug for host mode needs this delay */
> -	msleep(30);
> -	palmas_id_irq_handler(palmas_usb->id_irq, palmas_usb);
> +	if (palmas_usb->enable_id_detection) {
> +		msleep(30);
> +		palmas_id_irq_handler(palmas_usb->id_irq, palmas_usb);
> +	}
>  }
>  
>  static int palmas_usb_probe(struct platform_device *pdev)
> @@ -144,6 +147,10 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  			return -ENOMEM;
>  
>  		pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
> +		pdata->disable_id_detection = of_property_read_bool(node,
> +						"ti,disable-id-detection");
> +		pdata->disable_vbus_detection = of_property_read_bool(node,
> +						"ti,disable-vbus-detection");
>  	} else if (!pdata) {
>  		return -EINVAL;
>  	}
> @@ -154,6 +161,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  
>  	palmas->usb = palmas_usb;
>  	palmas_usb->palmas = palmas;
> +	palmas_usb->enable_vbus_detection = !pdata->disable_vbus_detection;
> +	palmas_usb->enable_id_detection =  !pdata->disable_id_detection;
>  
>  	palmas_usb->dev	 = &pdev->dev;
>  
> @@ -180,26 +189,32 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  		return status;
>  	}
>  
> -	status = devm_request_threaded_irq(palmas_usb->dev, palmas_usb->id_irq,
> -			NULL, palmas_id_irq_handler,
> -			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
> -			IRQF_ONESHOT | IRQF_EARLY_RESUME,
> -			"palmas_usb_id", palmas_usb);
> -	if (status < 0) {
> -		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
> +	if (palmas_usb->enable_id_detection) {
> +		status = devm_request_threaded_irq(palmas_usb->dev,
> +				palmas_usb->id_irq,
> +				NULL, palmas_id_irq_handler,
> +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
> +				IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +				"palmas_usb_id", palmas_usb);
> +		if (status < 0) {
> +			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
>  					palmas_usb->id_irq, status);
> -		goto fail_extcon;
> +			goto fail_extcon;
> +		}
>  	}
>  
> -	status = devm_request_threaded_irq(palmas_usb->dev,
> -			palmas_usb->vbus_irq, NULL, palmas_vbus_irq_handler,
> -			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
> -			IRQF_ONESHOT | IRQF_EARLY_RESUME,
> -			"palmas_usb_vbus", palmas_usb);
> -	if (status < 0) {
> -		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
> +	if (palmas_usb->enable_vbus_detection) {
> +		status = devm_request_threaded_irq(palmas_usb->dev,
> +				palmas_usb->vbus_irq, NULL,
> +				palmas_vbus_irq_handler,
> +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
> +				IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +				"palmas_usb_vbus", palmas_usb);
> +		if (status < 0) {
> +			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
>  					palmas_usb->vbus_irq, status);
> -		goto fail_extcon;
> +			goto fail_extcon;
> +		}
>  	}
>  
>  	palmas_enable_irq(palmas_usb);
> @@ -227,8 +242,10 @@ static int palmas_usb_suspend(struct device *dev)
>  	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
>  
>  	if (device_may_wakeup(dev)) {
> -		enable_irq_wake(palmas_usb->vbus_irq);
> -		enable_irq_wake(palmas_usb->id_irq);
> +		if (palmas_usb->enable_vbus_detection)
> +			enable_irq_wake(palmas_usb->vbus_irq);
> +		if (palmas_usb->enable_id_detection)
> +			enable_irq_wake(palmas_usb->id_irq);
>  	}
>  	return 0;
>  }
> @@ -238,8 +255,10 @@ static int palmas_usb_resume(struct device *dev)
>  	struct palmas_usb *palmas_usb = dev_get_drvdata(dev);
>  
>  	if (device_may_wakeup(dev)) {
> -		disable_irq_wake(palmas_usb->vbus_irq);
> -		disable_irq_wake(palmas_usb->id_irq);
> +		if (palmas_usb->enable_vbus_detection)
> +			disable_irq_wake(palmas_usb->vbus_irq);
> +		if (palmas_usb->enable_id_detection)
> +			disable_irq_wake(palmas_usb->id_irq);
>  	}
>  	return 0;
>  };
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 03c22ca..d9ef94c 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -204,6 +204,8 @@ struct palmas_pmic_platform_data {
>  struct palmas_usb_platform_data {
>  	/* Do we enable the wakeup comparator on probe */
>  	int wakeup;
> +	bool disable_vbus_detection;
> +	bool disable_id_detection;
>  };
>  
>  struct palmas_resource_platform_data {
> @@ -377,6 +379,8 @@ struct palmas_usb {
>  	int vbus_irq;
>  
>  	enum palmas_usb_state linkstat;
> +	bool enable_vbus_detection;
> +	bool enable_id_detection;
>  };
>  
>  #define comparator_to_palmas(x) container_of((x), struct palmas_usb, comparator)
> 

Should you define duplicate meaning variables in each other structure?
- disable_vbus_detection - enable_vbus_detection
- disable_id_detection - enable_id_detection

I think that it isn' efficient code. I'd like you to simplify this patch
by using only one variable instead of duplicate meaning variables.

Cheers,
Chanwoo Choi




