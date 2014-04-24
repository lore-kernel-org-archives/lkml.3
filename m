Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaDXFWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:22:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24378 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaDXFWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:22:33 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-a0-53589f81698f
Message-id: <53589F89.2030406@samsung.com>
Date: Thu, 24 Apr 2014 14:22:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv2 6/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsWyRsSkWHf6/IhggzVzuCwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4//Uoo8XlXXPYLG43rmCzON3N6sDjsWlV
	J5vHnWt72DzmnQz0eDnxN5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgEcUVw2Kak5mWWpRfp2CVwZ
	CzfMYimYblhxq/s5ewPja40uRk4OCQETiafLP7FD2GISF+6tZ+ti5OIQEljKKDH95gZGmKLG
	hlWMEIlFjBJn961igXBeM0q0du5hAaniFdCSuNgxnQ3EZhFQlfi29i9YNxtQfP+LG2BxUYEw
	iZXTr0DVC0r8mHwPzBYR0JCY+fcK2AZmgWVMEmdmf2EGSQgLREg8P3wYanUjo8SdQ11gHZwC
	bhLbWi4ygdjMAjoS+1unsUHY8hKb17xlBmmQEGjkkLg35TAjxEkCEt8mHwJq5gBKyEpsOsAM
	8ZukxMEVN1gmMIrNQnLULCRjZyEZu4CReRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYAyf
	/vesdwfj7QPWhxiTgVZOZJYSTc4HpoC8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBMsV5ttbHjQt7OR02v379UXxk1xXhH30dPN7ebBcHS/fve
	ijVtUdPl3Hrmru5P7npZhpQ+678asQ1c7t+Fpmzw4CjdpO9Tvuu93CqLmU/irQ+6LpnWOeWS
	0ZHm3lLpJ9MiTnGxXJv30sbM9QAj85mFQd/636y5G+i07fSsfdc6MwLnNth+b+tRYinOSDTU
	Yi4qTgQAwXL8RPcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd3G+RHBBrNbdSwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4//Uoo8XlXXPYLG43rmCzON3N6sDjsWlV
	J5vHnWt72DzmnQz0eDnxN5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgEcUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlApyoplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCWsYMxZumMVSMN2w4lb3c/YGxtcaXYycHBICJhKNDasYIWwx
	iQv31rN1MXJxCAksYpQ4u28VC4TzmlGitXMPC0gVr4CWxMWO6WwgNouAqsS3tX/ButmA4vtf
	3ACLiwqESaycfgWqXlDix+R7YLaIgIbEzL9XGEGGMgssY5I4M/sLM0hCWCBC4vnhw4wQ2xoZ
	Je4c6gLr4BRwk9jWcpEJxGYW0JHY3zqNDcKWl9i85i3zBEaBWUiWzEJSNgtJ2QJG5lWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwQnimdQOxpUNFocYBTgYlXh4D1wIDxZiTSwrrsw9xCjB
	wawkwrtmbkSwEG9KYmVValF+fFFpTmrxIcZkYBhMZJYSTc4HJq+8knhDYxMzI0sjc0MLI2Nz
	0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDUbhFfJ9/FZH8pOEaz+cDBrf7HeS75KB69
	2u27clNz86mE8vidpm1Ki+9JnO21jgtIvrY9JDWtM2ujv4LCueSVsreTTFx5gla1LdVPEHyR
	+brT4lTSl4t+c1qvFzuIvcjiuSbP//pdD7e1RXu7w+I07g3zI39/FjVKFJjr+Cwl8HXS6/K4
	60osxRmJhlrMRcWJAKDz495UAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon, Felipe,

If you possible, I'd like you to test or review this patch.
And then I'll apply it on extcon-next branch if you could give
me a acked or tested message.

- This patch has a depenency on extcon-next branch.
Following patchset support devm_extcon_dev_* function.
[1] https://lkml.org/lkml/2014/4/21/140
[2] https://lkml.org/lkml/2014/4/21/164

