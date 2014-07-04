Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481AbaGDJ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:58:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55343 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaGDJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:58:10 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-4b-53b67aabad7a
Date: Fri, 04 Jul 2014 18:58:02 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shaik.ameer@samsung.com, trblinux@gmail.com
Subject: Re: [PATCH] iommu/exynos: Select ARM_DMA_USE_IOMMU
Message-id: <20140704185802.6883ac53f77ce18781fc0525@samsung.com>
In-reply-to: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
References: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ93VVduCDQ6cF7VYsN/a4vKuOWwW
	Rx7uZrfYMBlI3Nj+lcWB1WPnrLvsHpNvLGf06NuyitHj8ya5AJYoLpuU1JzMstQifbsErozn
	Hx+yFHSzV/SsesDWwHiVtYuRk0NCwERi2dMGZghbTOLCvfVsXYxcHEICyxglzi7fBFe0e8dO
	dojEdEaJtV1vGSGcyUwSMw58YgepYhFQlTh4fj8TiM0moCWxeu5xRhBbREBD4uqC/SwgNrNA
	ocSexQuBVnBwCAtYS6yeLwsS5hVwlHj7eyZYCaeAi8TEM3fAbCEBZ4nlGx6yQRxhIXGhqYMd
	ol5Q4sfke1AjtSQ2b2tihbDlJTaveQv1zSZ2iSNzhSFOE5D4NvkQC8haCQFZiU0HoEokJQ6u
	uMEygVFsFpKps5BMnYVk6gJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIVHVt4Px5gHr
	Q4zJQCsnMkuJJucDozKvJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTDy+DFpfp2h9/tR7vMEk/tG3/d8VEkO9WnSWBOU2D3h4Ibf7eaLnMTWCk9S
	3bU7lsPI//aEGSV5Xz7LPeuV3fxV+OMljd9Xbzbkbg8XDsgX3uYUvj4t9F7Rrz52hVlnhS+E
	VFmrPpo+4W1T1fs5p+b/K3OPOBvHlW9t5XEvYZJzk1WTQu9OiztKLMUZiYZazEXFiQCl+KjW
	wAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd3VVduCDV78EbRYsN/a4vKuOWwW
	Rx7uZrfYMBlI3Nj+lcWB1WPnrLvsHpNvLGf06NuyitHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC9SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaM5x8fshR0s1f0rHrA1sB4lbWLkZNDQsBEYveOnewQtpjE
	hXvr2boYuTiEBKYzSqztessI4Uxmkphx4BNYFYuAqsTB8/uZQGw2AS2J1XOPM4LYIgIaElcX
	7GcBsZkFCiX2LF4INImDQ1jAWmL1fFmQMK+Ao8Tb3zPBSjgFXCQmnrkDZgsJOEss3/CQDeII
	C4kLTR3sEPWCEj8m34MaqSWxeVsTK4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwVH7THoH46oGi0OMAhyMSjy8HkVbg4VYE8uKK3MPMUpwMCuJ
	8LYUbQsW4k1JrKxKLcqPLyrNSS0+xGgKDIyJzFKiyfnAhJJXEm9obGJmZGlkZmFkYm6uJM57
	sNU6UEggPbEkNTs1tSC1CKaPiYNTqoGxtIij5plw81OTpPq8SS2/5jsfiClguJ6klpBbV8a3
	6KBi83674G+/1G8KLN7fbHdy2tVJPr/Flns1c+gWpd0/IKL7ft4vp/V5xaULyhIqRKI+81xM
	nzv52JcHH/7vdPiuuzT9Ueo058Xfld+tX7tVuPKbJou8sH8jmyfP0j1lllttDuXyTtFWYinO
	SDTUYi4qTgQA3i1LCvACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 15:01:08 +0530, Tushar Behera wrote:
> For IOMMU to use on Exynos platforms, we need to enable ARM_DMA_USE_IOMMU. It
> would be better to select it by default when EXYNOS_IOMMU is enabled.
> 
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> ---
>  drivers/iommu/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d260605..54f3ad1a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -180,6 +180,7 @@ config EXYNOS_IOMMU
>  	bool "Exynos IOMMU Support"
>  	depends on ARCH_EXYNOS
>  	select IOMMU_API
> +	select ARM_DMA_USE_IOMMU
>  	help
>  	  Support for the IOMMU (System MMU) of Samsung Exynos application
>  	  processor family. This enables H/W multimedia accelerators to see
> -- 

Reviewed-by: Cho KyongHo <pullip.cho@samsung.com>'

Thank you.

KyongHo
