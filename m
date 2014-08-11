Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHKAvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 20:51:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:32981 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHKAvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 20:51:47 -0400
Date: Mon, 11 Aug 2014 09:51:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: Re: [PATCH] remove non-existent files from MAINTAINERS
Message-ID: <20140811005140.GF26570@verge.net.au>
References: <alpine.DEB.2.19.4.1408092332350.2758@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1408092332350.2758@trent.utfs.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 11:38:22PM -0700, Christian Kujau wrote:
> Inspired by some recent cleanups in MAINTAINERS the following
> files (F:) cannot be found any more in the tree:
> 
>     * arch/arm/mach-s5pv210/mach-aquila.c
>     * arch/arm/mach-s5pv210/mach-goni.c
> 
>       Those two got removed in 28c8331 ("ARM: S5PV210: Remove support for board files").
>       Cc: Tomasz Figa <t.figa@samsung.com>
>       Cc: Kyungmin Park <kyungmin.park@samsung.com>
> 
>     * arch/arm/configs/genmai_defconfig
> 
>       This one got removed in 3ed27bd9 ("ARM: shmobile: genmai: remove defconfig").
>       Cc: Simon Horman <horms@verge.net.au>
>       Cc: Magnus Damm <magnus.damm@gmail.com>

I have already queued up a patch to remove genmai_defconfig from
MAINTAINERS.

>     * drivers/mmc/host/sdhci-st.c
> 
>       This one was sent to be included in June 2014 but got dropped shortly after:
>       "mmc: sdhci-st: Intial support for ST SDHCI controller"
>       https://lkml.org/lkml/2014/6/4/446
>       https://lkml.org/lkml/2014/7/9/340
>       Cc: Peter Griffin <peter.griffin@linaro.org>
>       Cc: Ulf Hansson <ulf.hansson@linaro.org>
> 
>     * drivers/rtc/rtc-sec.c
> 
>       A MAINTAINERS fix was attempted in November 2012, but dismissed as rtc-sec.c
>       was still being worked on. Alas, it's still not there.
>       "MAINTAINERS: fix drivers/rtc/rtc-sec.c"
>       http://lkml.iu.edu/hypermail/linux/kernel/1211.2/04820.html
>       Cc: Sangbeom Kim <sbkim73@samsung.com>
>       Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
> 
>     Signed-off-by: Christian Kujau <lists@nerdbynature.de>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e2eb4c..7831e8d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1303,8 +1303,7 @@ ARM/SAMSUNG MOBILE MACHINE SUPPORT
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
> -F:	arch/arm/mach-s5pv210/mach-aquila.c
> -F:	arch/arm/mach-s5pv210/mach-goni.c
> +F:	arch/arm/mach-s5pv210/
> 
>  ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
> @@ -1347,7 +1346,6 @@ F:	arch/arm/boot/dts/sh*
>  F:	arch/arm/configs/ape6evm_defconfig
>  F:	arch/arm/configs/armadillo800eva_defconfig
>  F:	arch/arm/configs/bockw_defconfig
> -F:	arch/arm/configs/genmai_defconfig
>  F:	arch/arm/configs/koelsch_defconfig
>  F:	arch/arm/configs/kzm9g_defconfig
>  F:	arch/arm/configs/lager_defconfig
> @@ -1383,7 +1381,6 @@ F:	drivers/pinctrl/pinctrl-st.c
>  F:	drivers/media/rc/st_rc.c
>  F:	drivers/i2c/busses/i2c-st.c
>  F:	drivers/tty/serial/st-asc.c
> -F:	drivers/mmc/host/sdhci-st.c
> 
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> @@ -7809,7 +7806,6 @@ S:	Supported
>  F:	drivers/mfd/sec*.c
>  F:	drivers/regulator/s2m*.c
>  F:	drivers/regulator/s5m*.c
> -F:	drivers/rtc/rtc-sec.c
>  F:	include/linux/mfd/samsung/
> 
>  SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
> -- 
> BOFH excuse #419:
> 
> Repeated reboots of the system failed to solve problem
> 
