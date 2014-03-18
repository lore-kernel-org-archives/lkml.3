Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaCRLOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:14:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52283 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaCRLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:14:27 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d7-53282a917a31
Date: Tue, 18 Mar 2014 20:14:24 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
Message-id: <20140318201424.e8bde8514726c3639243e9ad@samsung.com>
In-reply-to: <CAK9yfHx_FUaUcA_tpsJ73i0iJmczOp7K8gC6sMGHQ6c50i46=A@mail.gmail.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
 <CAK9yfHx_FUaUcA_tpsJ73i0iJmczOp7K8gC6sMGHQ6c50i46=A@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ92JWhrBBrOuMFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXRtGcJc8EBqYpjE48xNzAuFe5i5OSQEDCROPS0hwXC
	FpO4cG89WxcjF4eQwDJGidmrVzDBFK1fdYkZIrGIUWJeWzc7hDOZSWLx9UmsXYwcHCwCqhKv
	ppSANLAJaEmsnnucEcQWAbJfdi9nAqlnFvjJIvHm7zmwdcICLhIPmm4yg9i8Ao4Sk742sIHY
	nALBEjP3LIBa0MEo8fPCPHaIMywkLjR1sEM0CEr8mHwPbBAz0IbN25pYIWx5ic1r3oKdKiGw
	lEPi3rxHYGewCAhIfJt8iAXkUgkBWYlNB5ghZkpKHFxxg2UCo9gsJGNnIRk7C8nYBYzMqxhF
	UwuSC4qT0osM9YoTc4tL89L1kvNzNzFC4r13B+PtA9aHGJOBVk5klhJNzgemi7ySeENjMyML
	UxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDxjHrrkQbvm3IsH
	v4RHyxa/rPon4aB56kl97bVNcSkdE/lN+AQTn6SJyt7et+seZ8cshZ5NEzz5Zk0/a2l3u8Y5
	3f1/akJ62vPzMp/83/Vs+vP1qbHwmd9GjH0WZTP7u87xr8rWq1t4mqFwZRtLgsO/5csfSlc3
	9m+4v+WapqmYb2VIa8+RViWW4oxEQy3mouJEABCbRZcNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd0JWhrBBp/7rCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0bRnCXPBAamK
	YxOPMTcwLhXuYuTkkBAwkVi/6hIzhC0mceHeerYuRi4OIYFFjBLz2rrZIZzJTBKLr09i7WLk
	4GARUJV4NaUEpIFNQEti9dzjjCC2CJD9sns5E0g9s8BPFok3f8+xgCSEBVwkHjTdBNvAK+Ao
	MelrAxuIzSkQLDFzzwKoBR2MEj8vzGOHOMNC4kJTBztEg6DEj8n3wAYxA23YvK2JFcKWl9i8
	5i3zBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4GTyTHoH46oG
	i0OMAhyMSjy8L9jUg4VYE8uKK3MPMUpwMCuJ8C5V0wgW4k1JrKxKLcqPLyrNSS0+xJgMDI6J
	zFKiyfnARJdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzC
	7WtXivvd2OCwui9gxvX+CS2JG2zElu+6GXT+8A3HFsUTbde5mrRqZ9Uy3FczOHX6zZp9T09P
	nnNsV4nqolvLPrz/wjZnNR+DyMUz04vD72/3Z0pSf7XwWG3748P/JmWVe5vf2lnWtUjS6VL2
	/giONZNWGrg94N3RxOTxWFz76ed6lc5tDem/lViKMxINtZiLihMBqPZhHmoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 20:57:42 +0530, Sachin Kamat wrote:
> Hi KyongHo,
> 
> On 14 March 2014 10:39, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > This commit adds device tree support for System MMU.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/Kconfig        |    5 ++---
> >  drivers/iommu/exynos-iommu.c |   21 +++++++++++++++++----
> >  2 files changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index df56e4c..22af807 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -178,16 +178,15 @@ config TEGRA_IOMMU_SMMU
> >
> >  config EXYNOS_IOMMU
> >         bool "Exynos IOMMU Support"
> > -       depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> > +       depends on ARCH_EXYNOS
> >         select IOMMU_API
> > +       default n
> 
> This is not needed as it is the default choice.
> 

OK.

> >         help
> >           Support for the IOMMU(System MMU) of Samsung Exynos application
> >           processor family. This enables H/W multimedia accellerators to see
> >           non-linear physical memory chunks as a linear memory in their
> >           address spaces
> >
> > -         If unsure, say N here.
> > -
> >  config EXYNOS_IOMMU_DEBUG
> >         bool "Debugging log for Exynos IOMMU"
> >         depends on EXYNOS_IOMMU
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 33b424d..34feb04 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/list.h>
> >  #include <linux/memblock.h>
> >  #include <linux/export.h>
> > +#include <linux/of.h>
> >
> >  #include <asm/cacheflush.h>
> >  #include <asm/pgtable.h>
> > @@ -497,7 +498,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >         read_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> > -static int exynos_sysmmu_probe(struct platform_device *pdev)
> > +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >  {
> >         int irq, ret;
> >         struct device *dev = &pdev->dev;
> > @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >         return 0;
> >  }
> >
> > -static struct platform_driver exynos_sysmmu_driver = {
> > -       .probe          = exynos_sysmmu_probe,
> > -       .driver         = {
> > +#ifdef CONFIG_OF
> 
> This is not needed as Exynos is DT only platform.
> 
Yes, but I hesitate to remove that.

> > +static struct of_device_id sysmmu_of_match[] __initconst = {
> > +       { .compatible   = "samsung,sysmmu-v1", },
> > +       { .compatible   = "samsung,sysmmu-v2", },
> > +       { .compatible   = "samsung,sysmmu-v3.1", },
> > +       { .compatible   = "samsung,sysmmu-v3.2", },
> > +       { .compatible   = "samsung,sysmmu-v3.3", },
> > +       { },
> > +};
> > +#endif
> > +
> > +static struct platform_driver exynos_sysmmu_driver __refdata = {
> > +       .probe  = exynos_sysmmu_probe,
> > +       .driver = {
> >                 .owner          = THIS_MODULE,
> >                 .name           = "exynos-sysmmu",
> > +               .of_match_table = of_match_ptr(sysmmu_of_match),
> 
> of_match_ptr is not needed for the same reason as above.
> 
Ditto.

Thanks.

KyongHo
