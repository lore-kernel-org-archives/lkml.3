Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaEEI7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:59:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaEEI7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:59:45 -0400
Message-ID: <536752FD.3040704@suse.de>
Date: Mon, 05 May 2014 10:59:41 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <k.chander@samsung.com>
Subject: Re: [Patch v3 2/5] cpuidle: config: Add ARCH_EXYNOS entry to select
 cpuidle-big-little driver
References: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org> <1399278444-8312-1-git-send-email-chander.kashyap@linaro.org> <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 05.05.2014 10:27, schrieb Chander Kashyap:
> Exynos5420 is a big-little SoC from Samsung. It has 4 A15 and 4 A7 cores.
> In order to use generic cpuidle-big-little driver, this patch adds Exynos5420
> specific check to initialize generic cpuidle driver.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
> Changes in v3: None
> Changes in v2:
> 	1. Changed config macro from SOC_EXYNOS5420 to SOC_EXYNOS5420

This is probably a copy&pasto? Anyway, the commit message needs an
update since no Exynos5420 specific check is done below afaics. That
went into 3/5.

Cheers,
Andreas

>  drivers/cpuidle/Kconfig.arm |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
> index 97ccc31..d9596e7 100644
> --- a/drivers/cpuidle/Kconfig.arm
> +++ b/drivers/cpuidle/Kconfig.arm
> @@ -4,7 +4,7 @@
>  
>  config ARM_BIG_LITTLE_CPUIDLE
>  	bool "Support for ARM big.LITTLE processors"
> -	depends on ARCH_VEXPRESS_TC2_PM
> +	depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
>  	select ARM_CPU_SUSPEND
>  	select CPU_IDLE_MULTIPLE_DRIVERS
>  	help
> 


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
