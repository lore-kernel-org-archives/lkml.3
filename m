Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaKZBzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:55:00 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37042 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKZBy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:54:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Pawel Moll <pawel.moll@arm.com>, arm@kernel.org,
        "Russell King" <linux@arm.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
Cc: "Liviu Dudau" <liviu.dudau@arm.com>, "Sudeep Holla" <sudeep.holla@arm.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Pawel Moll" <pawel.moll@arm.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
 <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
Message-ID: <20141126015452.12298.30373@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/2] MAINTAINERS: ARM Versatile Express platform
Date: Tue, 25 Nov 2014 17:54:52 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pawel Moll (2014-11-25 10:17:35)
> This patch adds a separate section for the ARM
> Versatile Express platform maintainers, listing
> all different bits and bobs used by it.
> 
> Acked-by: Liviu Dudau <liviu.dudau@arm.com>
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Acked-by: Michael Turquette <mturquette@linaro.org>

> ---
>  MAINTAINERS | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ff630d..e0cb002 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1503,6 +1503,25 @@ S:       Maintained
>  F:     drivers/clk/ux500/
>  F:     include/linux/platform_data/clk-ux500.h
>  
> +ARM/VERSATILE EXPRESS PLATFORM
> +M:     Liviu Dudau <liviu.dudau@arm.com>
> +M:     Sudeep Holla <sudeep.holla@arm.com>
> +M:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:     Maintained
> +F:     arch/arm/boot/dts/vexpress-*
> +F:     arch/arm/mach-vexpress/*
> +F:     drivers/bus/vexpress-config.c
> +F:     drivers/clk/versatile/clk-vexpress-osc.c
> +F:     drivers/clocksource/versatile.c
> +F:     drivers/cpufreq/vexpress-spc-cpufreq.c
> +F:     drivers/hwmon/vexpress.c
> +F:     drivers/mfd/vexpress-sysreg.c
> +F:     drivers/misc/vexpress-vexpress-syscfg.c
> +F:     drivers/power/reset/vexpress-poweroff.c
> +F:     drivers/regulator/vexpress.c
> +F:     include/linux/vexpress.h
> +
>  ARM/VFP SUPPORT
>  M:     Russell King <linux@arm.linux.org.uk>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -- 
> 2.1.0
> 
