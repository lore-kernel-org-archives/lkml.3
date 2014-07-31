Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaGaHH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:07:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9568 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaGaHHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:07:22 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-ec-53d9eb278fa4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kever Yang'" <kever.yang@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, paulz@synopsys.com, gregkh@linuxfoundation.org,
        mporter@linaro.org, kishon@ti.com, heiko@sntech.de,
        swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        addy.ke@rock-chips.com, xjq@rock-chips.com, cf@rock-chips.com,
        lyz@rock-chips.com, wulf@rock-chips.com, dianders@chromium.org,
        olof@lixom.net, sonnyrao@chromium.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
 <1406768764-9684-1-git-send-email-kever.yang@rock-chips.com>
In-reply-to: <1406768764-9684-1-git-send-email-kever.yang@rock-chips.com>
Subject: Re: [PATCH v2 2/2] usb: dwc2: add dr_mode support for dwc2
Date: Thu, 31 Jul 2014 16:07:13 +0900
Message-id: <001a01cfac8e$110c8380$33258a80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+sW7ltT3bS1GUNQxmnO/qFZTB9JwAMMY6A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0iTURjHOe/77t1FhNO8dJQsNNLQtLx2xOxCBacLFElfgrBpL2rexqZd
	oA9TmbWVd2k1S3PqsqVJK1s3tdlloRWa5YXEKCpD08qNvJSW2wz82rf/eZ7///yeBx4BLR7n
	eQtSMrI4WYYkzY8VMZ1zn0ODA0YH4taNDbhj/Z9JCitPj7D4hd7M4qKv1TycV9PE4j8fRnn4
	5chVgHuqX/Hwbc00i7s+nWVxdX4tg3vuXWSxTq+kcX/JFMB1fd0UvtgYhDv6rCw2lWsoXKxp
	ZPDYoIbBypbHfPzx+QWAR8z5DDY0Wmhcelm82Ys0VDYAUqHoZkhPYQFFrl6xseRmfSAxGlQs
	Gex9wJK2Sw188vpZLo/MatsYUnjLAIipt5Imt9qsgFj6TRSxGpeTG5f274UHRBsOc2kpRznZ
	2o2HRMmn1T/40hzf4xbdFgWo9VIDoQDBCNQ6rWKc2hN1DTWxaiASiKEeIP2wgfpn+tipWWjo
	ADozc47vfPwC6PdvmyPOQn9ksz3i27U7XIMeafodJho2M2hUPwzsDTE8BdD4nU12LYQ70FCe
	ylF3g1tRSfMMrQYCAQNXIdt0gL3sCmNRgVIHnHoJmiobcrBoGIia7loop16BbjaMOaIIBqAP
	s8HOEcJQkaJkweKOWr+MA/s4CJqEqPiN0fEPAyH6WdbOOLM+yPiQdi7shcz1/UwxQNpFZO0i
	snYRWbsIcRkwBuDBSROl8oQkWWiIXJIuz85ICknMTDcC560V3AFvH8a0g8R5fAnt7ZGYOX+L
	GVnxoeFRYTgyIjI8bH101P+V/Za6JrxP2CeGSZIsLpXjpJwsXpadxsnbASUQeisA9ynoadmV
	nf4nJq2esd+2uwqj5vRHqlipzZ03XHU/pW3XyfNH1MnHCgezc/Urr5uSzKlPXGD8Urdl2T6S
	1RN14+GlLiSupaLlYEo7XW6KrlRS5o6iHOueY2Oiuppr9RZZxXeVr1U1G1Mpif2VP7GNfz/2
	HaXblTZn9NXunNqt8GPkyZLQQFoml/wFSZSwoYEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsVy+t9jAV311zeDDTpu81os+/+dyaK14xWb
	xdllB9ks+t8sZLVoXryezeL/o9esFuderWS0uLzwEqvFtuk/2SwuPO1hs1jYtoTF4vKuOWwW
	i5a1MlvcmPiD0WLp9YtMFnPWalucuv6ZzWL7lOlMFhOmr2WxeHtnOotF694j7BZPzsxktHh1
	sI3FYtXa48wWkxYIOUh6rJm3htFjdsNFFo/Lfb1MHiuXf2Hz2LxCy2PTqk42jzvX9rB57J+7
	ht3jyokmVo+/s/azePRtWcXosf3aPGaPLfs/M3ocv7GdyePzJjmPjXNDAwSiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CBoqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Oj6yF7QqFhxfJFjA+MSyS5GTg4JAROJJ6en
	s0HYYhIX7q0Hsrk4hAQWMUp0/5rGDuH8ZpT48+cLC0gVm4CaxJcvh9lBbBEBHYnD02+AFTEL
	bGWReL3sOSNIQkignVHi3Q57EJtTwFPiXnMnWFxYwFli4tZfzF2MHBwsAqoSX36qg4R5BWwl
	elsXMULYghI/Jt8D28UsoCWxfudxJghbXmLzmrdgrRIC6hKP/upCnGAk0d8wEapERGLfi3eM
	ExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDSfCa9g3FV
	g8UhRgEORiUe3h8mN4OFWBPLiitzDzFKcDArifCGvgQK8aYkVlalFuXHF5XmpBYfYjQF+nMi
	s5Rocj4woeeVxBsam5gZWRqZWRiZmJsrifMebLUOFBJITyxJzU5NLUgtgulj4uCUamBM2L5h
	q7TJxaMxXxg3zPQu2m553PmxZ2veag73uZd5Cn4bbfFx8j6hcNe1m5PJT71fbNvrvz+3O17t
	cj5x4+Dpt/cjug4qLc0MDL4fwNC5/Zpp6J48razSkP/tJvG17/VD26fcCpL2clkvO019rrCY
	tK/Lkr1LhF5uF7RW1ddMmJizZN66jiQlluKMREMt5qLiRACJrUQSsAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 10:06 AM, Kever Yang wrote:
> 
> Some devices with A female host port and without use of usb_id pin
> will need this for the otg controller works as device role
> during firmware period and works as host role in rich os.

Hi Kever Yang,

This commit message looks too specific. Please make it more
general, as the commit "usb: dwc3: set 'mode' based on
selected Kconfig choices".

Then, maybe, you can add this specific case.
"According to the "dr_mode", the otg controller can work as
device role during firmware period, and work as host role in
the kernel, without use of usb_id pin."

Best regards,
Jingoo Han

> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> - put spaces around '+' operator
> - expand the comment for dr_mode
> - handle dr_mode is USB_DR_MODE_OTG
> 
>  drivers/usb/dwc2/core.c     |   18 ++++++++++++++++++
>  drivers/usb/dwc2/core.h     |    5 +++++
>  drivers/usb/dwc2/platform.c |    4 ++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index 27d2c9b..738bec2 100644
> --- a/drivers/usb/dwc2/core.c
> +++ b/drivers/usb/dwc2/core.c
> @@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>  {
>  	u32 greset;
>  	int count = 0;
> +	u32 gusbcfg;
> 
>  	dev_vdbg(hsotg->dev, "%s()\n", __func__);
> 
> @@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>  		}
>  	} while (greset & GRSTCTL_CSFTRST);
> 
> +	if (hsotg->dr_mode == USB_DR_MODE_HOST) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> +		gusbcfg |= GUSBCFG_FORCEHOSTMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	} else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> +		gusbcfg |= GUSBCFG_FORCEDEVMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	} else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> +		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	}
> +
>  	/*
>  	 * NOTE: This long sleep is _very_ important, otherwise the core will
>  	 * not stay in host mode after a connector ID change!
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 1efd10c..a34681c 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -501,6 +501,10 @@ struct dwc2_hw_params {
>   *                      a_peripheral and b_device=>b_host) this may not match
>   *                      the core, but allows the software to determine
>   *                      transitions
> + * @dr_mode:            Requested mode of operation, one of following:
> + *                      - USB_DR_MODE_PERIPHERAL
> + *                      - USB_DR_MODE_HOST
> + *                      - USB_DR_MODE_OTG
>   * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
>   *                      transfer are in process of being queued
>   * @srp_success:        Stores status of SRP request in the case of a FS PHY
> @@ -592,6 +596,7 @@ struct dwc2_hsotg {
>  	/** Params to actually use */
>  	struct dwc2_core_params *core_params;
>  	enum usb_otg_state op_state;
> +	enum usb_dr_mode        dr_mode;
> 
>  	unsigned int queuing_high_bandwidth:1;
>  	unsigned int srp_success:1;
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index b14668b..669a03a 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -42,6 +42,8 @@
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> 
> +#include <linux/usb/of.h>
> +
>  #include "core.h"
>  #include "hcd.h"
> 
> @@ -200,6 +202,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  	dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
>  		(unsigned long)res->start, hsotg->regs);
> 
> +	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
> +
>  	retval = dwc2_hcd_init(hsotg, irq, params);
>  	if (retval)
>  		return retval;
> --
> 1.7.9.5

