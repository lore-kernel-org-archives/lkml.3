Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3EFPSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:18:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:30555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab3EFPSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:18:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="308997557"
Message-ID: <1367853518.2079.65.camel@rzhang1-mobl4>
Subject: Re: [PATCH V2 03/20] thermal: exynos: Rename exynos_thermal.c to
 exynos_tmu.c
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Date: Mon, 06 May 2013 23:18:38 +0800
In-Reply-To: <1366972671-9227-4-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
	 <1366972671-9227-4-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 16:07 +0530, Amit Daniel Kachhap wrote:
> This patch renames exynos_thermal.c to exynos_tmu.c. This change is needed as
> this file now just contains exynos tmu driver related codes and thermal zone
> or cpufreq cooling registration related changes are not there anymore.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

This one looks okay to me.

thanks,
rui
> ---
>  drivers/thermal/samsung/Makefile                   |    2 +-
>  .../samsung/{exynos_thermal.c => exynos_tmu.c}     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>  rename drivers/thermal/samsung/{exynos_thermal.c => exynos_tmu.c} (99%)
> 
> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
> index fcda5b4..75e1f97 100644
> --- a/drivers/thermal/samsung/Makefile
> +++ b/drivers/thermal/samsung/Makefile
> @@ -2,5 +2,5 @@
>  # Samsung thermal specific Makefile
>  #
>  obj-$(CONFIG_EXYNOS_SOC_THERMAL)		+= exynos_soc_thermal.o
> -exynos_soc_thermal-y				:= exynos_thermal.o
> +exynos_soc_thermal-y				:= exynos_tmu.o
>  exynos_soc_thermal-$(CONFIG_EXYNOS_COMMON)	+= exynos_thermal_common.o
> diff --git a/drivers/thermal/samsung/exynos_thermal.c b/drivers/thermal/samsung/exynos_tmu.c
> similarity index 99%
> rename from drivers/thermal/samsung/exynos_thermal.c
> rename to drivers/thermal/samsung/exynos_tmu.c
> index 4c85945..3de3e61 100644
> --- a/drivers/thermal/samsung/exynos_thermal.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -1,5 +1,5 @@
>  /*
> - * exynos_thermal.c - Samsung EXYNOS TMU (Thermal Management Unit)
> + * exynos_tmu.c - Samsung EXYNOS TMU (Thermal Management Unit)
>   *
>   *  Copyright (C) 2011 Samsung Electronics
>   *  Donggeun Kim <dg77.kim@samsung.com>


