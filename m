Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaCGFQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:16:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43834 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaCGFQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:16:09 -0500
X-AuditID: cbfee68e-b7f566d000002344-05-531956164e7f
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Kamil Debski'" <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        jg1.han@samsung.com, galak@codeaurora.org, matt.porter@linaro.org,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu,
        sander@humilis.net
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
 <1394033288-5551-4-git-send-email-k.debski@samsung.com>
 <005c01cf3915$c53476c0$4f9d6440$%tikhomirov@samsung.com>
 <53183220.3040606@ti.com>
 <006201cf3919$5f760750$1e6215f0$%tikhomirov@samsung.com>
 <5318384B.7020009@ti.com>
 <006301cf391a$c99c7280$5cd55780$%tikhomirov@samsung.com>
 <006501cf391d$335fb9a0$9a1f2ce0$%tikhomirov@samsung.com>
 <53183F98.1060100@ti.com>
In-reply-to: <53183F98.1060100@ti.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Fri, 07 Mar 2014 14:16:06 +0900
Message-id: <003c01cf39c4$57aa8540$06ff8fc0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85Hq62Cp4mKTqOQmiRHIw1Z7nQVwApVdiQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t8zY12xMMlgg83zLSzmHznHatH/ZiGr
	RduVg+wWlxdeYrX48foCm8WFpz1sFmeb3gDFds1hs5hxfh+TxaJlrcwWa4/cZbc423+bzWJi
	0zR2i/NbOpksDr9pZ7VYcW83u8WE30C962e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l9/j0
	djGzx51re9g8/h1j95h99wejR9+WVYwex29sZ/L4vEkugDOKyyYlNSezLLVI3y6BK+PBu7ss
	BfuVKhZffcDYwHhNuouRk0NCwETidMNBRghbTOLCvfVsXYxcHEICyxgldhxuYYEp+rX+EDNE
	YhGjxJYdUxghnH+MEgcPvAFrZxMwknh5cCNYlYjARUaJqdP3glUxC9xhkvgyfx8TRMteZok9
	H84zgbRwCqhJ/LmzmQ3EFhZwkrjwvBEsziKgKrHifQNQNwcHr4CLxN8nZiBhXgFBiR+T74Hd
	xCygJ/Hxz21GCFteYvOat8wg5RIC6hKP/uqChEWADrq2YBozRIm4xKQHD9lBTpAQ+MAhsfvI
	ThaIVQIS3yYfYoHolZXYdIAZ4mVJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguK
	k9KLjPSKE3OLS/PS9ZLzczcxQlJN3w7GmwesDzEmA62fyCwlmpwPTFV5JfGGxmZGFqYmpsZG
	5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRcIMv90cWniobwY235p14
	7lKv+uWA4+aDzIr3fk78H/TR8YfVa6ZnF4LYZyf3TF33s8LF/3efx0H309qRDsoBfbE8V1WP
	FBz8JeMbPy1EjHP9XbmNNj4Ldx6Wtmopst8mqRkUNZXrgcFGn9qG7OvnCqfpv9HVXW4bKq6w
	muV9p4TII+XEwgIlluKMREMt5qLiRAC42ZIgSwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsVy+t9jAV2xMMlgg+5Vhhbzj5xjteh/s5DV
	ou3KQXaLywsvsVr8eH2BzeLC0x42i7NNb4Biu+awWcw4v4/JYtGyVmaLtUfusluc7b/NZjGx
	aRq7xfktnUwWh9+0s1qsuLeb3WLCb6De9TNes1i0rf7AatFx9iC7g4jH5b5eJo+ds+6ye3x6
	u5jZ4861PWwe/46xe8y++4PRo2/LKkaP4ze2M3l83iQXwBnVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SbkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHjwbu7LAX7lSoWX33A2MB4TbqLkZNDQsBE4tf6Q8wQtpjEhXvr
	2boYuTiEBBYxSmzZMYURwvnHKHHwwBtGkCo2ASOJlwc3MoMkRAQuMkpMnb4XrIpZ4A6TxJf5
	+5ggWvYyS+z5cJ4JpIVTQE3iz53NbCC2sICTxIXnjWBxFgFViRXvG4C6OTh4BVwk/j4xAwnz
	CghK/Jh8jwXEZhbQk/j45zYjhC0vsXnNW2aQcgkBdYlHf3VBwiJAB11bMI0ZokRcYtKDh+wT
	GIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ7Jr2DcVWD
	xSFGAQ5GJR7ejkUSwUKsiWXFlbmHGCU4mJVEeI0DJYOFeFMSK6tSi/Lji0pzUosPMSYD/TmR
	WUo0OR+YZPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgdEr
	ZMJVWcNqBonDkfcnvnzNt/1OZuiDULH2Gf1XjlXPU7nrrFgjP+vW+vZkjulnCz+kaJ4r/qK5
	ek3N4YDSayURqtOsYsU02o4nMHYXK5pNVJSP3SU3z15XuODf160hfySPvLNVCHw2d+n6xW0y
	xa3+TNM3izkcVOy5P0+Xe+6xM9evHM+7bqjEUpyRaKjFXFScCADve0GcqAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> 
