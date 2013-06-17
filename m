Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3FQEJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:09:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58192 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQEJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:09:53 -0400
X-AuditID: cbfee68f-b7f436d000000f81-6a-51be8c0e9d50
Message-id: <51BE8C0D.9060003@samsung.com>
Date: Mon, 17 Jun 2013 13:09:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org
Subject: Re: [PATCH v4] usb: dwc3: use extcon fwrk to receive connect/disconnect
References: <1370276020-17446-6-git-send-email-kishon@ti.com>
 <1371215425-1979-1-git-send-email-kishon@ti.com>
In-reply-to: <1371215425-1979-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkUJevZ1+gwbTlahYH79dbzPx0k83i
	wOyHrBYH/uxgtGhevJ7N4sLTHjaLhW1LWCwu75rDZjF7ST+LxaJlrcwWtxtXsFkcXnGAyWLd
	y+ksDrweCz5fYfd4tXomq8eda3vYPPbPXcPucX7GQkaPvi2rGD2O39jO5PF5k1wARxSXTUpq
	TmZZapG+XQJXxtupN5gLfnlVbJzQxNTAuMWmi5GTQ0LARGJR+0pmCFtM4sK99WwgtpDAUkaJ
	+VN1YGq+HJ4MVMMFFF/EKLGj6QE7hPOCUeL04+tg3bwCWhJHz78Fs1kEVCWmTvjNDmKzAcX3
	v7gBNlVUIExi5fQrLBD1ghI/Jt8Ds0WAak7v/AG2gVngIJPEo3s7WEESwgIBEufXXGKHOKlA
	ovdzL1gDp4CtxJt9n8CGMgvoSOxvnQZly0tsXvMWbJCEQC+HxKo9EEUsAgIS3yYfAmrmAErI
	Smw6APWypMTBFTdYJjCKzUJy0ywkY2chGbuAkXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4m
	RmBEn/73rH8H490D1ocYk4FWTmSWEk3OByaEvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwxpzv2BKbru7upbF3mvQBFZmvc8VO+sY2Po0+cji1
	8EnO4uNbp71VTllfP+fe76pT14LPzf59bf0VqbVimvO1Hpxpd33eeIovZfNJ68iUpqXPFcpE
	WDrkvlgynLvnkb0++/vSYhXGFYxmZVtbZeeG3Pwt73JM5t5tU5Nqb7ZCrc1Ht8iq6To/VmIp
	zkg01GIuKk4EAK+I8ff+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV2+nn2BBh+uSlscvF9vMfPTTTaL
	A7Mfsloc+LOD0aJ58Xo2iwtPe9gsFrYtYbG4vGsOm8XsJf0sFouWtTJb3G5cwWZxeMUBJot1
	L6ezOPB6LPh8hd3j1eqZrB53ru1h89g/dw27x/kZCxk9+rasYvQ4fmM7k8fnTXIBHFENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPeTr3BXPDLq2LjhCamBsYtNl2MnBwS
	AiYSXw5PZoawxSQu3FvP1sXIxSEksIhRYkfTA3YI5wWjxOnH18GqeAW0JI6efwtmswioSkyd
	8JsdxGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBGgmtM7fzCDDGUWOMgk8ejeDlaQhLBA
	gMT5NZfABgkJFEj0fu4Fa+AUsJV4s+8T2FBmAR2J/a3ToGx5ic1r3jJPYBSYhWTHLCRls5CU
	LWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnDCeSe1gXNlgcYhRgINRiYd3Q/W+QCHW
	xLLiytxDjBIczEoivE2xQCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqcD0xmeSXxhsYmZkaW
	RuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuDr6YrJx0+2mIq34V6frmbMK
	/qu/XidwUOLT25cLWbRmMKnbyi0I2G5roFjD9Kv58+EI7sDLsjVSde7Gzif+Prd/0nE1++ml
	Txxqlvl2Xj7Fym3NfjueWa8wUbihxXVl86/JVcWCigujngSH6n03eeSb++Plhr8e7iKXZsm9
	u5BqcvXItcklSizFGYmGWsxFxYkAa6BujFwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:10 PM, Kishon Vijay Abraham I wrote:
