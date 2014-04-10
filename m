Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153AbaDJJoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:44:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:58543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934910AbaDJJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:44:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Thu, 10 Apr 2014 11:43:36 +0200
Message-ID: <5032959.JQvlxpLHiQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397122124-15690-2-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com> <1397122124-15690-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ig2ERzPYp7zZLoGswQHH00GXwB8xn6qiJ42TCaHC53v
 c8vCYThtc0HwXIcAvWssMZ7zWAeoKmXlK7hOJ2IG/MLcCEtkvc
 ImUXbqf9puemxj1cTU6Ehe5xXXujul6rWY1CQOH6tjzWXQsEio
 S5m4p6oyvVuyhKYJW/N0I3LVicxQ/cgov3e8szUGdD82DYYZnk
 WPSWrwJthRtgFbLe/UQViqapcbucoMRljFXFK4DemBJ2n9o7xy
 oJODi+mW+DrBUvxutQfJuIuruigG4jzlUDr0gQ9W+kh1zoSc/x
 8RVB8jQYw8QN14qIxqAt/roIaLlWFz7B/8vtrXTKkBNfgM2TRg
 bwpmq7RXWTzoNxl3IYpo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 18:28:18 Chanwoo Choi wrote:
> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
> dual cores and has a target speed of 1.0GHz.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>  arch/arm/mach-exynos/exynos.c            |  1 +
>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index fc8bf18..6da8a68 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>  
>  menu "SAMSUNG EXYNOS SoCs Support"
>  
> +config ARCH_EXYNOS3
> +	bool "SAMSUNG EXYNOS3"
> +	select ARM_AMBA
> +	select CLKSRC_OF
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_SMP
> +	select PINCTRL
> +	select PM_GENERIC_DOMAINS if PM_RUNTIME
> +	help
> +	  Samsung EXYNOS3 SoCs based systems
> +

Isn't S5PV210 also called an Exynos3 these days? Are we going to get
any conflicts here when merging that code into Exynos as Tomasz has
suggested in the past?

	Arnd
