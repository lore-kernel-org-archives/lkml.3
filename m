Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab3LINgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:36:04 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20393 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3LINf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:35:56 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-98-52a5c7390f18
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-4-git-send-email-k.debski@samsung.com>
 <52A1ADFF.4060207@ti.com> <00fc01cef2a0$263acd00$72b06700$%debski@samsung.com>
 <52A577AA.2020908@ti.com>
In-reply-to: <52A577AA.2020908@ti.com>
Subject: RE: [PATCH v4 3/9] phy: Add new Exynos USB PHY driver
Date: Mon, 09 Dec 2013 14:35:52 +0100
Message-id: <01ec01cef4e3$9550d820$bff28860$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac70tDKRBCR1VvuXTP6oJe6tSxXFPwAKemEA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t/xa7qWx5cGGZxps7FYsvsGq8XB+/UW
	84+cY7Xof7OQ1aLtykF2i+bF69ksLi+8xGpx4WkPm8XZpjfsFpd3zWGzmHF+H5PFomWtzBZr
	j9xltzjbf5vNYmLTNHaL81s6mSwOv2lntVg/4zWLRcfZg+wOwh6X+3qZPHbOusvucefaHjaP
	/XPXsHv0bVnF6HH8xnYmj8+b5ALYo7hsUlJzMstSi/TtErgyvv+SKXjoXvHq2lz2Bsb9Fl2M
	nBwSAiYSr3dPZoSwxSQu3FvP1sXIxSEksJRRYv6pZ1BOA5PEhnebmLoYOTjYBDQlVt3zAGkQ
	EdCRWHh6PTNIDbPAPBaJzmVXmSAa3jBK/H/XCzaWU0BN4unmDmYQW1jATuL89i5GkEEsAqoS
	XfucQcK8Ag4St9bcZYGwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6EDcYSbx7
	8Z8RokRE4m7Dc9YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLU0uaA4KT3XSK84Mbe4NC9dLzk/
	dxMjJGq/7mBceszqEKMAB6MSD28A89IgIdbEsuLK3EOMEhzMSiK8YruAQrwpiZVVqUX58UWl
	OanFhxiZODilGhhtSiZ+nsh5KUd2zTzubyUL8vcVz3/CF3VqQbPxtAAGY9PL77YmpN9vMkt1
	6D4Uc5itfdY6zWM+d3u3ms+5eYLt0DlxfkHr1ebuE+t4TO56ux0JPHphwnS3tDJ5/QPrFmuF
	Vux9Jpj+e+VTrtw+97uFRh8W9p6bEJl4Iv5lOKPHoVnzNd1Y9JmUWIozEg21mIuKEwGSojIl
	uAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Monday, December 09, 2013 8:56 AM
> 
> Hi,
> 
> On Friday 06 December 2013 09:58 PM, Kamil Debski wrote:
> > Hi Kishon,
> >
> > Thank you for the review.
> >
> >> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> >> Sent: Friday, December 06, 2013 11:59 AM
> >>
> >> Hi,
> >>
> >> On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> >>> Add a new driver for the Exynos USB PHY. The new driver uses the
> >>> generic PHY framework. The driver includes support for the Exynos
> >> 4x10
> >>> and 4x12 SoC families.
> >>>
> >>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>> ---
> 
> 
> <snip>
> .
> .
> >>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
> >>> d0caae9..9f4befd 100644
> >>> --- a/drivers/phy/Makefile
> >>> +++ b/drivers/phy/Makefile
> >>> @@ -7,3 +7,6 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-
> exynos-dp-
> >> video.o
> >>>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-
> video.o
> >>>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> >>>   obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> >>> +obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
> >>> +obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
> >>> +obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
> >>> diff --git a/drivers/phy/phy-exynos4210-usb2.c
> >>> b/drivers/phy/phy-exynos4210-usb2.c
> >>> new file mode 100644
> >>> index 0000000..a02e5c2
> >>> --- /dev/null
> >>> +++ b/drivers/phy/phy-exynos4210-usb2.c
> >>> @@ -0,0 +1,264 @@
> >>> +/*
> >>> + * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4210 support
> >>> + *
> >>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> >>> + * Author: Kamil Debski <k.debski@samsung.com>
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or
> >>> +modify
> >>> + * it under the terms of the GNU General Public License version 2
> >>> +as
> >>> + * published by the Free Software Foundation.
> >>> + */
> >>> +
> >>> +#include <linux/clk.h>
> >>> +#include <linux/delay.h>
> >>> +#include <linux/io.h>
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/of.h>
> >>> +#include <linux/of_address.h>
> >>> +#include <linux/phy/phy.h>
> >>> +#include <linux/platform_device.h>
> >>> +#include <linux/regmap.h>
> >>> +#include <linux/spinlock.h>
> >>
> >> You've included most of the above header files in phy-samsung-usb2.h
> >> which you are including below.
> >
> > I agree that includes in phy-samsung-usb2.h could use a cleanup. On
> > the other hand my opinion is that a .c file should include all .h
> > files that are used in this .c file. Relaying on .h file to include
> > another .h doesn't seem good to me.
> 
> then remove it in .h file.
> >
> >>> +#include "phy-samsung-usb2.h"
> >>> +
> >>> +/* Exynos USB PHY registers */
> >>> +
> >>> +/* PHY power control */
> >>> +#define EXYNOS_4210_UPHYPWR			0x0
> >>> +
> >>> +#define EXYNOS_4210_UPHYPWR_PHY0_SUSPEND	(1 << 0)
> >>
> >> use BIT() here and everywhere below.
> >
> 
> <snip>
> .
> .
> 
> >>> +#ifdef CONFIG_PHY_EXYNOS4212_USB2
> >>> +	{
> >>> +		.compatible = "samsung,exynos4212-usb2-phy",
> >>> +		.data = &exynos4212_usb2_phy_config,
> >>> +	},
> >>> +#endif
> >>> +	{ },
> >>> +};
> >>
> >> I think we've had enough discussion about this approach. Let's get
> >> the opinion of others too. Felipe? Greg?
> >
> > Good idea.
> >
> >> Summary:
> >> We have two drivers PHY_EXYNOS4210_USB2 and PHY_EXYNOS4212_USB2 with
> >> almost similar register map [1] and a samsung helper driver for
> these
> >> two drivers.
> >
> > I would not call them separate drivers. It's a single USB 2.0 driver
> > with the option to include support for various SoCs. This patchset
> adds:
> > Exynos 4210, Exynos 4212, Exynos 5250 and S5PCV210. I know that
> > another person is working on supporting S3C6410.
> >
> >> These two PHY drivers populate the function pointers in the helper
> >> driver. So any phy_ops will first invoke the helper driver which
> will
> >> then invoke the corresponding phy driver.
> >>
> >> [1] -> http://www.diffchecker.com/7yno1uvk
> >
> > Come on, this diff only includes the registers part of the file.
> > The following functions are also different:
> > - exynos421*_rate_to_clk
> > - exynos421*_isol
> > - exynos421*_phy_pwr
> > - exynos421*_power_on
> > - exynos421*_power_on
> 
> But most of the differences is because your 4212 has additional
> features in HSIC and supports more clock rates.
> >
> > It seems that the file is too large for the tool. But still this
> makes
> > a false impression that only registers are different.
> >
> >> Advantages:
> >> * (more) clean and readable
> >> * helper driver can be used with other PHY drivers which will be
> >> added soon
> >>
> >> Disadvantages:
> >> * code duplication
> >
> > I would say that actually in this case less code is duplicated.
> Having
> > Separate drivers would mean that most of the phy-samsung-usb2.c file
> > has
> 
> I actually meant a single driver for 4210 and 4212.
> 
> your current code has separate drivers for different versions of the
> same IP. If you have a single driver for the different versions, it
> will lead to a lot less code duplication (hint: I'v given the exact
> 'same'
> comment at-least twice in this patch).

