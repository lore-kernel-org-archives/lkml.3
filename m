Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3GJXwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:52:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17058 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3GJXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:52:44 -0400
X-AuditID: cbfee68f-b7f436d000000f81-69-51ddf3ca2b69
From: Jingoo Han <jg1.han@samsung.com>
To: "'Julius Werner'" <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olofj@chromium.org>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
In-reply-to: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Date: Thu, 11 Jul 2013 08:52:41 +0900
Message-id: <000901ce7dc8$90a819b0$b1f84d10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqj1FUEYrwpGpRm2gJpEuTVlJQ6pimab8w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zge6pz3cDDVbe4rc4eL/e4sDsh6wW
	Z5cdZLNou3KQ3eLywkusFh2HHjNZ9C64ymZxedccNosZ5/cxWSxa1sps8XXLbkaL81s6mSyO
	zVjCaNH+dy+bxbZvd1gc+D1mN1xk8bhzbQ+bx/kZCxk9+rasYvQ4fmM7k8fnTXIBbFFcNimp
	OZllqUX6dglcGW0PFrMVXE+smLL2D3MDY5d/FyMnh4SAicTn57fZIGwxiQv31gPZXBxCAssY
	JSZNvcQCU/Sl7zdYkZDAdEaJbZ98IYp+MUocmrOSHSTBJqAm8eXLYTBbRCBT4uS0D+wgRcwC
	T5glVtyG6XaR6LiyggnE5hRwlXj1/x8jiC0s4Cdx+M5VMJtFQFVi88eDrCA2r4ClRM/frewQ
	tqDEj8n3wC5iFtCSWL/zOBOELS+xec1bZohLFSR2nH3NCHGEkcSFF7sZIWpEJPa9eMcIcpCE
	wEoOiTtHLzNBLBOQ+Db5ENBQDqCErMSmA1BzJCUOrrjBMoFRYhaS1bOQrJ6FZPUsJCsWMLKs
	YhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAhJDP07GO8esD7EmAy0fiKzlGhyPjCx5JXEGxqb
	GVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsS0hteQJwzMD
	o/C5v/Z2muTtNmHZ09t/6fSHx83Hk4oizSX2tRe9z8rqbXzhoJp1PW7qgW2ftp3d+/zETc6J
	K8rne63+avni83dh+flu6ztST+pPmqwffC0nyGThtzzNufIPe1J355yZZ+rQfdqrVCiLi+Wo
	hr3Is9kG7x5/d3l1RcD8s1PbGyWW4oxEQy3mouJEAH4KGJ4iAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jQd1Tn+8GGnzfxWFx8H69xYHZD1kt
	zi47yGbRduUgu8XlhZdYLToOPWay6F1wlc3i8q45bBYzzu9jsli0rJXZ4uuW3YwW57d0Mlkc
	m7GE0aL97142i23f7rA48HvMbrjI4nHn2h42j/MzFjJ69G1Zxehx/MZ2Jo/Pm+QC2KIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWa0PVjMVnA9sWLK2j/MDYxd/l2MnBwS
	AiYSX/p+s0HYYhIX7q0Hs4UEpjNKbPvk28XIBWT/YpQ4NGclO0iCTUBN4suXw2C2iECmxMlp
	H9hBipgFnjBLrLj9G6rbRaLjygomEJtTwFXi1f9/jCC2sICfxOE7V8FsFgFVic0fD7KC2LwC
	lhI9f7eyQ9iCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4lIFiR1nXzNCHGEkceHFbkaIGhGJ
	fS/eMU5gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeeZ
	9A7GVQ0WhxgFOBiVeHgb4u8GCrEmlhVX5h5ilOBgVhLhPTkFKMSbklhZlVqUH19UmpNafIgx
	GejTicxSosn5wJSYVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MlpvWrpxxu51TWio3WHlv7/Tlqc+OW/eKadUzCHVVH1twLDLZ1N8x+cP31RvPqN7R3hQc
	ULvpRazUqxMLSz2r4v7I7L3lx+r76/4Plp4FMWGcLLFnTd/zGTHxzWHoqw2aI5D+q2Wh3pr4
	wAt5Ene7RUvnc62sW+45x/jtqU/a3cG2BmzPD85TYinOSDTUYi4qTgQA/+Api38DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 10, 2013 9:34 AM, Julius Werner wrote:
