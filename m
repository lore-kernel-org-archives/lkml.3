Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3CGBM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:12:57 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33895 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3CGBMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:12:54 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-f4-5137e994f63f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1362509466.16460.108.camel@x61.thuisdomein>
In-reply-to: <1362509466.16460.108.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: EXYNOS: remove EXYNOS_DEV_SYSMMU entirely
Date: Thu, 07 Mar 2013 10:12:52 +0900
Message-id: <014f01ce1ad0$e4432b10$acc98130$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Z0md22Ew+QIcbQO+GzSTPLDsZMAA/e6EA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zfd0pL80DDaYfMbK4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MroPbmTueCacMX5l+dZGhhf8XcxcnJICJhIXFz9jAXC
	FpO4cG89WxcjF4eQwDJGiaN3Z7J3MXKAFV17oAoRX8Qo0TFvJROE85dR4uLpiewg3WwCGhKH
	3z8Ds0UE/CQOdp0HK2IW2M4osevoc7AVQgIWEl/eTmQDsTkFLCWuzpzHCGILCzhL3JvyB2wb
	i4CqxPtLIiBhXgFbib3rjrBA2IISPybfYwEpYRZQl5gyJRckzCygLfHk3QVWiDvVJR791QUx
	RQSMJJb+ZYaoEJHY9+IdI8gxEgKb2CVWbv/ABJJgERCQ+Db5EAtEq6zEpgPMkGCQlDi44gbL
	BEaJWUj2zkLYOwvJ3llINixgZFnFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERJd/TsY7x6w
	PsSYDLR9IrOUaHI+MDrzSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFRUtlr4f1ll1m19gpuMTuyuv2LxGSl0773utvtX82747Wlblq34oqYc3ly
	VmXL7BtdNdNvaKQ/m5T49YGh4t8ri+f6LFuwX0KIUePKxHmHhbbwRlZ0pf8oub39tEOM94zJ
	C2Zsvubzv+q+Za+INsMVbZ1T/+5E/OffsWTRhz8F3X9OXXNdpfbzvBJLcUaioRZzUXEiAGUX
	c9nEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgO6Ul+aBBrtW61pc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm9J7cyVxwTbji
	/MvzLA2Mr/i7GDk4JARMJK49UO1i5AQyxSQu3FvP1sXIxSEksIhRomPeSiYI5y+jxMXTE9lB
	qtgENCQOv38GZosI+Ekc7DoPVsQssJ1RYtfR5ywgCSEBC4kvbyeygdicApYSV2fOYwSxhQWc
	Je5N+cMOsplFQFXi/SURkDCvgK3E3nVHWCBsQYkfk++xgJQwC6hLTJmSCxJmFtCWePLuAivE
	zeoSj/7qgpgiAkYSS/8yQ1SISOx78Y5xAqPQLCRzZiHMmYVkziwkHQsYWVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBMfuM+kdjKsaLA4xCnAwKvHwbswxDxRiTSwrrsw9xCjBwawkwnt3
	CVCINyWxsiq1KD++qDQntfgQYzLQkxOZpUST84FpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZT
	TwKEBNITS1KzU1MLUotgtjBxcEo1MM5xebKGYcOE9fzP+FQL+b8///f/prDlr4MzxaWTLX/a
	TYupKGDidrzVctnXLeLPDYUVQgcPiU0JjH9Z0DwrMSNq15kanusHlaRjOqPrhLe+sSm8/UdD
	zHOCwpvtzM+0OK5uC4+Nf3J0hloXz8Rp8T3Ss8+Ha8ntSTU9zmRz8P3PrgVuz2+Z2yuxFGck
	GmoxFxUnAgBxjjwhIQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit 25e9d28d927d2e1731df53f60cde53d75bcb7c36 ("ARM: EXYNOS: remove
> system mmu initialization from exynos tree") removed the Kconfig symbol
> EXYNOS_DEV_SYSMMU. Remove its last traces too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) Please note that this patch changes the dependencies of EXYNOS_IOMMU
> (it removed a dependency that could never be met). That's probably what
> needs to be done but some specific review is needed here.
> 
>  arch/arm/mach-exynos/Kconfig | 4 ----
>  drivers/iommu/Kconfig        | 2 +-
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 70f94c8..6c2bdc3 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -200,7 +200,6 @@ config MACH_SMDKV310
>  	select EXYNOS4_SETUP_USB_PHY
>  	select EXYNOS_DEV_DMA
>  	select EXYNOS_DEV_DRM
> -	select EXYNOS_DEV_SYSMMU
>  	select S3C24XX_PWM
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC1
> @@ -254,7 +253,6 @@ config MACH_UNIVERSAL_C210
>  	select EXYNOS4_SETUP_USB_PHY
>  	select EXYNOS_DEV_DMA
>  	select EXYNOS_DEV_DRM
> -	select EXYNOS_DEV_SYSMMU
>  	select HAVE_SCHED_CLOCK
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC2
> @@ -331,7 +329,6 @@ config MACH_ORIGEN
>  	select EXYNOS4_SETUP_USB_PHY
>  	select EXYNOS_DEV_DMA
>  	select EXYNOS_DEV_DRM
> -	select EXYNOS_DEV_SYSMMU
>  	select S3C24XX_PWM
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC2
> @@ -367,7 +364,6 @@ config MACH_SMDK4212
>  	select EXYNOS4_SETUP_USB_PHY
>  	select EXYNOS_DEV_DMA
>  	select EXYNOS_DEV_DRM
> -	select EXYNOS_DEV_SYSMMU
>  	select S3C24XX_PWM
>  	select S3C_DEV_HSMMC2
>  	select S3C_DEV_HSMMC3
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 5c514d07..c520c20 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -168,7 +168,7 @@ config TEGRA_IOMMU_SMMU
> 
>  config EXYNOS_IOMMU
>  	bool "Exynos IOMMU Support"
> -	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> +	depends on ARCH_EXYNOS
>  	select IOMMU_API
>  	help
>  	  Support for the IOMMU(System MMU) of Samsung Exynos application
> --
> 1.7.11.7

Actually, to update iommu for exynos is on-going. And as I know, it will be done this time for v3.10 by KyongHo Cho, so it would be better to handle this cleanup with that at the same time.

Thanks.

- Kukjin