You wrote more than twice, I know. I also replied quite a few times. 
I want to explain that this is not a driver for Exynos 4210 and 4212 only.
It is a driver for more SoCs with different IPs.
Like Exynos 5250, S5PV210 and I am sure many more are to follow.
The other two patches in this series add new functionality to this driver
and are not separate drivers.

It is a single driver with custom functions for separate SoC and separate
versions of the same IP. In my opinion it will lead to less code in the
kernel. But we have different opinion on that :) We agree that the code
is more clear and it is easier to manage and add support for new SoC.
Maybe we should focus more on having a clear and readable code?

Kishon, if we were talking about Exynos 4210 and 4212 only, then I could
agree with you. But this driver covers more SoCs.

> There are quite a few examples
> in the kernel where the same driver is used for multiple versions of
> the IP.
> > to be repeated. That is 240 times 4 (and surely more in the future,
> as
> > this patchset adds support for 4 SoCs). Which is almost 1000 lines
> more.
> >
> >>
> >> Maybe having a helper driver makes sense when we have other samsung
> >> PHY drivers added but not sure if it's needed here for
> >> EXYNOS4210_USB2 and
> >> EXYNOS4212_USB2
> >>
> >> Need your inputs on what you think about this.
> >
> > Yes, I would also welcome other people's opinions.
> >
> >>> +
> >>> +static int samsung_usb2_phy_probe(struct platform_device *pdev) {
> >>> +	const struct of_device_id *match;
> >>> +	const struct samsung_usb2_phy_config *cfg;
> >>> +	struct clk *clk;
> >>> +	struct device *dev = &pdev->dev;
> >>> +	struct phy_provider *phy_provider;
> >>> +	struct resource *mem;
> >>> +	struct samsung_usb2_phy_driver *drv;
> >>> +	int i;
> >>> +
> >>> +	if (!pdev->dev.of_node) {
> >>> +		dev_err(dev, "This driver is required to be instantiated
> >> from device tree\n");
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> 
> <snip>
> .
> .
> >>> +	int (*power_on)(struct samsung_usb2_phy_instance *);
> >>> +	int (*power_off)(struct samsung_usb2_phy_instance *); };
> >>> +
> >>> +
> >>> +struct samsung_usb2_phy_config {
> >>> +	int num_phys;
> >>> +	const struct samsung_usb2_common_phy *phys;
> >>> +	char has_mode_switch;
> >>
> >> u8 instead?
> >
> > Do we really need to specify that we need 8bits? Why do you think
> char
> > is wrong?
> 
> Do you really assign a char? Having a char data type and assigning an
> integer is misleading.
> >
> > Please read this paragraph from LDD3:
> > "Sometimes kernel code requires data items of a specific size,
> perhaps
> > to match predefined binary structures,* to communicate with user
> > space, or to align data within structures by inserting "padding"
> > fields (but refer to the section "Data Alignment" for information
> > about alignment issues)."
> > Chapter 11, page 290 http://lwn.net/images/pdf/LDD3/ch11.pdf
> >
> > has_mode_switch is only a flag 0 or 1. Never written anywhere in
> > hardware registers. Used in an if somewhere in code. Give me a good
> > reason why do you think it should be explicitly 8 bit long.
> 
> I just thought you created a char type to assign an integer value is
> you wanted to some data type which is 8 bits long. If it is for any
> other reason you used a char data type, pls let us know.
> 

You must have missed the message I sent soon after the one you replied
to - bool is the best candidate for has_mode_switch.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


