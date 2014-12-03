Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaLCBjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:39:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaLCBjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:39:41 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-2d-547e69db0ef8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        linux-samsung-soc@vger.kernel.org
Cc: "'Inki Dae'" <inki.dae@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <19437813.I83iiGloeA@vostro.rjw.lan>
In-reply-to: <19437813.I83iiGloeA@vostro.rjw.lan>
Subject: Re: [PATCH] drm / exynos / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 10:40:57 +0900
Message-id: <000f01d00e9a$2f84f720$8e8ee560$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOmP068QOpVmCdQci6bP+N0QwNRgAALiPQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkVfd2Zl2Iwd2fyha9504yWVz5+p7N
	YtL9CSwWlxdeYrXoXXCVzeJs0xt2i8u75rBZfO49wmgx4/w+Joszpy+xOnB5bP/2gNXjfvdx
	Jo8tV9tZPPq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj1t2kgvMSFY8ut7A2MN4S6WLk5JAQ
	MJH4tn0RO4QtJnHh3nq2LkYuDiGBpYwS679OZOpi5AArWr4jDSI+nVFibm8HE4Tzi1Fi962p
	YN1sAmoSX74cZgdpEBEIkNjx3hwkzCxwiUniwD0NEFtIwEDi3L/jjCA2p4ChxKfV19hAbGGg
	8gWr9zKCtLIIqEps/awCEuYVsJXoXNLPAmELSvyYfI8FYqS6xKR5i5ghbHmJzWveMkOcqS7x
	6K8uSFhEwEhi1tlWJogSEYl9L94xglwsIdDIIdG6aworSIJFQEDi2+RDLBC9shKbDjBDgkFS
	4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MwKg+
	/e/ZhB2M9w5YH2IU4GBU4uG1iKsLEWJNLCuuzD3EaAp00URmKdHkfGDqyCuJNzQ2M7IwNTE1
	NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OSswIzmqMl9rHFLrKsc2/f
	MH3ejfjGuhlWvyc3TKm+xyKy2XbBL8XLT5oT1uppdsQePP3+UprBf+2Td9u3W9gFb17tfsKQ
	NeZ/bdTqdzFeGoW3X77PydosqhCwLGgL026HdLOpJ9hZI09MV74nW22YohOt/nvGgnS//Qqx
	5bsVn9iFpVsnsiuxFGckGmoxFxUnAgAWItHk5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3bmXUhBkc/yVn0njvJZHHl63s2
	i0n3J7BYXF54idWid8FVNouzTW/YLS7vmsNm8bn3CKPFjPP7mCzOnL7E6sDlsf3bA1aP+93H
	mTy2XG1n8ejbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygs5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWM
	GbfuJhWcl6h4dLmFtYHxlkgXIweHhICJxPIdaV2MnECmmMSFe+vZuhi5OIQEpjNKzO3tYIJw
	fjFK7L41lR2kik1ATeLLl8PsIM0iAgESO96bg4SZBS4xSRy4pwFiCwkYSJz7d5wRxOYUMJT4
	tPoaG4gtDFS+YPVeRpBWFgFVia2fVUDCvAK2Ep1L+lkgbEGJH5PvsUCMVJeYNG8RM4QtL7F5
	zVtmiJPVJR791QUJiwgYScw628oEUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOGU8k97BuKrB4hCjAAejEg+vRVxdiBBrYllxZe4hRgkO
	ZiUR3uwkoBBvSmJlVWpRfnxRaU5q8SFGU6A/JzJLiSbnA9NZXkm8obGJmZGlkZmFkYm5uZI4
	742buSFCAumJJanZqakFqUUwfUwcnFINjAuP9SmuSzhwgzel52fDrut9026HVsz7G1n1/Qjb
	0om7HLbz1rOs33GXx1Q43FZMdYZ4+ZcLB1d8U7r2WMH3xvLGXyG6zGdv9zatjGp718+9qJcn
	/YP34R1heeplWx4vl53cYDLfnO9F7j6txd2//+yuf6kzcXr3rcncxu976+8lOeaHNKbdkFVi
	Kc5INNRiLipOBABcnFd4LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 03, 2014 10:54 AM, Rafael J. Wysocki wrote:
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in 4 files under
> gpu/drm/exynos/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c    |    2 +-
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c     |    2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c     |    2 +-
>  drivers/gpu/drm/exynos/exynos_drm_rotator.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> +++ linux-pm/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> @@ -1817,7 +1817,7 @@ static int fimc_resume(struct device *de
>  }
>  #endif
> 
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int fimc_runtime_suspend(struct device *dev)
>  {
>  	struct fimc_context *ctx = get_fimc_context(dev);
> Index: linux-pm/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> +++ linux-pm/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> @@ -1764,7 +1764,7 @@ static int gsc_resume(struct device *dev
>  }
>  #endif
> 
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int gsc_runtime_suspend(struct device *dev)
>  {
>  	struct gsc_context *ctx = get_gsc_context(dev);
> Index: linux-pm/drivers/gpu/drm/exynos/exynos_drm_rotator.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/exynos/exynos_drm_rotator.c
> +++ linux-pm/drivers/gpu/drm/exynos/exynos_drm_rotator.c
> @@ -822,7 +822,7 @@ static int rotator_resume(struct device
>  }
>  #endif
> 
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int rotator_runtime_suspend(struct device *dev)
>  {
>  	struct rot_context *rot = dev_get_drvdata(dev);
> Index: linux-pm/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ linux-pm/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -1540,7 +1540,7 @@ static int g2d_resume(struct device *dev
>  }
>  #endif
> 
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int g2d_runtime_suspend(struct device *dev)
>  {
>  	struct g2d_data *g2d = dev_get_drvdata(dev);

