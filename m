Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3GHBoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:44:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52013 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3GHBoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:44:15 -0400
X-AuditID: cbfee68e-b7f276d000002279-a3-51da196c7aa2
From: Jingoo Han <jg1.han@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 8/8] ARM: exynos: select PM_GENERIC_DOMAINS only when used
Date: Mon, 08 Jul 2013 10:44:12 +0900
Message-id: <001901ce7b7c$a5af8df0$f10ea9d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac57fJZeIKGp33gZTZuL1gi/P/dC4w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI90cyVuBBouvG1v8nXSM3eLywkus
	Fr0LrrJZXN41h82BxeP3r0mMHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJVx7Op7poLV7BUb
	r3UwNjD+Ze1i5OSQEDCR2H9mDhuELSZx4d56IJuLQ0hgGaPElJ/bmGCKfrS+YYJILGKUuHt2
	KzuE84tRomF9FzNIFZuAmsSXL4fZQWwRAUWJqS+eAcU5OJgFMiQ6Wi1ATGEBP4m1y/VBTBYB
	VYnHDfkgJq+ApcSDiSIgfbwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeIaBYkdZ18zQuzR
	k3ix+A0bRI2IxL4X7xhBDpMQWMcuseDkXLAEi4CAxLfJh1hAdkkIyEpsOgA1R1Li4IobLBMY
	xWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQuOrbwXjzgPUh
	xmSg9ROZpUST84FxmVcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGRuuXhxkeMi7453/txdn8+CjezhSjkH3S5psy5oqUKYdOXs2x8cQEXQd1aSWm
	lZdPTOR1lQpe2KvAuOWYOFu9fjtLh4+Mxpoji2olNoofZuy+UKJuOa3N0+D7Zc9JNaJqlR+j
	M39cfS4VlWG3+4bt89ivqQenqPrMP6z0RELTe3PehFshZ29PVmIpzkg01GIuKk4EAEcG2SrB	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG6O5K1Agx2NBhZ/Jx1jt7i88BKr
	Re+Cq2wWl3fNYXNg8fj9axKjR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFmHLv6nqlgNXvFxmsdjA2Mf1m7GDk5JARMJH60vmGCsMUkLtxbz9bFyMUh
	JLCIUeLu2a3sEM4vRomG9V3MIFVsAmoSX74cZgexRQQUJaa+eAYU5+BgFsiQ6Gi1ADGFBfwk
	1i7XBzFZBFQlHjfkg5i8ApYSDyaKgPTxCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIaxQk
	dpx9zQixR0/ixeI3bBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYKj9pn0DsZVDRaHGAU4GJV4eCVO3wwUYk0sK67MPcQowcGsJMIrznor
	UIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgQklryTe0NjEzMjSyMzCyMTcnDRhJXHeg63W
	gUIC6YklqdmpqQWpRTBbmDg4pRoYW9ttk7qVExvm/vlgLpvLffaWLbuJf+aWJ/V/9E7f1k4p
	+ar14vuN0i9PusQUvjh2yp0L+DJZjXfxLi839ZaqqwWMK6eL3XK5/XKLqejk6YeZ7ifXPlha
	y1Vscm2XnWjGpdm7571nWPd50rf3E05MznrcJGjsoP7+KDeL6fkZdZe2zLz+prsuS4mlOCPR
	UIu5qDgRAFfr6FMeAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 9:25 AM, Arnd Bergmann wrote:

Hi Arnd,

This bug fix patch was already submitted on May 27th, as below:

https://patchwork.kernel.org/patch/2617191/


Best regards,
Jingoo Han

> This fixes building exynos kernels with CONFIG_PM disabled.
>
> Signed-off-by: Arnd Bergmann <a...@arndb.de>
> Cc: Kukjin Kim <kgene....@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 2d503b3..ba70a84 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -38,7 +38,7 @@ config CPU_EXYNOS4210
> 	depends on ARCH_EXYNOS4
> 	select ARM_CPU_SUSPEND if PM
> 	select PINCTRL_EXYNOS
> -	select PM_GENERIC_DOMAINS
> +	select PM_GENERIC_DOMAINS if PM
> 	select S5P_PM if PM
> 	select S5P_SLEEP if PM
> 	select SAMSUNG_DMADEV
> --

