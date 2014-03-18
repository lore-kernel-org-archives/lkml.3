Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaCRKwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:52:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25371 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaCRKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:52:13 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-b0-5328255bd107
Date: Tue, 18 Mar 2014 19:52:10 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
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
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
Message-id: <20140318195210.14c953a70498f634032f35b7@samsung.com>
In-reply-to: <53230695.9080606@samsung.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
 <53230695.9080606@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI91oVY1gg2ULBC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mp4+a2NqaBfomLK/qnsDYyfhboYOTkkBEwk2s/sY4Kw
	xSQu3FvP1sXIxSEksIxRYuKnkywwRTsvHmSCSExnlDg1fxtYh5DAZCaJdUccQGwWAVWJhyvO
	s4HYbAJaEqvnHmcEsUUEVCQun5rOCNLMLNDIKvHo/jJ2kISwgIvEg6abzF2MHBy8Ao4SHa/A
	LuIU0JY4cq2XEWJ+ksStq0dYIY6wkLjQ1AHWyisgKPFj8j2w45iBdm3e1sQKYctLbF7zlhlk
	l4TAUg6J3/O/skIcJyDxbfIhFpBdEgKyEpsOMEPMlJQ4uOIGywRGsVlIxs5CMnYWkrELGJlX
	MYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoTE+sQdjPcPWB9iTAZaOZFZSjQ5H5gq8kriDY3N
	jCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0e6r64ZA1h8n
	/sxidFlwofzNNZ/XSeV3N92++/LFsSW9Jht6Klt4TVVzgg6Gz3BK5DQ8o9D21pjTzvay7drr
	qw8Jd3wr5O5M1KnrNU0Q8imcIndz778e/jsn/7CmFIRtcf+6ImnqgqfnOq/c9NnZfYJdZO/7
	6pS9LuVftr3lvPpbOvzwvMa5W5RYijMSDbWYi4oTAXkcJ3ALAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQd1oVY1gg487uS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8fJbG1NBv0TF
	lP1T2RsYPwt1MXJySAiYSOy8eJAJwhaTuHBvPVsXIxeHkMB0RolT87eBJYQEJjNJrDviAGKz
	CKhKPFxxng3EZhPQklg99zgjiC0ioCJx+dR0RpBmZoFGVolH95exgySEBVwkHjTdZO5i5ODg
	FXCU6HgFtphTQFviyLVeRoj5SRK3rh5hhTjCQuJCUwdYK6+AoMSPyfdYQGxmoF2btzWxQtjy
	EpvXvGWewCgwC0nZLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnEieSe1g
	XNlgcYhRgINRiYf3BZt6sBBrYllxZe4hRgkOZiUR3hMiGsFCvCmJlVWpRfnxRaU5qcWHGJOB
	oTGRWUo0OR+Y5PJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1Oq
	gbH65MX1ig9Pcve0HAypd7Je39LQ/Gba8kD/3tt8LX+EQyrFOW34ouVPTV+8QZ7/vX6owKGe
	5RMnRbfJXkjbFsls88EgfqFN1vkvuZwTXy7hZIz57NJx4WrSLEVVqXidkwE2SiGGExaEeM6+
	PPle7kLW1xfKFqRk2QSsCjHzasrZzr66fve7vUosxRmJhlrMRcWJAIPCiSVoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 14:39:33 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:09, Cho KyongHo wrote:
> > This commit adds device tree support for System MMU.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   drivers/iommu/Kconfig        |    5 ++---
> >   drivers/iommu/exynos-iommu.c |   21 +++++++++++++++++----
> >   2 files changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index df56e4c..22af807 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -178,16 +178,15 @@ config TEGRA_IOMMU_SMMU
> >
> >   config EXYNOS_IOMMU
> >   	bool "Exynos IOMMU Support"
> > -	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> > +	depends on ARCH_EXYNOS
> >   	select IOMMU_API
> > +	default n
> >   	help
> >   	  Support for the IOMMU(System MMU) of Samsung Exynos application
> 
> nit: There should be a white space before the opening parenthesis.
> 
Ok. :)

> >   	  processor family. This enables H/W multimedia accellerators to see
> 
> typo: s/accellerators/accelerators/
> 

Ok.

> >   	  non-linear physical memory chunks as a linear memory in their
> >   	  address spaces
> >
> > -	  If unsure, say N here.
> > -
> >   config EXYNOS_IOMMU_DEBUG
> >   	bool "Debugging log for Exynos IOMMU"
> >   	depends on EXYNOS_IOMMU
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 33b424d..34feb04 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -26,6 +26,7 @@
> >   #include <linux/list.h>
> >   #include <linux/memblock.h>
> >   #include <linux/export.h>
> > +#include <linux/of.h>
> >
> >   #include <asm/cacheflush.h>
> >   #include <asm/pgtable.h>
> > @@ -497,7 +498,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >   	read_unlock_irqrestore(&data->lock, flags);
> >   }
> >
> > -static int exynos_sysmmu_probe(struct platform_device *pdev)
> > +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >   {
> >   	int irq, ret;
> >   	struct device *dev = &pdev->dev;
> > @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >   	return 0;
> >   }
> >
> > -static struct platform_driver exynos_sysmmu_driver = {
> > -	.probe		= exynos_sysmmu_probe,
> > -	.driver		= {
> > +#ifdef CONFIG_OF
> > +static struct of_device_id sysmmu_of_match[] __initconst = {
> > +	{ .compatible	= "samsung,sysmmu-v1", },
> > +	{ .compatible	= "samsung,sysmmu-v2", },
> > +	{ .compatible	= "samsung,sysmmu-v3.1", },
> > +	{ .compatible	= "samsung,sysmmu-v3.2", },
> > +	{ .compatible	= "samsung,sysmmu-v3.3", },
> 
> Do you need all these compatible strings? I mean, are there any 
> implementation differences that can't be identified by reading IP 
> registers, such as REG_MMU_VERSION?
> 

Unfortunately, there is a SoC which overrides REG_MMU_VERSION with
a value for RTL designers and it is not related to System MMU
versions.

Thank you.

KyongHo
