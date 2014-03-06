Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaCFJTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:19:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38329 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaCFJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:19:42 -0500
X-AuditID: cbfee68e-b7f566d000002344-74-53183dabcee8
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
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
In-reply-to: <006301cf391a$c99c7280$5cd55780$%tikhomirov@samsung.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 18:19:39 +0900
Message-id: <006501cf391d$335fb9a0$9a1f2ce0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85GgmZfoxLgW4rTLqFe8gqPp77bwAACVdgAAB2LJA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t8zQ901thLBBr9nMlos2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosV93azW0z4DdS7fsZrFou21R9YLTrOHmR3EPW43NfL5LFz
	1l12j09vFzN73Lm2h83j3zF2j9l3fzB69G1Zxehx/MZ2Jo/Pm+QCOKO4bFJSczLLUov07RK4
	Mh5e3cNa0CBX8f5oE3sD43bxLkZODgkBE4kzP7YyQ9hiEhfurWfrYuTiEBJYxihx/s0VoAQH
	WNHMvU4Q8UWMEkduXIQq+scosfnJcUaQbjYBI4mXBzcygyREBJqZJG5smsEO4jAL3GGS+DJ/
	HxNEyzMmidnr9jCCzOUUcJV401sA0i0s4CRx4XkjE4jNIqAq8fD+AVaQEl4BF4nD61NAwrwC
	ghI/Jt9jAbGZBfQkPv65zQhhy0tsXvMW6lJ1iUd/dUHCIgJWEgc+XIIqF5eY9OAh2DkSAl84
	JFa9ec8GsUpA4tvkQywQvbISmw5AQ0JS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC
	5ILipPQiI73ixNzi0rx0veT83E2MkITTt4Px5gHrQ4zJQOsnMkuJJucDE1ZeSbyhsZmRhamJ
	qbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBMLNXVXBr04011UNw+
	rY7t9RuFTvkGnLTXVbDwOVKay5Y0N9vumIuhubD61+pXC24LJuYYdW9kfPrnjVCZ+cs37Tc5
	f3n5Wvfxq6f97jvYWyLUU9to/qszOmdKgIHcqm1/ypU2/Zho18HyUv/Y0qsWq5X/TRdOcntw
	/7bf4vXNy0JnWC83T1FiKc5INNRiLipOBAB2Vb18TgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsVy+t9jAd3VthLBBt/Pmlss2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosV93azW0z4DdS7fsZrFou21R9YLTrOHmR3EPW43NfL5LFz
	1l12j09vFzN73Lm2h83j3zF2j9l3fzB69G1Zxehx/MZ2Jo/Pm+QCOKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgB5UUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWY8vLqHtaBBruL90Sb2Bsbt4l2MHBwSAiYSM/c6dTFy
	ApliEhfurWfrYuTiEBJYxChx5MZFKOcfo8TmJ8cZQarYBIwkXh7cyAySEBFoZpK4sWkGO4jD
	LHCHSeLL/H1MEC3PmCRmr9vDCLKDU8BV4k1vAUi3sICTxIXnjUwgNouAqsTD+wdYQUp4BVwk
	Dq9PAQnzCghK/Jh8jwXEZhbQk/j45zYjhC0vsXnNW2aIq9UlHv3VBQmLCFhJHPhwCapcXGLS
	g4fsExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnA6eya9
	g3FVg8UhRgEORiUe3g1+4sFCrIllxZW5hxglOJiVRHi3GEoEC/GmJFZWpRblxxeV5qQWH2JM
	BvpzIrOUaHI+MNXmlcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwen
	VAOjHpONxZLVGWs6BBf9/aITavTNK5T308K529bMkL7l5vzFL+Aeq1Xs6r2mR/jm8wct9WhS
	1eoy/XdU3yApa2bg1ku5l664PCl7MO/qUgGTsjkzPFi/tq1S/dHv/9YiMfDoouWr9+t9DSpX
	vPiL5ahn0vwj9RM2sl3cXj3v8tW5PRNfBjg7vnvgpsRSnJFoqMVcVJwIAMxQD5arAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> 
