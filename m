Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaCFJCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:02:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13196 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaCFJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:02:26 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-2e-5318399f84dc
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
In-reply-to: <5318384B.7020009@ti.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 18:02:22 +0900
Message-id: <006301cf391a$c99c7280$5cd55780$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85GgmZfoxLgW4rTLqFe8gqPp77bwAACVdg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t8zY935lhLBBk0XVCzmHznHatH/ZiGr
	RduVg+wWlxdeYrX48foCm8WFpz1sFmeb3gDFds1hs5hxfh+TxaJlrcwWa4/cZbc423+bzWJi
	0zR2i/NbOpksDr9pZ7VYcW83u8WE30C962e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l9/j0
	djGzx51re9g8/h1j95h99wejR9+WVYwex29sZ/L4vEkugDOKyyYlNSezLLVI3y6BK2PhrUVs
	BU8kK2ZP+87cwLhPpIuRk0NCwERiw8I1jBC2mMSFe+vZuhi5OIQEljFKLNr5nR2maM2NPWBF
	QgLTGSVOftCGKPrHKPHx9ApWkASbgJHEy4MbmUESIgIXGSWmTt/LCOIwC9xhkvgyfx8TRMtq
	Jom3y6YzgbRwCqhJHNxwlgXEFhZwkrjwvBEsziKgKnFz2iWwfbwCLhKveldD2YISPybfA6tn
	FtCT+PjnNiOELS+xec1boNUcQLeqSzz6qwsSFgG66PjeOcwQJeISkx48ZAe5QULgDYfEzD6I
	+SwCAhLfJh9igeiVldh0gBniZUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT
	0otM9YoTc4tL89L1kvNzNzFCUs3EHYz3D1gfYkwGWj+RWUo0OR+YqvJK4g2NzYwsTE1MjY3M
	Lc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTF4XtmBbw7BaR1nb66X8bP9
	pZMSy2xTMy3f7OTCBpOav8vPv9wZEMkjHMnudf5xa8S2Nbs2OPF1HmUzkf6id9f1VgG/cnm4
	2oRpHvcFIg13u62d/1VgjebVkggPiaRb13QZ6tgfrtwRGZd+cY2tSsA1tg2yV7lenW9V70vc
	66Nvc0fo3aYn9UosxRmJhlrMRcWJADAl1tNLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsVy+t9jQd35lhLBBksPyVnMP3KO1aL/zUJW
	i7YrB9ktLi+8xGrx4/UFNosLT3vYLM42vQGK7ZrDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7Tzmqx4t5udosJv4F61894zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7vHp
	7WJmjzvX9rB5/DvG7jH77g9Gj74tqxg9jt/YzuTxeZNcAGdUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBvSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMhbcWsRU8kayYPe07cwPjPpEuRk4OCQETiTU39jBC2GISF+6t
	ZwOxhQSmM0qc/KDdxcgFZP9jlPh4egUrSIJNwEji5cGNzCAJEYGLjBJTp+9lBHGYBe4wSXyZ
	v48JomU1k8TbZdOZQFo4BdQkDm44ywJiCws4SVx43ggWZxFQlbg57RLYbl4BF4lXvauhbEGJ
	H5PvgdUzC+hJfPxzmxHClpfYvOYt0GoOoFvVJR791QUJiwBddHzvHGaIEnGJSQ8esk9gFJqF
	ZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBieyZ9A7GVQ0WhxgF
	OBiVeHg3+IkHC7EmlhVX5h5ilOBgVhLh3WIoESzEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ
	+cAkm1cSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjC1dKt0q
	3RPi6wVLglVOv9yXuv5I/4X8iL6MTStWnJ//hvVj7cbzU19OjM6qujhzikXzJfkylYuT/OWC
	Nf+90twQ9Psyz5N9jeru1vMMy75+ydnMFm/jH/hzSsOBRaw6hZ0bjY1ft70uuPtzz5XNR4yb
	j9R9e6i08vJyM9kTOofOCXwrt7Uyy1BiKc5INNRiLipOBACguJMCqAMAAA==
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
> On Thursday 06 March 2014 02:22 PM, Anton Tikhomirov wrote:
> > Hello,
> >
> >> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> >>
> >>
> >>
> >> On Thursday 06 March 2014 01:56 PM, Anton Tikhomirov wrote:
> >>> Hi Kamil,
> >>>
> >>> ...
> >>>
> >>>> +| 3. Supporting SoCs
> >>>> ++--------------------
> >>>> +
> >>>> +To support a new SoC a new file should be added to the
> drivers/phy
> >>>> +directory. Each SoC's configuration is stored in an instance of
> the
> >>>> +struct samsung_usb2_phy_config.
> >>>> +
> >>>> +struct samsung_usb2_phy_config {
> >>>> +	const struct samsung_usb2_common_phy *phys;
> >>>> +	unsigned int num_phys;
> >>>> +	bool has_mode_switch;
> >>>
> >>> You missed rate_to_clk here.
> >>>
> >>>> +};
> >>>> +
> >>>
> >>> ...
> >>>
> >>>> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> >> samsung-
> >>>> usb2.c
> >>>> new file mode 100644
> >>>> index 0000000..c3b7719
> >>>> --- /dev/null
> >>>> +++ b/drivers/phy/phy-samsung-usb2.c
> >>>> @@ -0,0 +1,222 @@
> >>>> +/*
> >>>> + * Samsung SoC USB 1.1/2.0 PHY driver
> >>>> + *
> >>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> >>>> + * Author: Kamil Debski <k.debski@samsung.com>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or
> >>>> modify
> >>>> + * it under the terms of the GNU General Public License version 2
> >> as
> >>>> + * published by the Free Software Foundation.
> >>>> + */
> >>>> +
> >>>> +#include <linux/clk.h>
> >>>> +#include <linux/mfd/syscon.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/of.h>
> >>>> +#include <linux/of_address.h>
> >>>> +#include <linux/phy/phy.h>
> >>>> +#include <linux/platform_device.h>
> >>>> +#include <linux/spinlock.h>
> >>>> +#include "phy-samsung-usb2.h"
> >>>> +
> >>>> +static int samsung_usb2_phy_power_on(struct phy *phy)
> >>>> +{
> >>>> +	struct samsung_usb2_phy_instance *inst =
> phy_get_drvdata(phy);
> >>>> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> >>>> +	int ret;
> >>>> +
> >>>> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> >>>> +		inst->cfg->label);
> >>>> +	ret = clk_prepare_enable(drv->clk);
> >>>
> >>> clk_prepare_enable() can sleep, and therefore doesn't allow
> >>> samusng_usb2_phy_power_on() to be used in atomic context
> >>> (e.g. inside spin_lock-ed area), what sometimes may be desirable.
> >>> What about to prepare clock in probe, and just enable it here
> >>> (note: clk_enable() doesn't sleep).
> >>
> >> The PHY power-on callback is anyway called with mutex held, so I
> guess
> >> it's fine to have clk_prepare_enable() here.
> >
> > If we rely totally on generic PHY functions such as phy_power_on()
> > and friends, why do we need to use locking in callbacks at all.
> 
> Didn't get you.. We don't want to invoke power_on when init is getting
> executed or you don't want power on or power off to get executed
> simultaneously right? So we need to protect it.

I mean callbacks such as samsung_usb2_phy_power_on() which uses spin_lock.
It's already protected by mutex in phy_power_on().

> 
> Cheers
> Kishon

