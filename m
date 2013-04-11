Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937630Ab3DKAOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934997Ab3DKAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:14:19 -0400
Date: Wed, 10 Apr 2013 21:13:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 11/30] [media] exynos: remove unnecessary header
 inclusions
Message-ID: <20130410211354.397d5689@redhat.com>
In-Reply-To: <1365638712-1028578-12-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
	<1365638712-1028578-12-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 11 Apr 2013 02:04:53 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> In multiplatform configurations, we cannot include headers
> provided by only the exynos platform. Fortunately a number
> of drivers that include those headers do not actually need
> them, so we can just remove the inclusions.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/platform/exynos-gsc/gsc-regs.c | 1 -
>  drivers/media/platform/s5p-tv/sii9234_drv.c  | 3 ---
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
> index 6f5b5a4..e22d147 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-regs.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
> @@ -12,7 +12,6 @@
>  
>  #include <linux/io.h>
>  #include <linux/delay.h>
> -#include <mach/map.h>
>  
>  #include "gsc-core.h"
>  
> diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
> index d90d228..39b77d2 100644
> --- a/drivers/media/platform/s5p-tv/sii9234_drv.c
> +++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
> @@ -23,9 +23,6 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/slab.h>
>  
> -#include <mach/gpio.h>
> -#include <plat/gpio-cfg.h>
> -
>  #include <media/sii9234.h>
>  #include <media/v4l2-subdev.h>
>  


-- 

Cheers,
Mauro