> Modified dwc3-omap to receive connect and disconnect notification using
> extcon framework. Also did the necessary cleanups required after
> adapting to extcon framework.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
> This patch depends on
> git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git commit:f7ae906
> 
> It should also be applied on top of
> usb: dwc3: omap: improve error handling of dwc3_omap_probe patch which is
> merged in Felipe's tree.
> 
> So I'm not sure on whose tree this patch should go in.
> 
> Changes from v3:
> * did #include of of_extcon.h after Chanwoo resent the patch separating
> extcon-class.c from of_extcon.c
> Changes from v2:
> * updated the Documentation with dwc3 dt binding information.
> * used of_extcon_get_extcon_dev to get extcon device from device tree data.
> Changes from v1:
> * regulator enable/disable is now done here instead of palmas-usb as some users
> of palmas-usb wont need regulator.
> 
>  Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
>  drivers/usb/dwc3/dwc3-omap.c                       |  119 ++++++++++++++++----
>  include/linux/usb/dwc3-omap.h                      |   30 -----
>  3 files changed, 105 insertions(+), 49 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index d4769f3..f1c15f3 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -53,6 +53,11 @@ OMAP DWC3 GLUE
>     It should be set to "1" for HW mode and "2" for SW mode.
>   - ranges: the child address space are mapped 1:1 onto the parent address space
>  
> +Optional Properties:
> + - extcon : phandle for the extcon device omap dwc3 uses to detect
> +   connect/disconnect events.
> + - vbus-supply : phandle to the regulator device tree node if needed.
> +
>  Sub-nodes:
>  The dwc3 core should be added as subnode to omap dwc3 glue.
>  - dwc3 :
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index f8f76e6..14c1f1b 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -43,13 +43,15 @@
>  #include <linux/spinlock.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/dwc3-omap.h>
> -#include <linux/usb/dwc3-omap.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/ioport.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/extcon.h>
> +#include <linux/extcon/of_extcon.h>
> +#include <linux/regulator/consumer.h>
>  
>  #include <linux/usb/otg.h>
>  
> @@ -124,9 +126,21 @@ struct dwc3_omap {
>  	u32			utmi_otg_status;
>  
>  	u32			dma_status:1;
> +
> +	struct extcon_specific_cable_nb extcon_vbus_dev;
> +	struct extcon_specific_cable_nb extcon_id_dev;
> +	struct notifier_block	vbus_nb;
> +	struct notifier_block	id_nb;
> +
> +	struct regulator	*vbus_reg;
>  };
>  
> -static struct dwc3_omap		*_omap;
> +enum omap_dwc3_vbus_id_status {
> +	OMAP_DWC3_ID_FLOAT,
> +	OMAP_DWC3_ID_GROUND,
> +	OMAP_DWC3_VBUS_OFF,
> +	OMAP_DWC3_VBUS_VALID,
> +};
>  
>  static inline u32 dwc3_omap_readl(void __iomem *base, u32 offset)
>  {
> @@ -138,18 +152,23 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
>  	writel(value, base + offset);
>  }
>  
> -int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
> +static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
> +	enum omap_dwc3_vbus_id_status status)
>  {
> -	u32			val;
> -	struct dwc3_omap	*omap = _omap;
> -
> -	if (!omap)
> -		return -EPROBE_DEFER;
> +	int	ret;
> +	u32	val;
>  
>  	switch (status) {
>  	case OMAP_DWC3_ID_GROUND:
>  		dev_dbg(omap->dev, "ID GND\n");
>  
> +		if (omap->vbus_reg) {
> +			ret = regulator_enable(omap->vbus_reg);
> +			if (ret) {
> +				dev_dbg(omap->dev, "regulator enable failed\n");
> +				return;
> +			}
> +		}
>  		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
>  		val &= ~(USBOTGSS_UTMI_OTG_STATUS_IDDIG
>  				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
> @@ -172,6 +191,9 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>  		break;
>  
>  	case OMAP_DWC3_ID_FLOAT:
> +		if (omap->vbus_reg)
> +			regulator_disable(omap->vbus_reg);
> +
>  	case OMAP_DWC3_VBUS_OFF:
>  		dev_dbg(omap->dev, "VBUS Disconnect\n");
>  
> @@ -185,12 +207,9 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>  		break;
>  
>  	default:
> -		dev_dbg(omap->dev, "ID float\n");
> +		dev_dbg(omap->dev, "invalid state\n");
>  	}
> -
> -	return 0;
>  }
> -EXPORT_SYMBOL_GPL(dwc3_omap_mailbox);
>  
>  static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
>  {
> @@ -282,6 +301,32 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
>  
>  static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
>  
> +static int dwc3_omap_id_notifier(struct notifier_block *nb,
> +	unsigned long event, void *ptr)
> +{
> +	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, id_nb);
> +
> +	if (event)
> +		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
> +	else
> +		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_FLOAT);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
> +	unsigned long event, void *ptr)
> +{
> +	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, vbus_nb);
> +
> +	if (event)
> +		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
> +	else
> +		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_OFF);
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static int dwc3_omap_probe(struct platform_device *pdev)
>  {
>  	struct device_node	*node = pdev->dev.of_node;
> @@ -289,6 +334,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
>  	struct dwc3_omap	*omap;
>  	struct resource		*res;
>  	struct device		*dev = &pdev->dev;
> +	struct extcon_dev	*edev;
> +	struct regulator	*vbus_reg = NULL;
>  
>  	int			ret = -ENOMEM;
>  	int			irq;
> @@ -330,19 +377,22 @@ static int dwc3_omap_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> +	if (of_property_read_bool(node, "vbus-supply")) {
> +		vbus_reg = devm_regulator_get(dev, "vbus");
> +		if (IS_ERR(vbus_reg)) {
> +			dev_err(dev, "vbus init failed\n");
> +			return PTR_ERR(vbus_reg);
> +		}
> +	}
> +
>  	spin_lock_init(&omap->lock);
>  
>  	omap->dev	= dev;
>  	omap->irq	= irq;
>  	omap->base	= base;
> +	omap->vbus_reg	= vbus_reg;
>  	dev->dma_mask	= &dwc3_omap_dma_mask;
>  
> -	/*
> -	 * REVISIT if we ever have two instances of the wrapper, we will be
> -	 * in big trouble
> -	 */
> -	_omap	= omap;
> -
>  	pm_runtime_enable(dev);
>  	ret = pm_runtime_get_sync(dev);
>  	if (ret < 0) {
> @@ -381,14 +431,41 @@ static int dwc3_omap_probe(struct platform_device *pdev)
>  
>  	dwc3_omap_enable_irqs(omap);
>  
> +	if (of_property_read_bool(node, "extcon")) {
> +		edev = of_extcon_get_extcon_dev(dev, 0);
> +		if (IS_ERR(edev)) {
> +			dev_vdbg(dev, "couldn't get extcon device\n");
> +			ret = PTR_ERR(edev);
> +			goto err2;
> +		}
> +
> +		omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
> +		extcon_register_interest(&omap->extcon_vbus_dev, edev->name,
> +					 "USB", &omap->vbus_nb);
> +		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
> +		extcon_register_interest(&omap->extcon_id_dev, edev->name,
> +					 "USB-HOST", &omap->id_nb);

I prefer adding exception handling code about return value of extcon_register_interest().

> +
> +		if (extcon_get_cable_state(edev, "USB") == true)
> +			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
> +		if (extcon_get_cable_state(edev, "USB-HOST") == true)
> +			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
> +	}
> +
>  	ret = of_platform_populate(node, NULL, NULL, dev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to create dwc3 core\n");
> -		goto err2;
> +		goto err3;
>  	}
>  
>  	return 0;
>  
> +err3:
> +	if (omap->extcon_vbus_dev.edev)
> +		extcon_unregister_interest(&omap->extcon_vbus_dev);
> +	if (omap->extcon_id_dev.edev)
> +		extcon_unregister_interest(&omap->extcon_id_dev);
> +
>  err2:
>  	dwc3_omap_disable_irqs(omap);
>  
> @@ -405,6 +482,10 @@ static int dwc3_omap_remove(struct platform_device *pdev)
>  {
>  	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
>  
> +	if (omap->extcon_vbus_dev.edev)
> +		extcon_unregister_interest(&omap->extcon_vbus_dev);
> +	if (omap->extcon_id_dev.edev)
> +		extcon_unregister_interest(&omap->extcon_id_dev);
>  	dwc3_omap_disable_irqs(omap);
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> diff --git a/include/linux/usb/dwc3-omap.h b/include/linux/usb/dwc3-omap.h
> deleted file mode 100644
> index 5615f4d..0000000
> 

It looks good if you add exception handler about return value of extcon_register_interest().

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

But, we have to apply this patch after all of the extcon patchset(for 3.11) will be applied
because this patch has dependency of extcon patch related to DT.
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=f7ae906806279e5b57bfd302b945e1bcdddce95b

Thanks,
Chanwoo Choi

