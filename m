Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaK0LSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:18:53 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40530 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaK0LSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:18:51 -0500
Date: Thu, 27 Nov 2014 11:18:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "olof@lixom.net" <olof@lixom.net>, Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 15/19] arm64: exynos5433: Enable ARMv8-based Exynos5433
 SoC support
Message-ID: <20141127111839.GD11511@e104818-lin.cambridge.arm.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-16-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417073716-22997-16-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:35:12AM +0000, Chanwoo Choi wrote:
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index f4536e0..8a5e8a0 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -152,6 +152,16 @@ config ARCH_EXYNOS
>  	help
>  	  This enables support for Samsung Exynos SoC family
>  
> +config ARCH_EXYNOS5433
> +	bool "ARMv8 based Samsung Exynos5433"
> +	select ARCH_EXYNOS
> +	select COMMON_CLK_SAMSUNG
> +	select PINCTRL
> +	select PINCTRL_EXYNOS
> +
> +	help
> +	  This enables support for Samsung Exynos5433 SoC family

Please update defconfig as well to include this. We aim for the
arm64 defconfig to build all the supported SoCs.

-- 
Catalin
