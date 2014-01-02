Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaABC1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:27:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:1426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaABC1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:27:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="scan'208";a="452531531"
Message-ID: <1388629657.3739.69.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal:samsung: fix compilation warning
From: Zhang Rui <rui.zhang@intel.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com, t.figa@samsung.com
Date: Thu, 02 Jan 2014 10:27:37 +0800
In-Reply-To: <1387541527-4762-1-git-send-email-ch.naveen@samsung.com>
References: <1387541527-4762-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 17:42 +0530, Naveen Krishna Chatradhi wrote:
> This patch fixes a compilation warning.
> 
> warning: passing argument 5 of 'thermal_zone_device_register' discards 'const'
> qualifier from pointer target type [enabled by default]
> include/linux/thermal.h:270:29: note: expected 'struct thermal_zone_device_ops *'
> but argument is of type 'const struct thermal_zone_device_ops *'
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

applied.

thanks,
rui
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index c2301da..3f5ad25 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -280,7 +280,7 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  /* Operation callback functions for thermal zone */
> -static struct thermal_zone_device_ops const exynos_dev_ops = {
> +static struct thermal_zone_device_ops exynos_dev_ops = {
>  	.bind = exynos_bind,
>  	.unbind = exynos_unbind,
>  	.get_temp = exynos_get_temp,


