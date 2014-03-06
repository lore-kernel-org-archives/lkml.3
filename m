Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaCFI0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:26:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61131 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaCFI0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:26:30 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-8d-531831340fbe
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com, jg1.han@samsung.com,
        galak@codeaurora.org, matt.porter@linaro.org,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu,
        sander@humilis.net
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
 <1394033288-5551-4-git-send-email-k.debski@samsung.com>
In-reply-to: <1394033288-5551-4-git-send-email-k.debski@samsung.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 17:26:28 +0900
Message-id: <005c01cf3915$c53476c0$4f9d6440$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84h7VFDZ0Y6kzhQc2nfLU7hPJrnwAiULiA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t8zA10TQ4lgg54GY4v5R86xWvS/Wchq
	0XblILvF5YWXWC1+vL7AZnHhaQ+bxdmmN0CxXXPYLGac38dksWhZK7PF2iN32S3O9t9ms5jY
	NI3d4vyWTiaLw2/aWS1W3NvNbjHhN1Dv+hmvWSzaVn9gteg4e5DdQcTjcl8vk8fOWXfZPT69
	XczscefaHjaPf8fYPWbf/cHo0bdlFaPH8RvbmTw+b5IL4IzisklJzcksSy3St0vgyjh+8Dhr
	wV3Bip7dF9gaGFfwdTFycEgImEj8Oe7excgJZIpJXLi3nq2LkYtDSGAZo8TE6+uZIRImEs83
	3mKHSExnlLjz9RYThPOPUWJx/2s2kCo2ASOJlwc3MoMkRASWMkp8nzMTzGEWeM0k8WP5PlaQ
	KiGBWonPDS8YQWxOAReJR70vmUBsYQEniQvPG8FsFgFViStdh8FqeIFqWndcZoawBSV+TL7H
	AmIzC+hJfPxzmxHClpfYvOYtM8Q/6hKP/uqChEWADvq24zYbRIm4xKQHD8FekBB4wSFxevJf
	FohdAhLfJh9igeiVldh0AOplSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPS
	iwz1ihNzi0vz0vWS83M3MUISTe8OxtsHrA8xJgOtn8gsJZqcD0xUeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeCp3obZ16r3M8JauZ7pneKM0
	vF+fvbnZL1eDx6fdw/cK66nkjf+7ooWOdx3qfBDaapr//v9moT/OkVEnJz6SWp/y6vzzTa9O
	WNVtKs2cc3CimMCSgzMePBN/oXH+nprp/dkHN1t07tsdNT0r94p6Q8Ej/1mXFx6SX/Wpe1vM
	di53hn38U4N8dyuxFGckGmoxFxUnAgAN/sLJSgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsVy+t9jQV0TQ4lgg7U7dSzmHznHatH/ZiGr
	RduVg+wWlxdeYrX48foCm8WFpz1sFmeb3gDFds1hs5hxfh+TxaJlrcwWa4/cZbc423+bzWJi
	0zR2i/NbOpksDr9pZ7VYcW83u8WE30C962e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l9/j0
	djGzx51re9g8/h1j95h99wejR9+WVYwex29sZ/L4vEkugDOqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+g3JYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG8YPHWQvuClb07L7A1sC4gq+LkZNDQsBE4vnGW+wQtpjEhXvr
	2boYuTiEBKYzStz5eosJwvnHKLG4/zUbSBWbgJHEy4MbmUESIgJLGSW+z5kJ5jALvGaS+LF8
	HytIlZBArcTnhheMIDangIvEo96XTCC2sICTxIXnjWA2i4CqxJWuw2A1vEA1rTsuM0PYghI/
	Jt9jAbGZBfQkPv65zQhhy0tsXvMWqIYD6FZ1iUd/dUHCIkAHfdtxmw2iRFxi0oOH7BMYhWYh
	mTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwInsmvYNxVYPFIUYB
	DkYlHt4NfuLBQqyJZcWVuYcYJTiYlUR4Hz4BCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+
	MMnmlcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjhNkqEjqO
	IvlRVYfvCTeX2e3f3LlexC1WQWmpn4ULY8LOqZuUpnGrds3INl75zKCVkfkfS/MZuavrAq1/
	cz5OuV61+/4di5Sya79nTJlXorLrhkbEmamn/ZakPzCQ03ob+m++o7pYb+avXqulYmyGDsv0
	7UVnMV5WPqXoWzQla0XtnV+Ff38osRRnJBpqMRcVJwIAflCD66gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

...

> +| 3. Supporting SoCs
> ++--------------------
> +
> +To support a new SoC a new file should be added to the drivers/phy
> +directory. Each SoC's configuration is stored in an instance of the
> +struct samsung_usb2_phy_config.
> +
> +struct samsung_usb2_phy_config {
> +	const struct samsung_usb2_common_phy *phys;
> +	unsigned int num_phys;
> +	bool has_mode_switch;

You missed rate_to_clk here.

> +};
> +

...

> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-
> usb2.c
> new file mode 100644
> index 0000000..c3b7719
> --- /dev/null
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -0,0 +1,222 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include "phy-samsung-usb2.h"
> +
> +static int samsung_usb2_phy_power_on(struct phy *phy)
> +{
> +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> +		inst->cfg->label);
> +	ret = clk_prepare_enable(drv->clk);

clk_prepare_enable() can sleep, and therefore doesn't allow
samusng_usb2_phy_power_on() to be used in atomic context
(e.g. inside spin_lock-ed area), what sometimes may be desirable.
What about to prepare clock in probe, and just enable it here
(note: clk_enable() doesn't sleep).

> +	if (ret)
> +		goto err_main_clk;
> +	ret = clk_prepare_enable(drv->ref_clk);
> +	if (ret)
> +		goto err_instance_clk;
> +	if (inst->cfg->power_on) {
> +		spin_lock(&drv->lock);
> +		ret = inst->cfg->power_on(inst);
> +		spin_unlock(&drv->lock);
> +	}
> +
> +	return 0;

Thank you

