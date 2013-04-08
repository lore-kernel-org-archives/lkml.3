Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935558Ab3DHSV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:21:28 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51437 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935348Ab3DHSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:21:27 -0400
Message-ID: <51630AA1.8060207@samsung.com>
Date: Tue, 09 Apr 2013 03:21:21 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH] ARM: EXYNOS: remove "config EXYNOS_DEV_DRM"
References: <1365432910.1830.105.camel@x61.thuisdomein>
In-Reply-To: <1365432910.1830.105.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/13 23:55, Paul Bolle wrote:
> The only user of Kconfig symbol EXYNOS_DEV_DRM was removed in commit
> 0a9d5ac307aefbb2c772537d3fe7f75046d563ac ("ARM: EXYNOS: removing
> exynos-drm device registration from non-dt platforms"). It is safe to
> remove this symbol too.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> Only "git grep" tested.
>
>   arch/arm/mach-exynos/Kconfig | 10 ----------
>   1 file changed, 10 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 70f94c8..99e7142 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -95,11 +95,6 @@ config EXYNOS4_DEV_AHCI
>   	help
>   	  Compile in platform device definitions for AHCI
>
> -config EXYNOS_DEV_DRM
> -	bool
> -	help
> -	  Compile in platform device definitions for core DRM device
> -
>   config EXYNOS4_SETUP_FIMD0
>   	bool
>   	help
> @@ -199,7 +194,6 @@ config MACH_SMDKV310
>   	select EXYNOS4_SETUP_SDHCI
>   	select EXYNOS4_SETUP_USB_PHY
>   	select EXYNOS_DEV_DMA
> -	select EXYNOS_DEV_DRM
>   	select EXYNOS_DEV_SYSMMU
>   	select S3C24XX_PWM
>   	select S3C_DEV_HSMMC
> @@ -253,7 +247,6 @@ config MACH_UNIVERSAL_C210
>   	select EXYNOS4_SETUP_SDHCI
>   	select EXYNOS4_SETUP_USB_PHY
>   	select EXYNOS_DEV_DMA
> -	select EXYNOS_DEV_DRM
>   	select EXYNOS_DEV_SYSMMU
>   	select HAVE_SCHED_CLOCK
>   	select S3C_DEV_HSMMC
> @@ -294,7 +287,6 @@ config MACH_NURI
>   	select EXYNOS4_SETUP_SDHCI
>   	select EXYNOS4_SETUP_USB_PHY
>   	select EXYNOS_DEV_DMA
> -	select EXYNOS_DEV_DRM
>   	select S3C_DEV_HSMMC
>   	select S3C_DEV_HSMMC2
>   	select S3C_DEV_HSMMC3
> @@ -330,7 +322,6 @@ config MACH_ORIGEN
>   	select EXYNOS4_SETUP_SDHCI
>   	select EXYNOS4_SETUP_USB_PHY
>   	select EXYNOS_DEV_DMA
> -	select EXYNOS_DEV_DRM
>   	select EXYNOS_DEV_SYSMMU
>   	select S3C24XX_PWM
>   	select S3C_DEV_HSMMC
> @@ -366,7 +357,6 @@ config MACH_SMDK4212
>   	select EXYNOS4_SETUP_SDHCI
>   	select EXYNOS4_SETUP_USB_PHY
>   	select EXYNOS_DEV_DMA
> -	select EXYNOS_DEV_DRM
>   	select EXYNOS_DEV_SYSMMU
>   	select S3C24XX_PWM
>   	select S3C_DEV_HSMMC2

Applied, thanks.

- Kukjin
