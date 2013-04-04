Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763815Ab3DDGrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:47:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40233 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3DDGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 4 Apr 2013 12:17:13 +0530
Message-ID: <CAFp+6iHt5QHkx2MkQq_JiJDZ-aov2e2Db=sn50_bm0fYcBQinA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] ARM: Exynos5250: Enabling dwc3-exynos driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Fri, Mar 15, 2013 at 1:32 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> This patch-set is in continuation with patch-series:
> [PATCH v4 0/4] Enable ehci, ohci and dwc3 devices on exynos5250
> out of which follwowing patches have been picked up:
> ARM: Exynos5250: Enabling ehci-s5p driver
> ARM: Exynos5250: Enabling ohci-exynos driver
>
> Based on following patch-set for Samsung's usb PHY enablement:
> [PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy
>
> and further depends on dwc3-exynos driver patch-set:
> [PATCH 0/2] dwc3: exynos: Device tree fixes
>
> Changes from v4:
>  - Aligning with the recently merged common clock framework, thereby
>    no place for clock file changes. ;-)
>  - Adding proper binding documentation as per latest bindings changes in
>    dwc3 driver (dwc3/core.c as well as for dwc3-exynos.c change reflected
>    by above patch-set.
>  - Bifurcating the patch to separate our Documentation, arch and dts changes.
>
> Vivek Gautam (3):
>   usb: Add device tree bindings for dwc3-exynos
>   ARM: exynos5250: dts: Enabling dwc3-exynos driver
>   ARM: exynos5: Enable XHCI support on exynos5
>
>  .../devicetree/bindings/usb/exynos-usb.txt         |   34 ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250.dtsi                  |   20 ++++++++++-
>  arch/arm/mach-exynos/Kconfig                       |    1 +
>  3 files changed, 53 insertions(+), 2 deletions(-)

Waiting for your review on this patch-set. :-)


-- 
Thanks & Regards
Vivek