Thanks,
Chanwoo Choi

On 04/21/2014 09:02 PM, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-palmas.c | 35 ++++++++++++++++++++---------------
>  include/linux/mfd/palmas.h     |  2 +-
>  2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index 1a770e0..a9299ea 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -57,7 +57,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>  	if (vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS) {
>  		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
>  			palmas_usb->linkstat = PALMAS_USB_STATE_VBUS;
> -			extcon_set_cable_state(&palmas_usb->edev, "USB", true);
> +			extcon_set_cable_state(palmas_usb->edev, "USB", true);
>  			dev_info(palmas_usb->dev, "USB cable is attached\n");
>  		} else {
>  			dev_dbg(palmas_usb->dev,
> @@ -66,7 +66,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>  	} else if (!(vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS)) {
>  		if (palmas_usb->linkstat == PALMAS_USB_STATE_VBUS) {
>  			palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
> -			extcon_set_cable_state(&palmas_usb->edev, "USB", false);
> +			extcon_set_cable_state(palmas_usb->edev, "USB", false);
>  			dev_info(palmas_usb->dev, "USB cable is detached\n");
>  		} else {
>  			dev_dbg(palmas_usb->dev,
> @@ -93,7 +93,7 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>  		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
> -		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
> +		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
>  		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
>  	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
>  				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
> @@ -101,17 +101,17 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>  		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
> -		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
> +		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
>  		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
>  	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
>  				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
>  		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
> -		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
> +		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
>  		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
>  	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
>  				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
>  		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
> -		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
> +		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
>  		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
>  	}
>  
> @@ -187,15 +187,20 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, palmas_usb);
>  
> -	palmas_usb->edev.supported_cable = palmas_extcon_cable;
> -	palmas_usb->edev.dev.parent = palmas_usb->dev;
> -	palmas_usb->edev.name = kstrdup(node->name, GFP_KERNEL);
> -	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
> +	palmas_usb->edev = devm_extcon_dev_allocate(&pdev->dev,
> +						    palmas_extcon_cable);
> +	if (!palmas_usb->edev) {
> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
> +		return -ENOMEM;
> +	}
> +	palmas_usb->edev->name = kstrdup(node->name, GFP_KERNEL);
> +	palmas_usb->edev->dev.parent = palmas_usb->dev;
> +	palmas_usb->edev->mutually_exclusive = mutually_exclusive;
>  
> -	status = devm_extcon_dev_register(&pdev->dev, &palmas_usb->edev);
> +	status = devm_extcon_dev_register(&pdev->dev, palmas_usb->edev);
>  	if (status) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
> -		kfree(palmas_usb->edev.name);
> +		kfree(palmas_usb->edev->name);
>  		return status;
>  	}
>  
> @@ -209,7 +214,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  		if (status < 0) {
>  			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
>  					palmas_usb->id_irq, status);
> -			kfree(palmas_usb->edev.name);
> +			kfree(palmas_usb->edev->name);
>  			return status;
>  		}
>  	}
> @@ -224,7 +229,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  		if (status < 0) {
>  			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
>  					palmas_usb->vbus_irq, status);
> -			kfree(palmas_usb->edev.name);
> +			kfree(palmas_usb->edev->name);
>  			return status;
>  		}
>  	}
> @@ -238,7 +243,7 @@ static int palmas_usb_remove(struct platform_device *pdev)
>  {
>  	struct palmas_usb *palmas_usb = platform_get_drvdata(pdev);
>  
> -	kfree(palmas_usb->edev.name);
> +	kfree(palmas_usb->edev->name);
>  
>  	return 0;
>  }
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 9974e38..b8f87b7 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -415,7 +415,7 @@ struct palmas_usb {
>  	struct palmas *palmas;
>  	struct device *dev;
>  
> -	struct extcon_dev edev;
> +	struct extcon_dev *edev;
>  
>  	int id_otg_irq;
>  	int id_irq;
> 