> Hi,
> 
> On Thursday 06 March 2014 02:49 PM, Anton Tikhomirov wrote:
> > Hi,
> >
> >> Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> >>
> >> Hi,
> >>
> >>> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> >>>
> >>> Hi,
> >>>
> >>> On Thursday 06 March 2014 02:22 PM, Anton Tikhomirov wrote:
> >>>> Hello,
> >>>>
> >>>>> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY
> driver
> >>>>>
> >>>>>
> >>>>>
> >>>>> On Thursday 06 March 2014 01:56 PM, Anton Tikhomirov wrote:
> >>>>>> Hi Kamil,
> >>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>>> +| 3. Supporting SoCs
> >>>>>>> ++--------------------
> >>>>>>> +
> >>>>>>> +To support a new SoC a new file should be added to the
> >>> drivers/phy
> >>>>>>> +directory. Each SoC's configuration is stored in an instance
> of
> >>> the
> >>>>>>> +struct samsung_usb2_phy_config.
> >>>>>>> +
> >>>>>>> +struct samsung_usb2_phy_config {
> >>>>>>> +	const struct samsung_usb2_common_phy *phys;
> >>>>>>> +	unsigned int num_phys;
> >>>>>>> +	bool has_mode_switch;
> >>>>>>
> >>>>>> You missed rate_to_clk here.
> >>>>>>
> >>>>>>> +};
> >>>>>>> +
> >>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>>> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> >>>>> samsung-
> >>>>>>> usb2.c
> >>>>>>> new file mode 100644
> >>>>>>> index 0000000..c3b7719
> >>>>>>> --- /dev/null
> >>>>>>> +++ b/drivers/phy/phy-samsung-usb2.c
> >>>>>>> @@ -0,0 +1,222 @@
> >>>>>>> +/*
> >>>>>>> + * Samsung SoC USB 1.1/2.0 PHY driver
> >>>>>>> + *
> >>>>>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> >>>>>>> + * Author: Kamil Debski <k.debski@samsung.com>
> >>>>>>> + *
> >>>>>>> + * This program is free software; you can redistribute it
> >> and/or
> >>>>>>> modify
> >>>>>>> + * it under the terms of the GNU General Public License
> version
> >> 2
> >>>>> as
> >>>>>>> + * published by the Free Software Foundation.
> >>>>>>> + */
> >>>>>>> +
> >>>>>>> +#include <linux/clk.h>
> >>>>>>> +#include <linux/mfd/syscon.h>
> >>>>>>> +#include <linux/module.h>
> >>>>>>> +#include <linux/of.h>
> >>>>>>> +#include <linux/of_address.h>
> >>>>>>> +#include <linux/phy/phy.h>
> >>>>>>> +#include <linux/platform_device.h>
> >>>>>>> +#include <linux/spinlock.h>
> >>>>>>> +#include "phy-samsung-usb2.h"
> >>>>>>> +
> >>>>>>> +static int samsung_usb2_phy_power_on(struct phy *phy)
> >>>>>>> +{
> >>>>>>> +	struct samsung_usb2_phy_instance *inst =
> >>> phy_get_drvdata(phy);
> >>>>>>> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> >>>>>>> +	int ret;
> >>>>>>> +
> >>>>>>> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> >>>>>>> +		inst->cfg->label);
> >>>>>>> +	ret = clk_prepare_enable(drv->clk);
> >>>>>>
> >>>>>> clk_prepare_enable() can sleep, and therefore doesn't allow
> >>>>>> samusng_usb2_phy_power_on() to be used in atomic context
> >>>>>> (e.g. inside spin_lock-ed area), what sometimes may be desirable.
> >>>>>> What about to prepare clock in probe, and just enable it here
> >>>>>> (note: clk_enable() doesn't sleep).
> >>>>>
> >>>>> The PHY power-on callback is anyway called with mutex held, so I
> >>> guess
> >>>>> it's fine to have clk_prepare_enable() here.
> >>>>
> >>>> If we rely totally on generic PHY functions such as phy_power_on()
> >>>> and friends, why do we need to use locking in callbacks at all.
> >>>
> >>> Didn't get you.. We don't want to invoke power_on when init is
> >> getting
> >>> executed or you don't want power on or power off to get executed
> >>> simultaneously right? So we need to protect it.
> >>
> >> I mean callbacks such as samsung_usb2_phy_power_on() which uses
> >> spin_lock.
> >> It's already protected by mutex in phy_power_on().
> >
> > Well... phy_power_on() uses mutex to protect power_on() callback.
> > power_on() is samsung_usb2_phy_power_on() in our case.
> > samsung_usb2_phy_power_on() uses spinlock.
> > My question is why do we need to use spinlock _inside_ callback
> > if it is already protected by mutex.
> 
> It is needed when the same PHY provider implements multiple PHYs.
> phy-core can protect phy-ops of same PHY. However if the PHY provider
> implements multiple PHYs, phy-core won't be able to protect.

Thank you Kishon. Now it's clear.

