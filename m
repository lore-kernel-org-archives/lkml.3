Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaAHR4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:56:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31947 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaAHR43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:56:29 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-24-52cd914a9434
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        stern@rowland.harvard.edu
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
 <1387545857-9472-4-git-send-email-k.debski@samsung.com>
 <52CA818A.4090403@ti.com>
In-reply-to: <52CA818A.4090403@ti.com>
Subject: RE: [PATCH v5 3/9] phy: Add new Exynos USB 2.0 PHY driver
Date: Wed, 08 Jan 2014 18:56:25 +0100
Message-id: <04dc01cf0c9a$f37c24d0$da746e70$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8Kx9jaUEL2ohbBR8eDk8531M71zgB0TFIA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xq7peE88GGWw/JWWxZPcNVov5R86x
	WvS/Wchq0XblILvF5YWXWC0uPO1hszjb9AbI3TWHzWLG+X1MFouWtTJbrD1yl93ibP9tNouJ
	TdPYLc5v6WSyOPymndViwu8LbBbrZ7xmsWhb/YHVouPsQXYHYY/Lfb1MHjtn3WX3uHNtD5vH
	v2PsHrPv/mD06NuyitHj+I3tTB6fN8kFcERx2aSk5mSWpRbp2yVwZfx90sFS8E+m4v7uvewN
	jF1iXYycHBICJhLrr/1hgrDFJC7cW8/WxcjFISSwlFHi9+d/zBBOA5PE/glfgKo4ONgENCVW
	3fMAaRAR0JFYeHo9WA2zwEwWiY+fpzJBNMxklJi16gszSBWngJrEggtvGUFsYQEniYa399lA
	bBYBVYm9l76zgti8Ag4Ss5f9ZYSwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8gREgLqEo/+
	6kIcYSRxsX0HM0SJiMTdhuesExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqaXJBcVJ6rqFecWJu
	cWleul5yfu4mRkgMf9nBuPiY1SFGAQ5GJR5ejtqzQUKsiWXFlbmHGCU4mJVEeK8XA4V4UxIr
	q1KL8uOLSnNSiw8xMnFwSjUwemkr58vdOZ3/essT/0thr67qMjuZSG3+cmCPmKVY5rxVp69/
	PR/T3SzZ8VrDd+KJxDrO/c1RzkfeHPvp7Xn7daSYetmzX9dd/+5j2T5VeP/krmxjlgW3OX7V
	Gcz+o/1/UrN5kmXImur9HodOTZw7/UtBPd/zT4V71+vwnLU7NM93W8jliTxLwpVYijMSDbWY
	i4oTAdLPsue/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Monday, January 06, 2014 11:12 AM
> 
> Hi,
> 
> On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
> > Add a new driver for the Exynos USB 2.0 PHY. The new driver uses the
> > generic PHY framework. The driver includes support for the Exynos
> 4x10
> > and 4x12 SoC families.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >   .../devicetree/bindings/phy/samsung-phy.txt        |   55 ++++
> >   drivers/phy/Kconfig                                |   29 ++
> >   drivers/phy/Makefile                               |    3 +
> >   drivers/phy/phy-exynos4210-usb2.c                  |  257
> ++++++++++++++++
> >   drivers/phy/phy-exynos4212-usb2.c                  |  306
> ++++++++++++++++++++
> >   drivers/phy/phy-samsung-usb2.c                     |  226
> +++++++++++++++
> >   drivers/phy/phy-samsung-usb2.h                     |   67 +++++
> >   7 files changed, 943 insertions(+)
> >   create mode 100644 drivers/phy/phy-exynos4210-usb2.c
> >   create mode 100644 drivers/phy/phy-exynos4212-usb2.c
> >   create mode 100644 drivers/phy/phy-samsung-usb2.c
> >   create mode 100644 drivers/phy/phy-samsung-usb2.h
> >
> .
> .
> <snip>
> .
> .
> 
> > diff --git a/drivers/phy/phy-samsung-usb2.h
> > b/drivers/phy/phy-samsung-usb2.h new file mode 100644 index
> > 0000000..ab89f91
> > --- /dev/null
> > +++ b/drivers/phy/phy-samsung-usb2.h
> > @@ -0,0 +1,67 @@
> > +/*
> > + * Samsung SoC USB 1.1/2.0 PHY driver
> > + *
> > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > + * Author: Kamil Debski <k.debski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef _PHY_EXYNOS_USB2_H
> > +#define _PHY_EXYNOS_USB2_H
> > +
> > +#include <linux/clk.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/device.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spinlock.h>
> > +
> > +#define KHZ 1000
> > +#define MHZ (KHZ * KHZ)
> > +
> > +struct samsung_usb2_phy_driver;
> > +struct samsung_usb2_phy_instance;
> > +struct samsung_usb2_phy_config;
> > +
> > +struct samsung_usb2_phy_instance {
> > +	const struct samsung_usb2_common_phy *cfg;
> > +	struct clk *clk;
> > +	struct phy *phy;
> > +	struct samsung_usb2_phy_driver *drv;
> > +	unsigned long rate;
> > +	u32 clk_reg_val;
> > +	bool enabled;
> > +};
> > +
> > +struct samsung_usb2_phy_driver {
> > +	const struct samsung_usb2_phy_config *cfg;
> > +	struct clk *clk;
> > +	struct device *dev;
> > +	void __iomem *reg_phy;
> > +	struct regmap *reg_pmu;
> > +	struct regmap *reg_sys;
> > +	spinlock_t lock;
> > +	struct samsung_usb2_phy_instance instances[0];
> 
> I think having instances as array here would allocate more space while
> allocating 'samsung_usb2_phy_driver' in 'samsung_usb2_phy_probe'.
> 

I am not sure if I understand you correctly here. Maybe I will explain
what I intended to write. An array with size 0 at the end of a structure
takes no space in the structure. The benefit of using it is that after
the structure one can allocate a number of the array elements and
address them easily. Another option would be placing pointer in the
samsung_usb2_phy_instance and allocate memory separately, but this would
involve two allocations and a pointer would be always present in the 
structure.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland



