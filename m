Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaCELWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:22:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaCELWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:22:03 -0500
Message-ID: <531708C5.6010506@ti.com>
Date: Wed, 5 Mar 2014 16:51:41 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 0/4] phy: Add new Exynos USB 2.0 PHY driver
References: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 04 March 2014 08:53 PM, Kamil Debski wrote:
> Hi,
>
> This is the seventh version of this patchset. First and most significant change
> is that this patchset includes only patches touching the Generic PHY Framework.
> Patches to the USB controllers were stripped as they require additional work.
> S5PV210 support is also omitted - it requires more testing.
>
> Thank you to everyone who joined the discussion, reviewed the patched and
> contributed to making the code and consequently the Linux Kernel better.

Can you refresh your patches on
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next
It's not applying cleanly.

While at that pls fix these checkpatch errors/warnings

on patch 3.
ERROR: code indent should use tabs where possible
#854: FILE: drivers/phy/phy-exynos4x12-usb2.c:233:
+^I^I^I        EXYNOS_4x12_MODE_SWITCH_OFFSET,$

CHECK: Alignment should match open parenthesis
#854: FILE: drivers/phy/phy-exynos4x12-usb2.c:233:
+			regmap_update_bits(drv->reg_sys,
+			        EXYNOS_4x12_MODE_SWITCH_OFFSET,

ERROR: code indent should use tabs where possible
#855: FILE: drivers/phy/phy-exynos4x12-usb2.c:234:
+^I^I^I        EXYNOS_4x12_MODE_SWITCH_MASK,$

CHECK: Alignment should match open parenthesis
#986: FILE: drivers/phy/phy-samsung-usb2.c:29:
+	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
+							inst->cfg->label);

CHECK: Alignment should match open parenthesis
#1014: FILE: drivers/phy/phy-samsung-usb2.c:57:
+	dev_dbg(drv->dev, "Request to power_off \"%s\" usb phy\n",
+							inst->cfg->label);

CHECK: Alignment should match open parenthesis
#1146: FILE: drivers/phy/phy-samsung-usb2.c:189:
+			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
+

And on patch 4

CHECK: Alignment should match open parenthesis
#350: FILE: drivers/phy/phy-exynos5250-usb2.c:212:
+		regmap_update_bits(drv->reg_sys,
+			EXYNOS_5250_MODE_SWITCH_OFFSET,

-Kishon