> 
> This patch adds support for a new 'samsung,hsic-reset-gpio' in the
> device tree, which will be interpreted as an active-low reset pin during
> PHY initialization when it exists. Useful for intergrated HSIC devices
> like an SMSC 3503 hub. It is necessary to add this directly to the PHY
> initialization to get the timing right, since resetting a HSIC device
> after it has already been enumerated can confuse the USB stack.
> 
> Also fixes PHY semaphore code to make sure we always go through the
> setup at least once, even if it was already turned on (e.g. by
> firmware), and changes a spinlock to a mutex to allow sleeping in the
> critical section.

CC'ed Thomas Abraham,

This reset signal pin seems 'HUB_RESET' pin to reset SMSC 3503 hub
on Arndale board. This reset pin is described that 'This active low signal
is used by the system to reset the chip' in SMSC 3503 hub datasheet.

One more thing, 
'phy-samsung-usb*.c' files are used and designed to control USB PHY controller
in Exynos SoCs; thus, these files should control only internal USB PHY controller
in Exynos SoCs.

However, the reset pin is used for reset external SMSC 3503 hub chip
that is not placed in Exynos SoC.

Thus, there should not be HUB reset code
in ./drivers/usb/phy/phy-samsung-usb*.c

This topic was already discussed one month ago.
As Olof Johansson mentioned, 'drivers/platform/arm/' would be
a good alternative; thus, USB hub reset code should be moved 
to 'drivers/platform/arm/'. Please refer to the discussion.
(http://patches.linaro.org/16856/)


Best regards,
Jingoo Han

> 
> Change-Id: Ieecac52c27daa7a17a7ed3b2863ddba3aeb8d16f
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  .../devicetree/bindings/usb/samsung-usbphy.txt     | 10 ++++++
>  drivers/usb/phy/phy-samsung-usb.c                  | 17 ++++++++++
>  drivers/usb/phy/phy-samsung-usb.h                  |  7 ++--
>  drivers/usb/phy/phy-samsung-usb2.c                 | 38 ++++++++++------------
>  drivers/usb/phy/phy-samsung-usb3.c                 | 12 +++----
>  5 files changed, 55 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> index 33fd354..82e2e16 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -31,6 +31,12 @@ Optional properties:
>  - ranges: allows valid translation between child's address space and parent's
>  	  address space.
> 
> +- samsung,hsic-reset-gpio: an active low GPIO pin that resets a device
> +			connected to the HSIC port. Useful for things like
> +			an on-board SMSC3503 hub.
> +- pinctrl-0: Pin control group containing the HSIC reset GPIO pin.
> +- pinctrl-names: Should contain only one value - "default".
> +
>  - The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
>    interface for usb-phy. It should provide the following information required by
>    usb-phy controller to control phy.
> @@ -56,6 +62,10 @@ Example:
>  		clocks = <&clock 2>, <&clock 305>;
>  		clock-names = "xusbxti", "otg";
> 
> +		samsung,hsic-reset-gpio = <&gpx2 4 1>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&hsic_reset>;
> +
>  		usbphy-sys {
>  			/* USB device and host PHY_CONTROL registers */
>  			reg = <0x10020704 0x8>;
> diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
> index ac025ca..23f1d70 100644
> --- a/drivers/usb/phy/phy-samsung-usb.c
> +++ b/drivers/usb/phy/phy-samsung-usb.c
> @@ -27,6 +27,7 @@
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_gpio.h>
>  #include <linux/usb/samsung_usb_phy.h>
> 
>  #include "phy-samsung-usb.h"
> @@ -58,6 +59,22 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
>  	if (sphy->sysreg == NULL)
>  		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
> 
> +	/*
> +	 * Some boards have a separate active-low reset GPIO for their HSIC USB
> +	 * devices. If they don't, this will just stay at an invalid value and
> +	 * the init code will ignore it.
> +	 */
> +	sphy->hsic_reset_gpio = of_get_named_gpio(sphy->dev->of_node,
> +						"samsung,hsic-reset-gpio", 0);
> +	if (gpio_is_valid(sphy->hsic_reset_gpio)) {
> +		if (devm_gpio_request_one(sphy->dev, sphy->hsic_reset_gpio,
> +				GPIOF_OUT_INIT_LOW, "samsung_hsic_reset")) {
> +			dev_err(sphy->dev, "can't request hsic reset gpio %d\n",
> +				sphy->hsic_reset_gpio);
> +			sphy->hsic_reset_gpio = -EINVAL;
> +		}
> +	}
> +
>  	of_node_put(usbphy_sys);
> 
>  	return 0;
> diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
> index 68771bf..0703878 100644
> --- a/drivers/usb/phy/phy-samsung-usb.h
> +++ b/drivers/usb/phy/phy-samsung-usb.h
> @@ -16,6 +16,7 @@
>   * GNU General Public License for more details.
>   */
> 
> +#include <linux/mutex.h>
>  #include <linux/usb/phy.h>
> 
>  /* Register definitions */
> @@ -301,7 +302,8 @@ struct samsung_usbphy_drvdata {
>   * @phy_type: Samsung SoCs specific phy types:	#HOST
>   *						#DEVICE
>   * @phy_usage: usage count for phy
> - * @lock: lock for phy operations
> + * @mutex: mutex for phy operations (usb2phy must sleep, so no spinlock!)
> + * @hsic_reset_gpio: Active low GPIO that resets connected HSIC device
>   */
>  struct samsung_usbphy {
>  	struct usb_phy	phy;
> @@ -315,7 +317,8 @@ struct samsung_usbphy {
>  	const struct samsung_usbphy_drvdata *drv_data;
>  	enum samsung_usb_phy_type phy_type;
>  	atomic_t	phy_usage;
> -	spinlock_t	lock;
> +	struct mutex	mutex;
> +	int		hsic_reset_gpio;
>  };
> 
>  #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
> diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
> index 1011c16..2db2113 100644
> --- a/drivers/usb/phy/phy-samsung-usb2.c
> +++ b/drivers/usb/phy/phy-samsung-usb2.c
> @@ -24,6 +24,7 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
> +#include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/usb/otg.h>
> @@ -43,15 +44,6 @@ static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
>  	return 0;
>  }
> 
> -static bool exynos5_phyhost_is_on(void __iomem *regs)
> -{
> -	u32 reg;
> -
> -	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
> -
> -	return !(reg & HOST_CTRL0_SIDDQ);
> -}
> -
>  static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
>  {
>  	void __iomem *regs = sphy->regs;
> @@ -68,10 +60,8 @@ static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
>  	 * the last consumer to disable it.
>  	 */
> 
> -	atomic_inc(&sphy->phy_usage);
> -
> -	if (exynos5_phyhost_is_on(regs)) {
> -		dev_info(sphy->dev, "Already power on PHY\n");
> +	if (atomic_inc_return(&sphy->phy_usage) != 1) {
> +		dev_info(sphy->dev, "USB PHY already initialized\n");
>  		return;
>  	}
> 
> @@ -132,6 +122,13 @@ static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
>  	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> 
>  	/* HSIC phy configuration */
> +	if (gpio_is_valid(sphy->hsic_reset_gpio)) {
> +		gpio_set_value(sphy->hsic_reset_gpio, 0);
> +		udelay(100);  /* Keep reset as active/low for 100us */
> +		gpio_set_value(sphy->hsic_reset_gpio, 1);
> +		usleep_range(4000, 10000);  /* wait for device init */
> +	}
> +
>  	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
>  			HSIC_CTRL_REFCLKSEL |
>  			HSIC_CTRL_PHYSWRST);
> @@ -220,6 +217,9 @@ static void samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)
>  	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
>  	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
> 
> +	if (gpio_is_valid(sphy->hsic_reset_gpio))
> +		gpio_set_value(sphy->hsic_reset_gpio, 0);
> +
>  	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
>  	phyhost |= (HOST_CTRL0_SIDDQ |
>  			HOST_CTRL0_FORCESUSPEND |
> @@ -267,7 +267,6 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
>  {
>  	struct samsung_usbphy *sphy;
>  	struct usb_bus *host = NULL;
> -	unsigned long flags;
>  	int ret = 0;
> 
>  	sphy = phy_to_sphy(phy);
> @@ -281,7 +280,7 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
>  		return ret;
>  	}
> 
> -	spin_lock_irqsave(&sphy->lock, flags);
> +	mutex_lock(&sphy->mutex);
> 
>  	if (host) {
>  		/* setting default phy-type for USB 2.0 */
> @@ -304,7 +303,7 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
>  	/* Initialize usb phy registers */
>  	sphy->drv_data->phy_enable(sphy);
> 
> -	spin_unlock_irqrestore(&sphy->lock, flags);
> +	mutex_unlock(&sphy->mutex);
> 
>  	/* Disable the phy clock */
>  	clk_disable_unprepare(sphy->clk);
> @@ -319,7 +318,6 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
>  {
>  	struct samsung_usbphy *sphy;
>  	struct usb_bus *host = NULL;
> -	unsigned long flags;
> 
>  	sphy = phy_to_sphy(phy);
> 
> @@ -330,7 +328,7 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
>  		return;
>  	}
> 
> -	spin_lock_irqsave(&sphy->lock, flags);
> +	mutex_lock(&sphy->mutex);
> 
>  	if (host) {
>  		/* setting default phy-type for USB 2.0 */
> @@ -350,7 +348,7 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
>  	else if (sphy->drv_data->set_isolation)
>  		sphy->drv_data->set_isolation(sphy, true);
> 
> -	spin_unlock_irqrestore(&sphy->lock, flags);
> +	mutex_unlock(&sphy->mutex);
> 
>  	clk_disable_unprepare(sphy->clk);
>  }
> @@ -422,7 +420,7 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
>  	sphy->phy.otg->phy	= &sphy->phy;
>  	sphy->phy.otg->set_host = samsung_usbphy_set_host;
> 
> -	spin_lock_init(&sphy->lock);
> +	mutex_init(&sphy->mutex);
> 
>  	platform_set_drvdata(pdev, sphy);
> 
> diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
> index 300e0cf..6ec3f08 100644
> --- a/drivers/usb/phy/phy-samsung-usb3.c
> +++ b/drivers/usb/phy/phy-samsung-usb3.c
> @@ -164,7 +164,6 @@ static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
>  static int samsung_usb3phy_init(struct usb_phy *phy)
>  {
>  	struct samsung_usbphy *sphy;
> -	unsigned long flags;
>  	int ret = 0;
> 
>  	sphy = phy_to_sphy(phy);
> @@ -176,7 +175,7 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
>  		return ret;
>  	}
> 
> -	spin_lock_irqsave(&sphy->lock, flags);
> +	mutex_lock(&sphy->mutex);
> 
>  	/* setting default phy-type for USB 3.0 */
>  	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
> @@ -188,7 +187,7 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
>  	/* Initialize usb phy registers */
>  	sphy->drv_data->phy_enable(sphy);
> 
> -	spin_unlock_irqrestore(&sphy->lock, flags);
> +	mutex_unlock(&sphy->mutex);
> 
>  	/* Disable the phy clock */
>  	clk_disable_unprepare(sphy->clk);
> @@ -202,7 +201,6 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
>  static void samsung_usb3phy_shutdown(struct usb_phy *phy)
>  {
>  	struct samsung_usbphy *sphy;
> -	unsigned long flags;
> 
>  	sphy = phy_to_sphy(phy);
> 
> @@ -211,7 +209,7 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
>  		return;
>  	}
> 
> -	spin_lock_irqsave(&sphy->lock, flags);
> +	mutex_lock(&sphy->mutex);
> 
>  	/* setting default phy-type for USB 3.0 */
>  	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
> @@ -223,7 +221,7 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
>  	if (sphy->drv_data->set_isolation)
>  		sphy->drv_data->set_isolation(sphy, true);
> 
> -	spin_unlock_irqrestore(&sphy->lock, flags);
> +	mutex_unlock(&sphy->mutex);
> 
>  	clk_disable_unprepare(sphy->clk);
>  }
> @@ -279,7 +277,7 @@ static int samsung_usb3phy_probe(struct platform_device *pdev)
>  	if (sphy->ref_clk_freq < 0)
>  		return -EINVAL;
> 
> -	spin_lock_init(&sphy->lock);
> +	mutex_init(&sphy->mutex);
> 
>  	platform_set_drvdata(pdev, sphy);
> 
> --
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

