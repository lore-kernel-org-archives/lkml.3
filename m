Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FXLMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:12:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25820 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:12:47 -0400
X-AuditID: cbfee68e-b7f276d000002279-33-51c829ade887
Message-id: <51C829AD.4010208@samsung.com>
Date: Mon, 24 Jun 2013 20:12:45 +0900
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
Subject: Re: [PATCH v5] usb: dwc3: use extcon fwrk to receive connect/disconnect
References: <1371215425-1979-1-git-send-email-kishon@ti.com>
 <1371815921-28303-1-git-send-email-kishon@ti.com>
In-reply-to: <1371815921-28303-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkRHet5olAg6ZLuhYH79dbzPx0k83i
	wOyHrBYH/uxgtGhevJ7N4sLTHjaLhW1LWCwu75rDZjF7ST+LxaJlrcwWtxtXsFkcXnGAyWLd
	y+ksDrweCz5fYfd4tXomq8eda3vYPPbPXcPucX7GQkaPvi2rGD2O39jO5PF5k1wARxSXTUpq
	TmZZapG+XQJXxuGlW9gKNkRVrLuwhr2BcbJ7FyMnh4SAiUTDyj5WCFtM4sK99WxdjFwcQgJL
	GSV63vWxwxSd2LIIKrGIUWLX+zYWCOcFo8SZCXeZuhg5OHgFtCTuH6oAaWARUJWYNqmHCcRm
	Awrvf3GDDcQWFQiTWDn9CguIzSsgKPFj8j0wWwSo5vTOH8wgM5kFDjJJPLq3A+wkYYEAiX2L
	zzCD2EICBRKtWxrBhnIK2Els+PkR7DpmAR2J/a3T2CBseYnNa96CDZIQmMkhcanjHCPERQIS
	3yYfYgE5VEJAVmLTAWaIzyQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzECI/r0v2d9OxhvHrA+xJgMtHIis5Rocj4wIeSVxBsamxlZmJqYGhuZW5qR
	JqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTEq5bPWjZ8bgjtvGlpcm56h/fz/
	/0BGrtBcu/cNAmnfeG27FhRd1tfpCjilmzo/Jjfgd1eS/dJU9x1dVrLrtVeoBDMb+HmzM383
	fhEtzvv+ef7kLwanLj6Y3qOl5nTxx6LSVY9Nbmptvpgne998pUF1hD+3VZyCq0Ntl4bco5uT
	A8+c5878o8RSnJFoqMVcVJwIAK43CWH+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd21micCDW7PVLI4eL/eYuanm2wW
	B2Y/ZLU48GcHo0Xz4vVsFhee9rBZLGxbwmJxedccNovZS/pZLBYta2W2uN24gs3i8IoDTBbr
	Xk5nceD1WPD5CrvHq9UzWT3uXNvD5rF/7hp2j/MzFjJ69G1Zxehx/MZ2Jo/Pm+QCOKIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGYcXrqFrWBDVMW6C2vYGxgnu3cxcnJI
	CJhInNiyiA3CFpO4cG89kM3FISSwiFFi1/s2FgjnBaPEmQl3mboYOTh4BbQk7h+qAGlgEVCV
	mDaphwnEZgMK739xA2yQqECYxMrpV1hAbF4BQYkfk++B2SJANad3/mAGmckscJBJ4tG9Hawg
	CWGBAIl9i88wg9hCAgUSrVsawYZyCthJbPj5kR3EZhbQkdjfOo0NwpaX2LzmLfMERoFZSHbM
	QlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB6eKZ1A7GlQ0WhxgFOBiVeHh/
	WB4PFGJNLCuuzD3EKMHBrCTCGypyIlCINyWxsiq1KD++qDQntfgQYzIwCCYyS4km5wNTWV5J
	vKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MC75dsx77gqnyR1P
	n1zUizxUdcVkxS2fwpg9cw53L5do055gfvmYtOk53vupR8L4X2/cMVlmwYTHose3yG2vOamj
	461/MOfS81tyrqly+zuEm1e9kuqaGxNr7nRJf5fO9sfZYVcnu2y6U3hz2bkHRUXzGFcatd62
	nKd61ch26RzjdXufLZn825tFiaU4I9FQi7moOBEAKIgQLVsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 08:58 PM, Kishon Vijay Abraham I wrote:
> Modified dwc3-omap to receive connect and disconnect notification using
> extcon framework. Also did the necessary cleanups required after
> adapting to extcon framework.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> This patch should be applied after all of the extcon patchset will be applied
> because this patch has dependency of extcon patch related to DT.
> http://goo.gl/Tu3qW
> 
> Changes from v4:
> * checked the return values of extcon_register_interest and print an error
> message. Note that I dint do return since there might be cases where
> one of USB (device mode) or USB-HOST (host mode) might succeed.
> * Added depends on of EXTCON in usb_dwc3. Only some platforms might
> be using EXTCON, but inorder to avoid compilation errors, added
> depends on
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
>  drivers/usb/dwc3/Kconfig                           |    1 +
>  drivers/usb/dwc3/dwc3-omap.c                       |  125 +++++++++++++++++---
>  include/linux/usb/dwc3-omap.h                      |   30 -----
>  4 files changed, 112 insertions(+), 49 deletions(-)
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
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 757aa18..08a9fab 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -1,6 +1,7 @@
>  config USB_DWC3
>  	tristate "DesignWare USB3 DRD Core Support"
>  	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS
> +	depends on EXTCON
>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>  	help
>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index f8f76e6..80b5780 100644
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
> @@ -381,14 +431,47 @@ static int dwc3_omap_probe(struct platform_device *pdev)
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
> +		ret = extcon_register_interest(&omap->extcon_vbus_dev,
> +			edev->name, "USB", &omap->vbus_nb);
> +		if (ret < 0)
> +			dev_vdbg(dev,
> +			"extcon register interest of *USB* failed\n");
> +		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
> +		ret = extcon_register_interest(&omap->extcon_id_dev, edev->name,
> +					 "USB-HOST", &omap->id_nb);
> +		if (ret < 0)
> +			dev_vdbg(dev,
> +			"extcon register interest of *USB-HOST* failed\n");
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
> @@ -405,6 +488,10 @@ static int dwc3_omap_remove(struct platform_device *pdev)
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

I have below some fixes for indentation and applied it (extcon-for-palmas branch).
-                       dev_vdbg(dev,
-                       "extcon register interest of *USB* failed\n");
+                       dev_vdbg(dev, "failed to register notifier for USB\n");
                omap->id_nb.notifier_call = dwc3_omap_id_notifier;
                ret = extcon_register_interest(&omap->extcon_id_dev, edev->name,
                                         "USB-HOST", &omap->id_nb);
                if (ret < 0)
                        dev_vdbg(dev,
-                       "extcon register interest of *USB-HOST* failed\n");
+                               "failed to register notifier for USB-HOST\n");
 
                if (extcon_get_cable_state(edev, "USB") == true)
                        dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);

You can check it on following git repository.
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-for-palmas&id=bd84f70d42b867dfce61f961fb1c50d22e3ab4a8

And, I have plan to move your patch from extcon-for-palmas to extcon-next branch
after below patch on usb.git is applied on v3.11

usb: dwc3: omap: improve error handling of dwc3_omap_probe
- https://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/commit/?h=next&id=594daba1bcb0510cdc9dccfbab9e6fd5d9cc94e6
- git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git (next branch)


Thanks,
Chanwoo Choi














