Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaCFIw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:52:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55481 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaCFIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:52:23 -0500
X-AuditID: cbfee68e-b7f566d000002344-aa-5318373fee2a
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
In-reply-to: <53183220.3040606@ti.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 17:52:15 +0900
Message-id: <006201cf3919$5f760750$1e6215f0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac85FnrWZKuyndfUQzSEi6dqu4vhFgAAiZLQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t8zA117c4lggwuzrCzmHznHatH/ZiGr
	RduVg+wWlxdeYrX48foCm8WFpz1sFmeb3gDFds1hs5hxfh+TxaJlrcwWa4/cZbc423+bzWJi
	0zR2i/NbOpksDr9pZ7VYcW83u8WE30C962e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l9/j0
	djGzx51re9g8/h1j95h99wejR9+WVYwex29sZ/L4vEkugDOKyyYlNSezLLVI3y6BK+PdtDmM
	BUdEKiatvcHYwDhboIuRk0NCwETi75tuNghbTOLCvfVANheHkMAyRome79PYYYoWnWplgkgs
	YpRYtv49K0hCSOAfo8Sv5hwQm03ASOLlwY3MIEUiAhcZJaZO38sI4jAL3GGS+DJ/H1T7FUaJ
	nW/OA2U4ODgF1CS29yiDdAsLOElceN7IBGKzCKhKzGj5DLaBV8BFoutML5QtKPFj8j0WEJtZ
	QE/i45/bjBC2vMTmNW+ZQUZKCKhLPPqrCxIWATpo1ck1bBAl4hKTHjxkBzlBQuANh8TETxNY
	IHYJSHybfIgFoldWYtMBZoiPJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5K
	LzLSK07MLS7NS9dLzs/dxAhJNH07GG8esD7EmAy0fiKzlGhyPjBR5ZXEGxqbGVmYmpgaG5lb
	mpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRv2Z1h6X+RU/T/1/5NL/eu+L
	EfvSRa64HN8ksP9DcOCXSW/qVyauU9y/xkWMIaI2+eDt5Q0/pE4c3CCo9KP7gOS+i40Bh705
	7KwuHxNN2nyRd82ZK2FOXNK5vIyqa9jmT/dOyhA69/9hazrndgeRtDUJV1laFCO+vr9qq1D9
	tHuyZ/zW6TP8mZVYijMSDbWYi4oTAcUNHZtKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsVy+t9jAV17c4lgg7b3xhbzj5xjteh/s5DV
	ou3KQXaLywsvsVr8eH2BzeLC0x42i7NNb4Biu+awWcw4v4/JYtGyVmaLtUfusluc7b/NZjGx
	aRq7xfktnUwWh9+0s1qsuLeb3WLCb6De9TNes1i0rf7AatFx9iC7g4jH5b5eJo+ds+6ye3x6
	u5jZ4861PWwe/46xe8y++4PRo2/LKkaP4ze2M3l83iQXwBnVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SbkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHj3bQ5jAVHRComrb3B2MA4W6CLkZNDQsBEYtGpViYIW0ziwr31
	bF2MXBxCAosYJZatf88KkhAS+Mco8as5B8RmEzCSeHlwIzNIkYjARUaJqdP3MoI4zAJ3mCS+
	zN/HBNF+hVFi55vzQBkODk4BNYntPcog3cICThIXnjeCrWMRUJWY0fIZbAOvgItE15leKFtQ
	4sfkeywgNrOAnsTHP7cZIWx5ic1r3jKDjJQQUJd49FcXJCwCdNCqk2vYIErEJSY9eMg+gVFo
	FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKexZ1I7GFc2WBxi
	FOBgVOLh3eAnHizEmlhWXJl7iFGCg1lJhHeLoUSwEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDU2xeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDun8TX
	el3CN5pRbk5V4Nqdn+vul9/p+efxZtq+/KbXt2dx5WkcTLpXy/U28p7P71MFDoJbOh1kdXS3
	1X5pv+UmfYynO/qF+KVHUis/Jqo6l0dm1097fuVl7ZpvaReK2WV1vNbMs9xt837O5ardd27N
	/j/RtbfiQNaj0MkTA04tdi2tZHOYe3+aEktxRqKhFnNRcSIAgHyf6KcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
> 
> 
> 
> On Thursday 06 March 2014 01:56 PM, Anton Tikhomirov wrote:
> > Hi Kamil,
> >
> > ...
> >
> >> +| 3. Supporting SoCs
> >> ++--------------------
> >> +
> >> +To support a new SoC a new file should be added to the drivers/phy
> >> +directory. Each SoC's configuration is stored in an instance of the
> >> +struct samsung_usb2_phy_config.
> >> +
> >> +struct samsung_usb2_phy_config {
> >> +	const struct samsung_usb2_common_phy *phys;
> >> +	unsigned int num_phys;
> >> +	bool has_mode_switch;
> >
> > You missed rate_to_clk here.
> >
> >> +};
> >> +
> >
> > ...
> >
> >> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> samsung-
> >> usb2.c
> >> new file mode 100644
> >> index 0000000..c3b7719
> >> --- /dev/null
> >> +++ b/drivers/phy/phy-samsung-usb2.c
> >> @@ -0,0 +1,222 @@
> >> +/*
> >> + * Samsung SoC USB 1.1/2.0 PHY driver
> >> + *
> >> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> >> + * Author: Kamil Debski <k.debski@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> modify
> >> + * it under the terms of the GNU General Public License version 2
> as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#include <linux/clk.h>
> >> +#include <linux/mfd/syscon.h>
> >> +#include <linux/module.h>
> >> +#include <linux/of.h>
> >> +#include <linux/of_address.h>
> >> +#include <linux/phy/phy.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/spinlock.h>
> >> +#include "phy-samsung-usb2.h"
> >> +
> >> +static int samsung_usb2_phy_power_on(struct phy *phy)
> >> +{
> >> +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
> >> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> >> +	int ret;
> >> +
> >> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> >> +		inst->cfg->label);
> >> +	ret = clk_prepare_enable(drv->clk);
> >
> > clk_prepare_enable() can sleep, and therefore doesn't allow
> > samusng_usb2_phy_power_on() to be used in atomic context
> > (e.g. inside spin_lock-ed area), what sometimes may be desirable.
> > What about to prepare clock in probe, and just enable it here
> > (note: clk_enable() doesn't sleep).
> 
> The PHY power-on callback is anyway called with mutex held, so I guess
> it's fine to have clk_prepare_enable() here.

If we rely totally on generic PHY functions such as phy_power_on()
and friends, why do we need to use locking in callbacks at all.

> 
> Thanks
> Kishon

