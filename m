Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3HENSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:18:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29619 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3HENSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:18:02 -0400
X-AuditID: cbfee68e-b7f276d000002279-84-51ffa608b3fb
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <004001ce89f3$813c8b50$83b5a1f0$@samsung.com>
 <6639650.hgn0t6JFZ2@amdc1032>
In-reply-to: <6639650.hgn0t6JFZ2@amdc1032>
Subject: RE: [PATCH v8 10/12] iommu/exynos: add bus notifier for registering
 System MMU
Date: Mon, 05 Aug 2013 22:17:59 +0900
Message-id: <004601ce91de$34f6a670$9ee3f350$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLqauMMbLaDwk/gxMuuivzJvITs7gLOjNWllzhQf6A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zfV2OZf8DDfqmcFncuXuO1WLjjPWs
	Fq+O/GCyWLDf2qJz9gZ2i80H17FY9C64ymbReG8Cm8XHU8fZLTY9vsZqcXnXHDaLGef3MVlc
	WLGR3WLKosOsFif/9DJatFzvZXIQ8HhycB6Tx+yGiywed67tYfM4v2kNs8fmJfUek28sZ/To
	27KK0ePzJjmPK0fPMAVwRnHZpKTmZJalFunbJXBl9Dycw1Zw6ydjRc+c86wNjCcPMHYxcnJI
	CJhI7Gz4D2WLSVy4t56ti5GLQ0hgGaPEyw/HgBIcYEUzG4oh4osYJTbPbmWHcP4ySuyb844d
	pJtNQEti9dzjYJNEBKwkHs84C1bELLCNVaL56RVWkElCApEST46VgtRwAtVPnveLBcQWBgqf
	3vsAbA6LgKrEm5ubmEBsXgFLiW1nelkhbEGJH5PvgdUzA/Wu33mcCcKWl9i85i0zxAcKEjvO
	voa74fzdu+wQNSIS+168YwS5R0LgBIfEw3vtzBDLBCS+TT7EAvGlrMSmA1BzJCUOrrjBMoFR
	YhaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAhJIH07GG8esD7E
	mAy0fiKzlGhyPjAB5ZXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB0YmlqiK599P91BIHlc2bdV5qzdhXfFtou0Rxi5O/2YUdskf/hj63+bi0mtfI
	n23Lmujwdw6pf4L2y21O1yuyrJ5jsq2f32zvHQ/3U69nLeFmqBZ6Iuf/fSOTj6H7jTYpi/qz
	RkVcS5ifPbm0bVvK0zUbDTVvXm683XNN/MSvr7vPcj8v/vuGTYmlOCPRUIu5qDgRABRnUFM2	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xgC77sv+BBrNW21jcuXuO1WLjjPWs
	Fq+O/GCyWLDf2qJz9gZ2i80H17FY9C64ymbReG8Cm8XHU8fZLTY9vsZqcXnXHDaLGef3MVlc
	WLGR3WLKosOsFif/9DJatFzvZXIQ8HhycB6Tx+yGiywed67tYfM4v2kNs8fmJfUek28sZ/To
	27KK0ePzJjmPK0fPMAVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl
	5qbaKrn4BOi6ZeYAvaGkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOh5
	OIet4NZPxoqeOedZGxhPHmDsYuTgkBAwkZjZUNzFyAlkiklcuLeerYuRi0NIYBGjxObZrewQ
	zl9GiX1z3rGDVLEJaEmsnnucEcQWEbCSeDzjLFgRs8A2Vonmp1dYQaYKCURKPDlWClLDCVQ/
	ed4vFhBbGCh8eu8DsDksAqoSb25uYgKxeQUsJbad6WWFsAUlfky+B1bPDNS7fudxJghbXmLz
	mrfMEJcqSOw4+xruhvN377JD1IhI7HvxjnECo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQITk/PpHcwrmqwOMQowMGoxMOrwP4/UIg1say4MvcQowQHs5II
	77USoBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnA1NnXkm8obGJmZGlkZmFkYm5OWnCSuK8
	B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwFth3yeUskK+xmFT0IlXxWXCr7W02NzuVOdm1zJ/b
	Jip1FH8/zXWT4XXQvs22a7bdeCQp8u1L4FqvmxvviU/xvf15T5XxbLOnPGvsAnxz56rftKuQ
	2jdT1qZ3ucX19vYzynNaWz4GphzPeNkqYqmRcFt2Z6hLSXFYaGjktt4NSmGrFno+Yp+gxFKc
	kWioxVxUnAgAM9FjAJMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Saturday, August 03, 2013 2:32 AM
