Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3KFLjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:39:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29809 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3KFLjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:39:02 -0500
Date: Wed, 06 Nov 2013 12:38:54 +0100
From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <5279FB45.3010808@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Message-id: <2656549.jVSier62Qi@amdc1227>
Organization: Samsung Poland R&D Center
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7Bit
X-AuditID: cbfec7f5-b7ef66d00000795a-f3-527a2a53076a
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t/xa7rBWlVBBr9mmVks2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDbvFtJ3/WS0u75rDZjHj/D4mi0XLWpkt
	1h65y25xtv82m8X5LZ1MFofftLNadJw9yO4g6HG5r5fJY+esu+wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujLbFvYwF3XIV579MYGxgnCbexcjJISFgIrFj9wZmCFtM4sK99Wxd
	jFwcQgJLGSXmPdnGAuF0MUlMXdnGBlLFJqAm8bnhEZgtIqAlcXrnD2aQImaBncwSvT3dYKOE
	BewkHp0/wAhiswioShx/9BIsziugKXHw0nMmEJtfQF3i3banYLaogJvE9B8HwWo4gRZce/Mb
	rFdIYDajxKdGO4heQYkfk++xgNjMAvIS+/ZPZYWwtSTW7zzONIFRcBaSsllIymYhKVvAyLyK
	UTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTKvu5gXHrM6hCjAAejEg9vgnxlkBBrYllxZe4h
	RgkOZiUR3jUyVUFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOM2O4nu+f/RKGRrzpXmn27JNkYd
	7zoW1c6TfB5ter9BWu1HuX7Uv+ZKx+I9keuCEqYG7LhfGNfd3NA2S2GZyaHdPwT5doosjKzq
	fMB55ffi2tZjdqYffqbc4hBXyKkVL6pMeCASu7K0pC3z4IsV+k/OXRBhYnsVYLXKI+Cz1Dbu
	W7rH8rWnK7EUZyQaajEXFScCAGwgRdKQAgAA
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <1383668001-19141-2-git-send-email-k.debski@samsung.com>
 <5279FB45.3010808@ti.com>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon

On Wednesday 06 of November 2013 13:48:13 Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Tuesday 05 November 2013 09:43 PM, Kamil Debski wrote:
> > Add a new driver for the Exynos USB PHY. The new driver uses the generic
> > PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> > SoC families.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >   .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
> >   drivers/phy/Kconfig                                |   23 +-
> >   drivers/phy/Makefile                               |    4 +
> >   drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
> >   drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
> >   drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
> >   drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
> >   7 files changed, 995 insertions(+), 1 deletion(-)
> >   create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> >   create mode 100644 drivers/phy/phy-exynos-usb2.c
> >   create mode 100644 drivers/phy/phy-exynos-usb2.h
> >   create mode 100644 drivers/phy/phy-exynos4210-usb2.c
> >   create mode 100644 drivers/phy/phy-exynos4212-usb2.c
[snip]
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index a344f3d..bdf0fab 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
[snip]
> > @@ -51,4 +51,25 @@ config PHY_EXYNOS_DP_VIDEO
> >   	help
> >   	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
> >
> > +config PHY_EXYNOS_USB2
> > +	tristate "Samsung USB 2.0 PHY driver"
> > +	help
> > +	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
> > +	  This driver provides common interface to interact, for Samsung
> > +	  USB 2.0 PHY driver.
> 
> I still think we can get rid of this helper driver and have a single 
> driver for both PHY_EXYNOS4210_USB2 and PHY_EXYNOS4212_USB2.

This helper driver is a really nice way to avoid code duplication, while
still leaving the code clean and readable.

All the Samsung USB 2.0 PHYs require exactly the same semantics
(isolation, reference rate configuration, power up, power on), but each
one has completely different layout of registers and bits inside
registers.

Making a big single driver would end up being identical to the old Exynos
USB2PHY driver with a lot of if and switch statements inside most of
functions, which is not only ugly but makes any further extension hard.

In addition, this approach makes it possible to disable support for SoCs
that are not needed in particular use cases, allowing smaller kernel
images.

> > +
> > +config PHY_EXYNOS4210_USB2
> > +	bool "Support for Exynos 4210"
> > +	depends on PHY_EXYNOS_USB2
> > +	depends on CPU_EXYNOS4210
> > +	help
> > +	  Enable USB PHY support for Exynos 4210
> > +
> > +config PHY_EXYNOS4212_USB2
> > +	bool "Support for Exynos 4212"
> > +	depends on PHY_EXYNOS_USB2
> > +	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
> > +	help
> > +	  Enable USB PHY support for Exynos 4212
> > +
> >   endmenu
[snip]
> > +extern const struct usb2_phy_config exynos4210_usb2_phy_config;
> > +extern const struct usb2_phy_config exynos4212_usb2_phy_config;
> > +
> > +static const struct of_device_id exynos_usb2_phy_of_match[] = {
> > +#ifdef CONFIG_PHY_EXYNOS4210_USB2
> 
> I don't think you'll need #ifdef here. Anyways the driver data can be 
> obtained using the appropriate compatible value in dt data no?

Huh?

This is not about driver data, but rather about the ability to match the
driver only to devices that are actually supported with selected Kconfig
options.

Best regards,
Tomasz

