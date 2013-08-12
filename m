Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3HLCNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:13:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31659 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3HLCNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:13:33 -0400
X-AuditID: cbfee68f-b7f436d000000f81-0a-520844cbe9be
Date: Mon, 12 Aug 2013 11:13:30 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 07/16] iommu/exynos: support for device tree
Message-id: <20130812111330.f854810269e876140aa55634@samsung.com>
In-reply-to: <3801687.TzcQoMh0Oe@flatron>
References: <002b01ce941b$160a88a0$421f99e0$@samsung.com>
 <5396565.vjlSOm37Vf@flatron>
 <20130809153730.83d3a5ba419def5424bcbb0e@samsung.com>
 <3801687.TzcQoMh0Oe@flatron>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zI93TLhxBBif2KVrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlms2vWH0YHf48nBeUwesxsusnjsnHWX3ePOtT1sHuc3rWH22Lyk3mPyjeWMHn1b
	VjF6fN4k53Hl6BmmAK4oLpuU1JzMstQifbsEroz3C04zF0zqZKz4tq6HqYGxObmLkYNDQsBE
	4lqbYRcjJ5ApJnHh3nq2LkYuDiGBZYwSLb9WMEEkTCSO3NnPCpFYxCjxcMNsFghnEpPE9fO3
	WUCqWARUJToO7ADrYBPQklg99zgjiC0ioC7xbUo/O4jNLPCDReLTNj4QW1jAWWL26jOsIDav
	gKPEh6m/weZwCmhKTPq2D2rbekaJb1N/s0KcYSFxoamDHaJBUOLH5HssEEO1JDZva2KFsOUl
	Nq95ywzSLCGwlkPiyreLjBDXCUh8m3yIBeJnWYlNB5ghZkpKHFxxg2UCo9gsJGNnIRk7C8nY
	BYzMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCIr9/B+PdA9aHGJOBVk5klhJNzgcmjryS
	eENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFraLVb6
	IPpbyT3fQe+v7PRXQqpBm8UW7OQ2MDfrq/po8CT/2Jyolt7u5s2tf1nYS1zSnA2tlh95U2d/
	qMU5LWZdwf/tvw5MPFGwaNXDx8pad/R98+cfvXZR6mSJTFnof+OU60Z+z2Sll3M/dtkfmm9j
	MMc+5+xsh9K29pf/Tp9c4l+c9qCvXYmlOCPRUIu5qDgRACl2iLkSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd3TLhxBBg2fJS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSxW7frD6MDv8eTgPCaP2Q0XWTx2zrrL7nHn2h42j/Ob1jB7bF5S7zH5xnJGj74t
	qxg9Pm+S87hy9AxTAFdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtAbSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM9wtO
	MxdM6mSs+Lauh6mBsTm5i5GTQ0LAROLInf2sELaYxIV769m6GLk4hAQWMUo83DCbBcKZxCRx
	/fxtFpAqFgFViY4DO5hAbDYBLYnVc48zgtgiAuoS36b0s4PYzAI/WCQ+beMDsYUFnCVmrz4D
	toFXwFHiw9TfYHM4BTQlJn3bxwqxYD2jxLepv6HOsJC40NTBDtEgKPFj8j0WiKFaEpu3NbFC
	2PISm9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcWJ5J
	72Bc1WBxiFGAg1GJh9fjC3uQEGtiWXFl7iFGCQ5mJRHeemOOICHelMTKqtSi/Pii0pzU4kOM
	ycDgmMgsJZqcD0x6eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXA2LVyy7srwr7/H106ceahyf50V5d9O5JV37feMNFj8LW6UPZf8MW3+26HnzKqumR9udO5
	1Fq55J4Zv+u2wqzjXVwWb74b1C9Q+nvo/vqgOV+yPFw6BR6oVDzadmVxzbnH1Y6XdOdcndFw
	Z67s0og9xjIdh589/Bjm0HvnaXP5iXcdh51/3DW72qHEUpyRaKjFXFScCABNkygncAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 10:30:11 +0200, Tomasz Figa wrote:
> On Friday 09 of August 2013 15:37:30 Cho KyongHo wrote:
> > On Fri, 09 Aug 2013 00:41:25 +0200, Tomasz Figa wrote:
> > > Hi KyongHo,
> > > 
> > > On Thursday 08 of August 2013 18:38:49 Cho KyongHo wrote:
> > > > This commit adds device tree support for System MMU.
> > > > This also include the following changes and enhancements:
> > > > 
> > > > * use managed device helper functions.
> > > > Simplyfies System MMU device driver.
> > > > 
> > > > * use only a single clock descriptor.
> > > > System MMU device descriptor is seperate if it is imposible to make
> > > > a single clock descriptor to make a device descriptor for a group of
> > > > System MMUs.
> > > > 
> > > > * removed dbgname member from sysmmu_drvdata structure.
> > > > debugging kernel message for a System MMU is distinguisheable with
> > > > the
> > > > name of device descroptors.
> > > 
> > > Please put all these three changes in separate patches. This patch is
> > > hard to review with all the changes mixed together...
> > 
> > Ok.
> > 
> > > In addition, I believe this is the patch that should be adding device
> > > tree binding documentation, not the 6/16 one, as this is where
> > > actually support for this binding gets added to the kernel.
> > 
> > Oh, I didn't know that devicetree binding description and implementation
> > need to be in the same patch.
> > I will do as you advised.
> 
> Thanks. We are still missing a "best practices" document about device tree 
> binding development, so it might not be clear.
> 

I saw Rob Herring has different idea about the seperation of patches.
Let's talk about it more.

> > > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > > ---
> > > > 
> > > >  drivers/iommu/Kconfig        |    5 +-
> > > >  drivers/iommu/exynos-iommu.c |  186
> > > > 
> > > > ++++++++++++++++------------------------- 2 files changed, 75
> > > > insertions(+), 116 deletions(-)
> > > > 
> > > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > > index 820d85c..9ad45f1 100644
> > > > --- a/drivers/iommu/Kconfig
> > > > +++ b/drivers/iommu/Kconfig
> > > > @@ -168,16 +168,15 @@ config TEGRA_IOMMU_SMMU
> > > > 
> > > >  config EXYNOS_IOMMU
> > > >  
> > > >  	bool "Exynos IOMMU Support"
> > > > 
> > > > -	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> > > > +	depends on ARCH_EXYNOS
> > > > 
> > > >  	select IOMMU_API
> > > > 
> > > > +	default n
> > > > 
> > > >  	help
> > > >  	
> > > >  	  Support for the IOMMU(System MMU) of Samsung Exynos application
> > > >  	  processor family. This enables H/W multimedia accellerators to
> > > 
> > > see
> > > 
> > > >  	  non-linear physical memory chunks as a linear memory in their
> > > >  	  address spaces
> > > > 
> > > > -	  If unsure, say N here.
> > > > -
> > > > 
> > > >  config EXYNOS_IOMMU_DEBUG
> > > >  
> > > >  	bool "Debugging log for Exynos IOMMU"
> > > >  	depends on EXYNOS_IOMMU
> > > > 
> > > > diff --git a/drivers/iommu/exynos-iommu.c
> > > > b/drivers/iommu/exynos-iommu.c index a318049..0ee73e8 100644
> > > > --- a/drivers/iommu/exynos-iommu.c
> > > > +++ b/drivers/iommu/exynos-iommu.c
> > > > @@ -26,6 +26,7 @@
> > > > 
> > > >  #include <linux/list.h>
> > > >  #include <linux/memblock.h>
> > > >  #include <linux/export.h>
> > > > 
> > > > +#include <linux/of.h>
> > > > 
> > > >  #include <asm/cacheflush.h>
> > > >  #include <asm/pgtable.h>
> > > > 
> > > > @@ -170,15 +171,14 @@ struct sysmmu_drvdata {
> > > > 
> > > >  	struct list_head node; /* entry of exynos_iommu_domain.clients */
> > > >  	struct device *sysmmu;	/* System MMU's device descriptor */
> > > >  	struct device *dev;	/* Owner of system MMU */
> > > > 
> > > > -	char *dbgname;
> > > > 
> > > >  	int nsfrs;
> > > > 
> > > > -	void __iomem **sfrbases;
> > > > -	struct clk *clk[2];
> > > > +	struct clk *clk;
> > > > 
> > > >  	int activations;
> > > >  	rwlock_t lock;
> > > >  	struct iommu_domain *domain;
> > > >  	sysmmu_fault_handler_t fault_handler;
> > > >  	unsigned long pgtable;
> > > > 
> > > > +	void __iomem *sfrbases[0];
> > > > 
> > > >  };
> > > >  
> > > >  static bool set_sysmmu_active(struct sysmmu_drvdata *data)
> > > > 
> > > > @@ -385,8 +385,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq,
> > > > void
> > > > *dev_id) if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> > > > 
> > > >  		__raw_writel(1 << itype, data->sfrbases[i] +
> > > 
> > > REG_INT_CLEAR);
> > > 
> > > >  	else
> > > > 
> > > > -		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
> > > > -				data->dbgname, sysmmu_fault_name[itype]);
> > > > +		dev_dbg(data->sysmmu, "%s is not handled.\n",
> > > > +				sysmmu_fault_name[itype]);
> > > > 
> > > >  	if (itype != SYSMMU_FAULT_UNKNOWN)
> > > >  	
> > > >  		sysmmu_unblock(data->sfrbases[i]);
> > > > 
> > > > @@ -410,10 +410,8 @@ static bool __exynos_sysmmu_disable(struct
> > > > sysmmu_drvdata *data) for (i = 0; i < data->nsfrs; i++)
> > > > 
> > > >  		__raw_writel(CTRL_DISABLE, data->sfrbases[i] +
> > > 
> > > REG_MMU_CTRL);
> > > 
> > > > -	if (data->clk[1])
> > > > -		clk_disable(data->clk[1]);
> > > > -	if (data->clk[0])
> > > > -		clk_disable(data->clk[0]);
> > > > +	if (data->clk)
> > > > +		clk_disable(data->clk);
> > > > 
> > > >  	disabled = true;
> > > >  	data->pgtable = 0;
> > > > 
> > > > @@ -422,10 +420,10 @@ finish:
> > > >  	write_unlock_irqrestore(&data->lock, flags);
> > > >  	
> > > >  	if (disabled)
> > > > 
> > > > -		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
> > > > +		dev_dbg(data->sysmmu, "Disabled\n");
> > > > 
> > > >  	else
> > > > 
> > > > -		dev_dbg(data->sysmmu, "(%s) %d times left to be
> > > 
> > > disabled\n",
> > > 
> > > > -					data->dbgname, data->activations);
> > > > +		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> > > > +					data->activations);
> > > > 
> > > >  	return disabled;
> > > >  
> > > >  }
> > > > 
> > > > @@ -452,14 +450,12 @@ static int __exynos_sysmmu_enable(struct
> > > > sysmmu_drvdata *data, ret = 1;
> > > > 
> > > >  		}
> > > > 
> > > > -		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data-
> > > >
> > > >dbgname);
> > > >
> > > > +		dev_dbg(data->sysmmu, "Already enabled\n");
> > > > 
> > > >  		goto finish;
> > > >  	
> > > >  	}
> > > > 
> > > > -	if (data->clk[0])
> > > > -		clk_enable(data->clk[0]);
> > > > -	if (data->clk[1])
> > > > -		clk_enable(data->clk[1]);
> > > > +	if (data->clk)
> > > > +		clk_enable(data->clk);
> > > > 
> > > >  	data->pgtable = pgtable;
> > > > 
> > > > @@ -479,7 +475,7 @@ static int __exynos_sysmmu_enable(struct
> > > > sysmmu_drvdata *data,
> > > > 
> > > >  	data->domain = domain;
> > > > 
> > > > -	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
> > > > +	dev_dbg(data->sysmmu, "Enabled\n");
> > > > 
> > > >  finish:
> > > >  	write_unlock_irqrestore(&data->lock, flags);
> > > > 
> > > > @@ -495,7 +491,7 @@ int exynos_sysmmu_enable(struct device *dev,
> > > > unsigned long pgtable)
> > > > 
> > > >  	ret = pm_runtime_get_sync(data->sysmmu);
> > > >  	if (ret < 0) {
> > > > 
> > > > -		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data-
> > > >
> > > >dbgname);
> > > >
> > > > +		dev_dbg(data->sysmmu, "Failed to enable\n");
> > > > 
> > > >  		return ret;
> > > >  	
> > > >  	}
> > > > 
> > > > @@ -503,8 +499,8 @@ int exynos_sysmmu_enable(struct device *dev,
> > > > unsigned long pgtable) if (WARN_ON(ret < 0)) {
> > > > 
> > > >  		pm_runtime_put(data->sysmmu);
> > > >  		dev_err(data->sysmmu,
> > > > 
> > > > -			"(%s) Already enabled with page table %#lx\n",
> > > > -			data->dbgname, data->pgtable);
> > > > +			"Already enabled with page table %#lx\n",
> > > > +			data->pgtable);
> > > > 
> > > >  	} else {
> > > >  	
> > > >  		data->dev = dev;
> > > >  	
> > > >  	}
> > > > 
> > > > @@ -540,9 +536,7 @@ static void sysmmu_tlb_invalidate_entry(struct
> > > > device *dev, unsigned long iova) }
> > > > 
> > > >  		}
> > > >  	
> > > >  	} else {
> > > > 
> > > > -		dev_dbg(data->sysmmu,
> > > > -			"(%s) Disabled. Skipping invalidating TLB.\n",
> > > > -			data->dbgname);
> > > > +		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating
> > > 
> > > TLB.\n");
> > > 
> > > >  	}
> > > >  	
> > > >  	read_unlock_irqrestore(&data->lock, flags);
> > > > 
> > > > @@ -564,141 +558,107 @@ void exynos_sysmmu_tlb_invalidate(struct
> > > > device
> > > > *dev) }
> > > > 
> > > >  		}
> > > >  	
> > > >  	} else {
> > > > 
> > > > -		dev_dbg(data->sysmmu,
> > > > -			"(%s) Disabled. Skipping invalidating TLB.\n",
> > > > -			data->dbgname);
> > > > +		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating
> > > 
> > > TLB.\n");
> > > 
> > > >  	}
> > > >  	
> > > >  	read_unlock_irqrestore(&data->lock, flags);
> > > >  
> > > >  }
> > > > 
> > > > -static int exynos_sysmmu_probe(struct platform_device *pdev)
> > > > +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> > > > 
> > > >  {
> > > >  
> > > >  	int i, ret;
> > > > 
> > > > -	struct device *dev;
> > > > +	struct device *dev = &pdev->dev;
> > > > 
> > > >  	struct sysmmu_drvdata *data;
> > > > 
> > > > -	dev = &pdev->dev;
> > > > -
> > > > -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> > > > -	if (!data) {
> > > > -		dev_dbg(dev, "Not enough memory\n");
> > > > -		ret = -ENOMEM;
> > > > -		goto err_alloc;
> > > > +	if (pdev->num_resources == 0) {
> > > > +		dev_err(dev, "No System MMU resource defined\n");
> > > > +		return -ENODEV;
> > > > 
> > > >  	}
> > > > 
> > > > -	ret = dev_set_drvdata(dev, data);
> > > > -	if (ret) {
> > > > -		dev_dbg(dev, "Unabled to initialize driver data\n");
> > > > -		goto err_init;
> > > > +	data = devm_kzalloc(dev,
> > > > +			sizeof(*data) +
> > > > +			sizeof(*data->sfrbases) * (pdev->num_resources /
> > > 
> > > 2),
> > > 
> > > > +			GFP_KERNEL);
> > > > +	if (!data) {
> > > > +		dev_err(dev, "Not enough memory for initialization\n");
> > > 
> > > nit: This message is not necessary, as kmalloc() already prints a
> > > message if allocation error occurs.
> > 
> > Ok.
> > 
> > > > +		return -ENOMEM;
> > > > 
> > > >  	}
> > > >  	
> > > >  	data->nsfrs = pdev->num_resources / 2;
> > > 
> > > As Marek and Bart already mentioned before, please (oh please, really
> > > please) finally remove this brokenness from this driver.
> > > 
> > > A device driver should not do this kind of abstraction, emulating one
> > > instance of particular IP from multiple instances. This is a task for
> > > the IOMMU core and this is already supported by IOMMU domains, which
> > > is the right way to achieve a single virtual address space for
> > > multiple IOMMUs.
> > Let me show some example.
> > FIMD in Exynos5250 has a single System MMU.
> > FIMD in Exynos5420 has 2 System MMUs.
> > I wanted to show the FIMD driver the same view of System MMU.
> > Otherwise, FIMD driver must aware of how the System MMUs are connected
> > with FIMD.
> > 
> > If it is responsible for the device drivers of master H/Ws, System MMU
> > driver can be much more simpler which I also prefer :)
> 
> Yes, it is responsibility of FIMD driver to add all its IOMMUs into the 
> same domain or into any other configuration it wants.
> 
> For example by some extension, the driver might want to have separate 
> address spaces for each IOMMU and this would not be possible with current 
> configuration of SysMMU driver.
> 

Ok. I will post seperate series of patches for this issue later.
I think it is better to discuss because it is change in design.

> > > > -	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
> > > > -
> > > 
> > > GFP_KERNEL);
> > > 
> > > > -	if (data->sfrbases == NULL) {
> > > > -		dev_dbg(dev, "Not enough memory\n");
> > > > -		ret = -ENOMEM;
> > > > -		goto err_init;
> > > > -	}
> > > > 
> > > >  	for (i = 0; i < data->nsfrs; i++) {
> > > >  	
> > > >  		struct resource *res;
> > > > 
> > > > +
> > > > 
> > > >  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> > > >  		if (!res) {
> > > > 
> > > > -			dev_dbg(dev, "Unable to find IOMEM region\n");
> > > > -			ret = -ENOENT;
> > > > -			goto err_res;
> > > > +			dev_err(dev, "Unable to find IOMEM region\n");
> > > > +			return -ENOENT;
> > > > 
> > > >  		}
> > > > 
> > > > -		data->sfrbases[i] = ioremap(res->start,
> > > 
> > > resource_size(res));
> > > 
> > > > +		data->sfrbases[i] = devm_request_and_ioremap(dev, res);
> > > 
> > > devm_request_and_ioremap() is deprecated. Please use
> > > devm_ioremap_resource().
> > 
> > Oh. Thanks.
> > 
> > > >  		if (!data->sfrbases[i]) {
> > > 
> > > In case of devm_ioremap_resource() remember to adjust this check to
> > > check for IS_ERR, not for NULL.
> > 
> > Ok. Thanks.
> > 
> > > > -			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
> > > > -							res->start);
> > > > -			ret = -ENOENT;
> > > > -			goto err_res;
> > > > +			dev_err(dev, "Unable to map IOMEM @ %#x\n", res-
> > > >
> > > >start);
> > > 
> > > This message will not be needed with devm_ioremap_resource() as it
> > > already prints a message if an error occurs.
> > 
> > Ok.
> > 
> > > > +			return -EBUSY;
> > > > 
> > > >  		}
> > > >  	
> > > >  	}
> > > >  	
> > > >  	for (i = 0; i < data->nsfrs; i++) {
> > > > 
> > > > -		ret = platform_get_irq(pdev, i);
> > > > -		if (ret <= 0) {
> > > > -			dev_dbg(dev, "Unable to find IRQ resource\n");
> > > > -			goto err_irq;
> > > > +		int irq;
> > > > +
> > > > +		irq = platform_get_irq(pdev, i);
> > > > +		if (irq <= 0) {
> > > > +			dev_err(dev, "Unable to find IRQ resource\n");
> > > > +			return -ENOENT;
> > > > 
> > > >  		}
> > > > 
> > > > -		ret = request_irq(ret, exynos_sysmmu_irq, 0,
> > > > -					dev_name(dev), data);
> > > > +		ret = devm_request_irq(dev, irq, exynos_sysmmu_irq,
> > > > +					0, dev_name(dev), data);
> > > > 
> > > >  		if (ret) {
> > > > 
> > > > -			dev_dbg(dev, "Unabled to register interrupt
> > > 
> > > handler\n");
> > > 
> > > > -			goto err_irq;
> > > > +			dev_err(dev, "Unable to register handler to irq
> > > 
> > > %d\n",
> > > 
> > > > +				irq);
> > > > +			return ret;
> > > > 
> > > >  		}
> > > >  	
> > > >  	}
> > > > 
> > > > -	if (dev_get_platdata(dev)) {
> > > > -		char *deli, *beg;
> > > > -		struct sysmmu_platform_data *platdata =
> > > 
> > > dev_get_platdata(dev);
> > > 
> > > > -
> > > > -		beg = platdata->clockname;
> > > > -
> > > > -		for (deli = beg; (*deli != '\0') && (*deli != ',');
> > > 
> > > deli++)
> > > 
> > > > -			/* NOTHING */;
> > > > +	pm_runtime_enable(dev);
> > > > 
> > > > -		if (*deli == '\0')
> > > > -			deli = NULL;
> > > > -		else
> > > > -			*deli = '\0';
> > > > -
> > > > -		data->clk[0] = clk_get(dev, beg);
> > > > -		if (IS_ERR(data->clk[0])) {
> > > > -			data->clk[0] = NULL;
> > > > -			dev_dbg(dev, "No clock descriptor registered\n");
> > > > -		}
> > > > +	__set_fault_handler(data, &default_fault_handler);
> > > > 
> > > > -		if (data->clk[0] && deli) {
> > > > -			*deli = ',';
> > > > -			data->clk[1] = clk_get(dev, deli + 1);
> > > > -			if (IS_ERR(data->clk[1]))
> > > > -				data->clk[1] = NULL;
> > > > -		}
> > > > +	data->sysmmu = dev;
> > > > +	data->clk = devm_clk_get(dev, "sysmmu");
> > > > +	if (IS_ERR(data->clk)) {
> > > > +		dev_info(dev, "No gate clock found!\n");
> > > > +		data->clk = NULL;
> > > 
> > > Just a note: In common clock framework NULL is a valid value for a
> > > struct clk *, which should not be interpreted as a pointer, but as an
> > > opaque cookie. This is material for separate patch, but this should
> > > be fixed all around this driver so data->clk is for IS_ERR instead.
> > 
> > Error returned by devm_clk_get("sysmmu") is not an error actually.
> > More specifically, -ENOENT returned by devm_clk_get("sysmmu") is not an
> > error. It just means that a System MMU does not have to gating its
> > clock. However, it is required to check if the error retruned is
> > -ENOENT.
> 
> I agree with this. Since the clock is optional for this driver, the -
> ENOENT error case is not an error for it.
> 
> > data->clk must be NULL if 'sysmmu' clock is not specified for a System
> > MMU because clk_enable(data->clk) is called regardless of the value in
> > data->clk.
> 
> Still, the return value convention for Common Clock Framework is that 
> clk_get() can return a NULL and the driver must interpret this as a valid 
> clock handle (for a dummy clock for example) that can be passed to further 
> clock operations, such as clk_prepare() or clk_enable().
> 
> This is why the driver should not reserve NULL as its own value meaning 
> that the clock is not present, but should rather check for IS_ERR 
> everywhere to find out whether the clock was acquired at probe.
> 
> Separate patch fixing this would be nice.
> 

Ok. I understand that it must not be assumed that NULL as the arguement
of clk_enable()/prepare() is ignored.
I will change this patch not to call clk_enable/disable
if IS_ERR(data->clk) is true.

Thank you.

> > Thank you for review :)
> 
> You're welcome. Thank you for your work on this series. :)
> 
> Best regards,
> Tomasz
> 