> Hi,
> 
> > Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> >
> > Hi,
> >
> > On Thursday 06 March 2014 02:22 PM, Anton Tikhomirov wrote:
> > > Hello,
> > >
> > >> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> > >>
> > >>
> > >>
> > >> On Thursday 06 March 2014 01:56 PM, Anton Tikhomirov wrote:
> > >>> Hi Kamil,
> > >>>
> > >>> ...
> > >>>
> > >>>> +| 3. Supporting SoCs
> > >>>> ++--------------------
> > >>>> +
> > >>>> +To support a new SoC a new file should be added to the
> > drivers/phy
> > >>>> +directory. Each SoC's configuration is stored in an instance of
> > the
> > >>>> +struct samsung_usb2_phy_config.
> > >>>> +
> > >>>> +struct samsung_usb2_phy_config {
> > >>>> +	const struct samsung_usb2_common_phy *phys;
> > >>>> +	unsigned int num_phys;
> > >>>> +	bool has_mode_switch;
> > >>>
> > >>> You missed rate_to_clk here.
> > >>>
> > >>>> +};
> > >>>> +
> > >>>
> > >>> ...
> > >>>
> > >>>> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> > >> samsung-
> > >>>> usb2.c
> > >>>> new file mode 100644
> > >>>> index 0000000..c3b7719
> > >>>> --- /dev/null
> > >>>> +++ b/drivers/phy/phy-samsung-usb2.c
> > >>>> @@ -0,0 +1,222 @@
> > >>>> +/*
> > >>>> + * Samsung SoC USB 1.1/2.0 PHY driver
> > >>>> + *
> > >>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > >>>> + * Author: Kamil Debski <k.debski@samsung.com>
> > >>>> + *
> > >>>> + * This program is free software; you can redistribute it
> and/or
> > >>>> modify
> > >>>> + * it under the terms of the GNU General Public License version
> 2
> > >> as
> > >>>> + * published by the Free Software Foundation.
> > >>>> + */
> > >>>> +
> > >>>> +#include <linux/clk.h>
> > >>>> +#include <linux/mfd/syscon.h>
> > >>>> +#include <linux/module.h>
> > >>>> +#include <linux/of.h>
> > >>>> +#include <linux/of_address.h>
> > >>>> +#include <linux/phy/phy.h>
> > >>>> +#include <linux/platform_device.h>
> > >>>> +#include <linux/spinlock.h>
> > >>>> +#include "phy-samsung-usb2.h"
> > >>>> +
> > >>>> +static int samsung_usb2_phy_power_on(struct phy *phy)
> > >>>> +{
> > >>>> +	struct samsung_usb2_phy_instance *inst =
> > phy_get_drvdata(phy);
> > >>>> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> > >>>> +	int ret;
> > >>>> +
> > >>>> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> > >>>> +		inst->cfg->label);
> > >>>> +	ret = clk_prepare_enable(drv->clk);
> > >>>
> > >>> clk_prepare_enable() can sleep, and therefore doesn't allow
> > >>> samusng_usb2_phy_power_on() to be used in atomic context
> > >>> (e.g. inside spin_lock-ed area), what sometimes may be desirable.
> > >>> What about to prepare clock in probe, and just enable it here
> > >>> (note: clk_enable() doesn't sleep).
> > >>
> > >> The PHY power-on callback is anyway called with mutex held, so I
> > guess
> > >> it's fine to have clk_prepare_enable() here.
> > >
> > > If we rely totally on generic PHY functions such as phy_power_on()
> > > and friends, why do we need to use locking in callbacks at all.
> >
> > Didn't get you.. We don't want to invoke power_on when init is
> getting
> > executed or you don't want power on or power off to get executed
> > simultaneously right? So we need to protect it.
> 
> I mean callbacks such as samsung_usb2_phy_power_on() which uses
> spin_lock.
> It's already protected by mutex in phy_power_on().

Well... phy_power_on() uses mutex to protect power_on() callback.
power_on() is samsung_usb2_phy_power_on() in our case.
samsung_usb2_phy_power_on() uses spinlock.
My question is why do we need to use spinlock _inside_ callback
if it is already protected by mutex.