> 
> Hi,
> 
> On Friday, July 26, 2013 08:30:17 PM Cho KyongHo wrote:
> > When a device driver is registered, all constructs to handle System MMU
> > is prepared by bus notifier call.
> 
> Patch description could be improved greatly by documenting what the patch
> is doing and it does a lot more than simply adding bus notifier.
> 
> The patch can be also split further (at least code adding support for
> muplitple System MMUs per struct exynos_iommu_client instance could be
> separate which would make review a lot easier as the code wouldn't be
> moved around so much).
> 
> Could you also tell me how (on which SoC/board and with what drivers) are
> you testing these changes? I've tried to test v7 with FIMC and MFC devices
> (on EXYNOS4210 based Universal C210 board) but as soon as I added actual
> IOMMU mappings (none of your patches in this series does it BTW) I've
> encountered problems (namely lockup related to clocks usage, probably
> related to "master" clock, I haven't had time to debug it further yet).
> 

I am just testing if each System MMU is correctly enabled and disabled or page
tables are consistently managed. I does not run MFC nor FIMC with System MMU.

Please let me know if you found the problem.

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |  708 ++++++++++++++++++++++++++++++++---------
> >  1 files changed, 552 insertions(+), 156 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index f9853fe..c62c244 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -27,6 +27,9 @@
> >  #include <linux/memblock.h>
> >  #include <linux/export.h>
> >  #include <linux/of.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/pm_domain.h>
> > +#include <linux/notifier.h>
> >
> >  #include <asm/cacheflush.h>
> >  #include <asm/pgtable.h>
> > @@ -80,7 +83,13 @@
> >  #define CTRL_BLOCK	0x7
> >  #define CTRL_DISABLE	0x0
> >
> > +#define CFG_LRU		0x1
> > +#define CFG_QOS(n)	((n & 0xF) << 7)
> > +#define CFG_MASK	0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
> > +#define CFG_ACGEN	(1 << 24) /* System MMU 3.3 only */
> > +#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
> >  #define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
> > +#define CFG_SHAREABLE	(1 << 12) /* System MMU 3.x only */
> >
> >  #define REG_MMU_CTRL		0x000
> >  #define REG_MMU_CFG		0x004
> > @@ -154,6 +163,14 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
> >  	"UNKNOWN FAULT"
> >  };
> >
> > +struct exynos_iommu_client {
> > +	struct list_head node;	/* entry of exynos_iommu_domain.clients */
> > +	struct device *dev;
> > +	spinlock_t lock;
> > +	int num_sysmmu;
> > +	struct device *sysmmu[0];
> > +};
> > +
> >  struct exynos_iommu_domain {
> >  	struct list_head clients; /* list of sysmmu_drvdata.node */
> >  	unsigned long *pgtable; /* lv1 page table, 16KB */
> > @@ -165,12 +182,14 @@ struct exynos_iommu_domain {
> >  struct sysmmu_drvdata {
> >  	struct list_head node; /* entry of exynos_iommu_domain.clients */
> >  	struct device *sysmmu;	/* System MMU's device descriptor */
> > -	struct device *dev;	/* Owner of system MMU */
> > +	struct device *master;	/* Owner of system MMU */
> >  	int nsfrs;
> >  	struct clk *clk;
> > +	struct clk *clk_master;
> >  	int activations;
> >  	rwlock_t lock;
> >  	struct iommu_domain *domain;
> > +	bool runtime_active;
> >  	unsigned long pgtable;
> >  	void __iomem *sfrbases[0];
> >  };
> > @@ -245,7 +264,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
> >  static void __sysmmu_set_ptbase(void __iomem *sfrbase,
> >  				       unsigned long pgd)
> >  {
> > -	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
> >  	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
> >
> >  	__sysmmu_tlb_invalidate(sfrbase);
> > @@ -273,6 +291,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  	if (!is_sysmmu_active(data))
> >  		goto finish;
> >
> > +	clk_enable(data->clk_master);
> >  	for (i = 0; i < data->nsfrs; i++) {
> >  		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> >  			if (!sysmmu_block(data->sfrbases[i]))
> > @@ -298,6 +317,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >  			sysmmu_unblock(data->sfrbases[i]);
> >  		}
> >  	}
> > +	clk_disable(data->clk_master);
> >  finish:
> >  	read_unlock_irqrestore(&data->lock, flags);
> >  }
> > @@ -331,12 +351,13 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  {
> >  	/* SYSMMU is in blocked when interrupt occurred. */
> >  	struct sysmmu_drvdata *data = dev_id;
> > +	struct exynos_iommu_client *client = NULL;
> >  	enum exynos_sysmmu_inttype itype;
> >  	unsigned long addr = -1;
> > -
> >  	int i, ret = -ENOSYS;
> >
> > -	read_lock(&data->lock);
> > +	if (data->master)
> > +		client = data->master->archdata.iommu;
> >
> >  	WARN_ON(!is_sysmmu_active(data));
> >
> > @@ -348,6 +369,10 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  			break;
> >  	}
> >
> > +	if (client)
> > +		spin_lock(&client->lock);
> > +	read_lock(&data->lock);
> > +
> >  	if (i == data->nsfrs) {
> >  		itype = SYSMMU_FAULT_UNKNOWN;
> >  	} else {
> > @@ -361,7 +386,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  	}
> >
> >  	if (data->domain)
> > -		ret = report_iommu_fault(data->domain, data->dev,
> > +		ret = report_iommu_fault(data->domain, data->master,
> >  				addr, itype);
> >
> >  	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> > @@ -378,177 +403,251 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  		sysmmu_unblock(data->sfrbases[i]);
> >
> >  	read_unlock(&data->lock);
> > +	if (client)
> > +		spin_unlock(&client->lock);
> >
> >  	return IRQ_HANDLED;
> >  }
> >
> > -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> > +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
> >  {
> > -	unsigned long flags;
> > -	bool disabled = false;
> >  	int i;
> >
> > -	write_lock_irqsave(&data->lock, flags);
> > +	clk_enable(data->clk_master);
> > +	for (i = 0; i < data->nsfrs; i++) {
> > +		__raw_writel(CTRL_DISABLE,
> > +				data->sfrbases[i] + REG_MMU_CTRL);
> > +		__raw_writel(0, data->sfrbases[i] + REG_MMU_CFG);
> > +	}
> >
> > -	if (!set_sysmmu_inactive(data))
> > -		goto finish;
> > +	clk_disable(data->clk);
> > +	clk_disable(data->clk_master);
> > +}
> >
> > -	for (i = 0; i < data->nsfrs; i++)
> > -		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > +static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> > +{
> > +	bool disabled;
> > +	unsigned long flags;
> >
> > -	if (data->clk)
> > -		clk_disable(data->clk);
> > +	write_lock_irqsave(&data->lock, flags);
> >
> > -	disabled = true;
> > -	data->pgtable = 0;
> > -	data->domain = NULL;
> > -finish:
> > -	write_unlock_irqrestore(&data->lock, flags);
> > +	disabled = set_sysmmu_inactive(data);
> > +
> > +	if (disabled) {
> > +		data->pgtable = 0;
> > +		data->domain = NULL;
> > +
> > +		if (data->runtime_active)
> > +			__sysmmu_disable_nocount(data);
> >
> > -	if (disabled)
> >  		dev_dbg(data->sysmmu, "Disabled\n");
> > -	else
> > -		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> > +	} else  {
> > +		dev_dbg(data->sysmmu, "%d times left to disable\n",
> >  					data->activations);
> > +	}
> > +
> > +	write_unlock_irqrestore(&data->lock, flags);
> >
> >  	return disabled;
> >  }
> >
> > -/* __exynos_sysmmu_enable: Enables System MMU
> > - *
> > - * returns -error if an error occurred and System MMU is not enabled,
> > - * 0 if the System MMU has been just enabled and 1 if System MMU was already
> > - * enabled before.
> > - */
> > -static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> > +
> > +static void __sysmmu_init_config(struct sysmmu_drvdata *data, int idx)
> > +{
> > +	unsigned long cfg = CFG_LRU | CFG_QOS(15);
> > +	int maj, min = 0;
> > +
> > +	maj = __sysmmu_version(data, idx, &min);
> > +	if (maj == 3) {
> > +		if (min > 1) {
> > +			cfg |= CFG_FLPDCACHE;
> > +			cfg |= (min == 2) ? CFG_SYSSEL : CFG_ACGEN;
> > +		}
> > +	}
> > +
> > +	__raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
> > +}
> > +
> > +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
> > +{
> > +	int i;
> > +
> > +	clk_enable(data->clk_master);
> > +	clk_enable(data->clk);
> > +
> > +	for (i = 0; i < data->nsfrs; i++) {
> > +		__raw_writel(CTRL_BLOCK, data->sfrbases[i] + REG_MMU_CTRL);
> > +
> > +		__sysmmu_init_config(data, i);
> > +
> > +		__sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
> > +
> > +		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > +	}
> > +	clk_disable(data->clk_master);
> > +}
> > +
> > +static int __sysmmu_enable(struct sysmmu_drvdata *data,
> >  			unsigned long pgtable, struct iommu_domain *domain)
> >  {
> > -	int i, ret = 0;
> > +	int ret = 0;
> >  	unsigned long flags;
> >
> >  	write_lock_irqsave(&data->lock, flags);
> > +	if (set_sysmmu_active(data)) {
> > +		data->pgtable = pgtable;
> > +		data->domain = domain;
> >
> > -	if (!set_sysmmu_active(data)) {
> > -		if (WARN_ON(pgtable != data->pgtable)) {
> > -			ret = -EBUSY;
> > -			set_sysmmu_inactive(data);
> > -		} else {
> > -			ret = 1;
> > -		}
> > +		if (data->runtime_active)
> > +			__sysmmu_enable_nocount(data);
> >
> > -		dev_dbg(data->sysmmu, "Already enabled\n");
> > -		goto finish;
> > +		dev_dbg(data->sysmmu, "Enabled\n");
> > +	} else {
> > +		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
> > +
> > +		dev_dbg(data->sysmmu, "already enabled\n");
> >  	}
> >
> > -	if (data->clk)
> > -		clk_enable(data->clk);
> > +	if (WARN_ON(ret < 0))
> > +		set_sysmmu_inactive(data); /* decrement count */
> >
> > -	data->pgtable = pgtable;
> > +	write_unlock_irqrestore(&data->lock, flags);
> >
> > -	for (i = 0; i < data->nsfrs; i++) {
> > -		unsigned int min;
> > +	return ret;
> > +}
> >
> > -		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> > +/* __exynos_sysmmu_enable: Enables System MMU
> > + *
> > + * returns -error if an error occurred and System MMU is not enabled,
> > + * 0 if the System MMU has been just enabled and 1 if System MMU was already
> > + * enabled before.
> > + */
> > +static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
> > +				  struct iommu_domain *domain)
> > +{
> > +	int ret = 0;
> > +	unsigned long flags;
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int i;
> >
> > -		if ((__sysmmu_version(data, i, &min) == 3) && (min > 1)) {
> > -			unsigned long cfg;
> > -			cfg = __raw_readl(data->sfrbases[i] + REG_MMU_CFG);
> > -			__raw_writel(cfg | CFG_FLPDCACHE,
> > -					data->sfrbases[i] + REG_MMU_CFG);
> > -		}
> > +	if (WARN_ON(!client))
> > +		return -ENODEV;
> >
> > -		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > -	}
> > +	spin_lock_irqsave(&client->lock, flags);
> >
> > -	data->domain = domain;
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		struct sysmmu_drvdata *data =
> > +				dev_get_drvdata(client->sysmmu[i]);
> > +		ret = __sysmmu_enable(data, pgtable, domain);
> > +		if (ret < 0) {
> > +			int j;
> > +			for (j = 0; j < i; j++)
> > +				__sysmmu_disable(data);
> > +			break;
> > +		} else {
> > +			data->master = dev;
> > +		}
> > +	}
> >
> > -	dev_dbg(data->sysmmu, "Enabled\n");
> > -finish:
> > -	write_unlock_irqrestore(&data->lock, flags);
> > +	spin_unlock_irqrestore(&client->lock, flags);
> >
> >  	return ret;
> >  }
> >
> >  int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
> >  {
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> >  	int ret;
> >
> >  	BUG_ON(!memblock_is_memory(pgtable));
> >
> > -	ret = pm_runtime_get_sync(data->sysmmu);
> > -	if (ret < 0) {
> > -		dev_dbg(data->sysmmu, "Failed to enable\n");
> > -		return ret;
> > -	}
> > -
> > -	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
> > -	if (WARN_ON(ret < 0)) {
> > -		pm_runtime_put(data->sysmmu);
> > -		dev_err(data->sysmmu,
> > -			"Already enabled with page table %#lx\n",
> > -			data->pgtable);
> > -	} else {
> > -		data->dev = dev;
> > -	}
> > +	ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
> >
> >  	return ret;
> >  }
> >
> >  static bool exynos_sysmmu_disable(struct device *dev)
> >  {
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > -	bool disabled;
> > +	unsigned long flags;
> > +	bool disabled = true;
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int i;
> >
> > -	disabled = __exynos_sysmmu_disable(data);
> > -	pm_runtime_put(data->sysmmu);
> > +	if (WARN_ON(!client))
> > +		return true;
> > +
> > +	spin_lock_irqsave(&client->lock, flags);
> > +
> > +	/* Every call to __sysmmu_disable() must return same result */
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		struct sysmmu_drvdata *data =
> > +				dev_get_drvdata(client->sysmmu[i]);
> > +		disabled = __sysmmu_disable(data);
> > +		if (disabled)
> > +			data->master = NULL;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&client->lock, flags);
> >
> >  	return disabled;
> >  }
> >
> >  static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
> >  {
> > -	unsigned long flags;
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int i;
> >
> > -	read_lock_irqsave(&data->lock, flags);
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		unsigned long flags;
> > +		struct sysmmu_drvdata *data;
> >
> > -	if (is_sysmmu_active(data)) {
> > -		int i;
> > -		for (i = 0; i < data->nsfrs; i++) {
> > -			if (sysmmu_block(data->sfrbases[i])) {
> > +		data = dev_get_drvdata(client->sysmmu[i]);
> > +
> > +		read_lock_irqsave(&data->lock, flags);
> > +		if (is_sysmmu_active(data) && data->runtime_active) {
> > +			int i;
> > +			clk_enable(data->clk_master);
> > +			for (i = 0; i < data->nsfrs; i++)
> >  				__sysmmu_tlb_invalidate_entry(
> >  						data->sfrbases[i], iova);
> > -				sysmmu_unblock(data->sfrbases[i]);
> > -			}
> > +			clk_disable(data->clk_master);
> > +		} else {
> > +			dev_dbg(dev,
> > +				"disabled. Skipping TLB invalidation @ %#lx\n",
> > +				iova);
> >  		}
> > -	} else {
> > -		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> > +		read_unlock_irqrestore(&data->lock, flags);
> >  	}
> > -
> > -	read_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >  {
> > -	unsigned long flags;
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > -
> > -	read_lock_irqsave(&data->lock, flags);
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int i;
> >
> > -	if (is_sysmmu_active(data)) {
> > -		int i;
> > -		for (i = 0; i < data->nsfrs; i++) {
> > -			if (sysmmu_block(data->sfrbases[i])) {
> > -				__sysmmu_tlb_invalidate(data->sfrbases[i]);
> > -				sysmmu_unblock(data->sfrbases[i]);
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		unsigned long flags;
> > +		struct sysmmu_drvdata *data;
> > +
> > +		data = dev_get_drvdata(client->sysmmu[i]);
> > +
> > +		read_lock_irqsave(&data->lock, flags);
> > +		if (is_sysmmu_active(data) &&
> > +				data->runtime_active) {
> > +			int i;
> > +			for (i = 0; i < data->nsfrs; i++) {
> > +				clk_enable(data->clk_master);
> > +				if (sysmmu_block(data->sfrbases[i])) {
> > +					__sysmmu_tlb_invalidate(
> > +							data->sfrbases[i]);
> > +					sysmmu_unblock(data->sfrbases[i]);
> > +				}
> > +				clk_disable(data->clk_master);
> >  			}
> > +		} else {
> > +			dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
> >  		}
> > -	} else {
> > -		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> > +		read_unlock_irqrestore(&data->lock, flags);
> >  	}
> > -
> > -	read_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> > @@ -610,12 +709,32 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >  	pm_runtime_enable(dev);
> >
> >  	data->sysmmu = dev;
> > +
> >  	data->clk = devm_clk_get(dev, "sysmmu");
> >  	if (IS_ERR(data->clk)) {
> >  		dev_info(dev, "No gate clock found!\n");
> >  		data->clk = NULL;
> >  	}
> >
> > +	ret = clk_prepare(data->clk);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to prepare clk\n");
> > +		return ret;
> > +	}
> > +
> > +	data->clk_master = devm_clk_get(dev, "master");
> > +	if (IS_ERR(data->clk_master))
> > +		data->clk_master = NULL;
> > +
> > +	ret = clk_prepare(data->clk_master);
> > +	if (ret) {
> > +		clk_unprepare(data->clk);
> > +		dev_err(dev, "Failed to prepare master's clk\n");
> > +		return ret;
> > +	}
> > +
> > +	data->runtime_active = !pm_runtime_enabled(dev);
> > +
> >  	rwlock_init(&data->lock);
> >  	INIT_LIST_HEAD(&data->node);
> >
> > @@ -625,6 +744,34 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >  	return ret;
> >  }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_suspend(struct device *dev)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +	unsigned long flags;
> > +	read_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data) &&
> > +		(!pm_runtime_enabled(dev) || data->runtime_active))
> > +		__sysmmu_disable_nocount(data);
> > +	read_unlock_irqrestore(&data->lock, flags);
> > +	return 0;
> > +}
> > +
> > +static int sysmmu_resume(struct device *dev)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +	unsigned long flags;
> > +	read_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data) &&
> > +		(!pm_runtime_enabled(dev) || data->runtime_active))
> > +		__sysmmu_enable_nocount(data);
> > +	read_unlock_irqrestore(&data->lock, flags);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
> > +
> >  #ifdef CONFIG_OF
> >  static struct of_device_id sysmmu_of_match[] __initconst = {
> >  	{ .compatible	= "samsung,exynos4210-sysmmu", },
> > @@ -637,6 +784,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
> >  	.driver	= {
> >  		.owner		= THIS_MODULE,
> >  		.name		= "exynos-sysmmu",
> > +		.pm		= &sysmmu_pm_ops,
> >  		.of_match_table	= of_match_ptr(sysmmu_of_match),
> >  	}
> >  };
> > @@ -689,7 +837,7 @@ err_pgtable:
> >  static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >  {
> >  	struct exynos_iommu_domain *priv = domain->priv;
> > -	struct sysmmu_drvdata *data;
> > +	struct exynos_iommu_client *client;
> >  	unsigned long flags;
> >  	int i;
> >
> > @@ -697,11 +845,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >
> >  	spin_lock_irqsave(&priv->lock, flags);
> >
> > -	list_for_each_entry(data, &priv->clients, node) {
> > -		while (!exynos_sysmmu_disable(data->dev))
> > +	list_for_each_entry(client, &priv->clients, node) {
> > +		while (!exynos_sysmmu_disable(client->dev))
> >  			; /* until System MMU is actually disabled */
> >  	}
> >
> > +	while (!list_empty(&priv->clients))
> > +		list_del_init(priv->clients.next);
> > +
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> >
> >  	for (i = 0; i < NUM_LV1ENTRIES; i++)
> > @@ -718,41 +869,26 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >  static int exynos_iommu_attach_device(struct iommu_domain *domain,
> >  				   struct device *dev)
> >  {
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> >  	struct exynos_iommu_domain *priv = domain->priv;
> >  	unsigned long flags;
> >  	int ret;
> >
> > -	ret = pm_runtime_get_sync(data->sysmmu);
> > -	if (ret < 0)
> > -		return ret;
> > -
> > -	ret = 0;
> > -
> >  	spin_lock_irqsave(&priv->lock, flags);
> >
> > -	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
> > -
> > -	if (ret == 0) {
> > -		/* 'data->node' must not be appeared in priv->clients */
> > -		BUG_ON(!list_empty(&data->node));
> > -		data->dev = dev;
> > -		list_add_tail(&data->node, &priv->clients);
> > -	}
> > +	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
> > +	if (ret == 0)
> > +		list_add_tail(&client->node, &priv->clients);
> >
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -	if (ret < 0) {
> > +	if (ret < 0)
> >  		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
> >  				__func__, __pa(priv->pgtable));
> > -		pm_runtime_put(data->sysmmu);
> > -	} else if (ret > 0) {
> > -		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> > -					__func__, __pa(priv->pgtable));
> > -	} else {
> > -		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
> > -					__func__, __pa(priv->pgtable));
> > -	}
> > +	else
> > +		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
> > +					__func__, __pa(priv->pgtable),
> > +					(ret == 0) ? "" : ", again");
> >
> >  	return ret;
> >  }
> > @@ -760,39 +896,27 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
> >  static void exynos_iommu_detach_device(struct iommu_domain *domain,
> >  				    struct device *dev)
> >  {
> > -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +	struct exynos_iommu_client *client = NULL;
> >  	struct exynos_iommu_domain *priv = domain->priv;
> > -	struct list_head *pos;
> >  	unsigned long flags;
> > -	bool found = false;
> >
> >  	spin_lock_irqsave(&priv->lock, flags);
> >
> > -	list_for_each(pos, &priv->clients) {
> > -		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
> > -			found = true;
> > +	list_for_each_entry(client, &priv->clients, node) {
> > +		if (client == dev->archdata.iommu) {
> > +			if (exynos_sysmmu_disable(dev))
> > +				list_del_init(&client->node);
> >  			break;
> >  		}
> >  	}
> >
> > -	if (!found)
> > -		goto finish;
> > +	spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -	if (__exynos_sysmmu_disable(data)) {
> > +	if (client == dev->archdata.iommu)
> >  		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
> >  					__func__, __pa(priv->pgtable));
> > -		list_del_init(&data->node);
> > -
> > -	} else {
> > -		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
> > -					__func__, __pa(priv->pgtable));
> > -	}
> > -
> > -finish:
> > -	spin_unlock_irqrestore(&priv->lock, flags);
> > -
> > -	if (found)
> > -		pm_runtime_put(data->sysmmu);
> > +	else
> > +		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
> >  }
> >
> >  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> > @@ -914,7 +1038,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >  					       unsigned long iova, size_t size)
> >  {
> >  	struct exynos_iommu_domain *priv = domain->priv;
> > -	struct sysmmu_drvdata *data;
> > +	struct exynos_iommu_client *client;
> >  	unsigned long flags;
> >  	unsigned long *ent;
> >  	size_t err_pgsize;
> > @@ -975,8 +1099,8 @@ done:
> >  	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> >
> >  	spin_lock_irqsave(&priv->lock, flags);
> > -	list_for_each_entry(data, &priv->clients, node)
> > -		sysmmu_tlb_invalidate_entry(data->dev, iova);
> > +	list_for_each_entry(client, &priv->clients, node)
> > +		sysmmu_tlb_invalidate_entry(client->dev, iova);
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> >
> >  	return size;
> > @@ -1055,3 +1179,275 @@ static int __init exynos_iommu_init(void)
> >  	return ret;
> >  }
> >  subsys_initcall(exynos_iommu_init);
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_pm_genpd_suspend(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		ret = pm_generic_suspend(client->sysmmu[i]);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	if (!ret)
> > +		ret = pm_generic_suspend(dev);
> > +
> > +	if (ret) {
> > +		int j;
> > +
> > +		for (j = 0; j < i; j++)
> > +			pm_generic_resume(client->sysmmu[j]);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int sysmmu_pm_genpd_resume(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	for (i = 0; i < client->num_sysmmu; i++) {
> > +		ret = pm_generic_resume(client->sysmmu[i]);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	if (!ret)
> > +		ret = pm_generic_resume(dev);
> > +
> > +	if (ret) {
> > +		int j;
> > +
> > +		for (j = 0; j < i; j++)
> > +			pm_generic_suspend(client->sysmmu[j]);
> > +	}
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +static void sysmmu_restore_state(struct device *sysmmu)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	data->runtime_active = true;
> > +	if (is_sysmmu_active(data))
> > +		__sysmmu_enable_nocount(data);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static void sysmmu_save_state(struct device *sysmmu)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data))
> > +		__sysmmu_disable_nocount(data);
> > +	data->runtime_active = false;
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static int sysmmu_pm_genpd_save_state(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int (*cb)(struct device *__dev);
> > +	int i;
> > +
> > +	if (dev->type && dev->type->pm)
> > +		cb = dev->type->pm->runtime_suspend;
> > +	else if (dev->class && dev->class->pm)
> > +		cb = dev->class->pm->runtime_suspend;
> > +	else if (dev->bus && dev->bus->pm)
> > +		cb = dev->bus->pm->runtime_suspend;
> > +	else
> > +		cb = NULL;
> > +
> > +	if (!cb && dev->driver && dev->driver->pm)
> > +		cb = dev->driver->pm->runtime_suspend;
> > +
> > +	if (cb) {
> > +		int ret;
> > +
> > +		ret = cb(dev);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	for (i = 0; i < client->num_sysmmu; i++)
> > +		sysmmu_save_state(client->sysmmu[i]);
> > +
> > +	return 0;
> > +}
> > +
> > +static int sysmmu_pm_genpd_restore_state(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int (*cb)(struct device *__dev);
> > +	int i;
> > +
> > +	if (dev->type && dev->type->pm)
> > +		cb = dev->type->pm->runtime_resume;
> > +	else if (dev->class && dev->class->pm)
> > +		cb = dev->class->pm->runtime_resume;
> > +	else if (dev->bus && dev->bus->pm)
> > +		cb = dev->bus->pm->runtime_resume;
> > +	else
> > +		cb = NULL;
> > +
> > +	if (!cb && dev->driver && dev->driver->pm)
> > +		cb = dev->driver->pm->runtime_resume;
> > +
> > +	for (i = 0; i < client->num_sysmmu; i++)
> > +		sysmmu_restore_state(client->sysmmu[i]);
> > +
> > +	if (cb) {
> > +		int ret;
> > +		ret = cb(dev);
> > +		if (ret) {
> > +			for (i = 0; i < client->num_sysmmu; i++)
> > +				sysmmu_save_state(client->sysmmu[i]);
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_GENERIC_DOMAINS
> > +struct gpd_dev_ops sysmmu_devpm_ops = {
> > +#ifdef CONFIG_PM_RUNTIME
> > +	.save_state = &sysmmu_pm_genpd_save_state,
> > +	.restore_state = &sysmmu_pm_genpd_restore_state,
> > +#endif
> > +#ifdef CONFIG_PM_SLEEP
> > +	.suspend = &sysmmu_pm_genpd_suspend,
> > +	.resume = &sysmmu_pm_genpd_resume,
> > +#endif
> > +};
> > +#endif /* CONFIG_PM_GENERIC_DOMAINS */
> > +
> > +static int sysmmu_hook_driver_register(struct notifier_block *nb,
> > +					unsigned long val,
> > +					void *p)
> > +{
> > +	struct device *dev = p;
> > +
> > +	switch (val) {
> > +	case BUS_NOTIFY_BIND_DRIVER:
> > +	{
> > +		int i = 0;
> > +		int size = 0;
> > +		const __be32 *phandle;
> > +		struct exynos_iommu_client *client;
> > +
> > +		phandle = of_get_property(dev->of_node, "iommu", &size);
> > +		if (!phandle)
> > +			break;
> > +
> > +		size = size / sizeof(*phandle); /* number of elements */
> > +
> > +		client = devm_kzalloc(dev, sizeof(*client) * size, GFP_KERNEL);
> > +		if (!client) {
> > +			dev_err(dev, "No Memory for exynos_iommu_client\n");
> > +			return -ENOMEM;
> > +		}
> > +
> > +		client->num_sysmmu = size;
> > +		client->dev = dev;
> > +		INIT_LIST_HEAD(&client->node);
> > +		spin_lock_init(&client->lock);
> > +
> > +		for (i = 0; i < size; i++) {
> > +			struct device_node *np;
> > +			struct platform_device *sysmmu;
> > +
> > +			/* this always success: see above of_find_property() */
> > +			np = of_parse_phandle(dev->of_node, "iommu", i);
> > +
> > +			sysmmu = of_find_device_by_node(np);
> > +			if (!sysmmu) {
> > +				dev_err(dev,
> > +					"sysmmu node '%s' is not found\n",
> > +					np->name);
> > +				break;
> > +			}
> > +
> > +			client->sysmmu[i] = &sysmmu->dev;
> > +		}
> > +
> > +		if (i < size) {
> > +			while (--i >= 0)
> > +				of_node_put(client->sysmmu[i]->of_node);
> > +			devm_kfree(dev, client);
> > +			return -ENODEV;
> > +		}
> > +
> > +		i = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
> > +		if (i && (i != -ENOSYS)) {
> > +			dev_err(dev,
> > +				"Failed to register 'dev_pm_ops' for iommu\n");
> > +			devm_kfree(dev, client);
> > +			return i;
> > +		}
> > +
> > +		dev->archdata.iommu = client;
> > +		break;
> > +	}
> > +	case BUS_NOTIFY_BOUND_DRIVER:
> > +	{
> > +		struct exynos_iommu_client *client = dev->archdata.iommu;
> > +		if (dev->archdata.iommu &&
> > +				(!pm_runtime_enabled(dev) ||
> > +					 IS_ERR(dev_to_genpd(dev)))) {
> > +			int i;
> > +			for (i = 0; i < client->num_sysmmu; i++) {
> > +				struct sysmmu_drvdata *data;
> > +				pm_runtime_disable(client->sysmmu[i]);
> > +				data = dev_get_drvdata(client->sysmmu[i]);
> > +				if (!data)
> > +					continue;
> > +				data->runtime_active =
> > +					!pm_runtime_enabled(data->sysmmu);
> > +				if (data->runtime_active &&
> > +						is_sysmmu_active(data))
> > +					__sysmmu_enable_nocount(data);
> > +			}
> > +		}
> > +		break;
> > +	}
> > +	case BUS_NOTIFY_UNBOUND_DRIVER:
> > +	{
> > +		if (dev->archdata.iommu) {
> > +			__pm_genpd_remove_callbacks(dev, false);
> > +
> > +			devm_kfree(dev, dev->archdata.iommu);
> > +
> > +			dev->archdata.iommu = NULL;
> > +		}
> > +		break;
> > +	}
> > +	} /* switch (val) */
> > +
> > +	return 0;
> > +}
> > +
> > +static struct notifier_block sysmmu_notifier = {
> > +	.notifier_call = &sysmmu_hook_driver_register,
> > +};
> > +
> > +static int __init exynos_iommu_prepare(void)
> > +{
> > +	return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> > +}
> > +arch_initcall(exynos_iommu_prepare);

