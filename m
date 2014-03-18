Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaCRKbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:31:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22416 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaCRKbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:31:50 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-99-53282094cb36
Date: Tue, 18 Mar 2014 19:31:47 +0900
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
Subject: Re: [PATCH v11 08/27] iommu/exynos: always use a single clock
 descriptor
Message-id: <20140318193147.caf416480fa1a14ea5ceed63@samsung.com>
In-reply-to: <5322FF14.5040908@samsung.com>
References: <20140314140517.a7ac6c35b68177784d20b755@samsung.com>
 <5322FF14.5040908@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zI90pChrBBh9mSVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXxYMkD5oIvMRU31+9kbGBc7dbFyMkhIWAisb1lPhuE
	LSZx4d56IJuLQ0hgGaPEi6UNLDBFcx9PYIJILGKU2HDkIAuEM5lJovnMIWaQKhYBVYmH716w
	g9hsAloSq+ceZwSxRQRUJC6fms4I0sAs0Mgq8ej+MrAiYYFgiYXPV4HZvAKOEo+fXgUbxCmg
	LbFlzTswW0ggSeLh2R/sEGdYSFxo6oCqF5T4Mfke2HnMQMs2b2tihbDlJTavecsMskxCYCGH
	xNp5HxkhrhOQ+Db5EFADB1BCVmLTAWaImZISB1fcYJnAKDYLydhZSMbOQjJ2ASPzKkbR1ILk
	guKk9CJDveLE3OLSvHS95PzcTYyQeO/dwXj7gPUhxmSglROZpUST84HpIq8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGC/zbue+ss9Xvkpf+ZP8
	mn9PrHZzKPmwfZsq8MzGVmCPt1x9YLNidXOAT99Mh2vL186TO8L7VuXx0/k/nrHvsnCVSrDf
	cvJqhuqSiv3X9t81PvGXvUO2pPzSmY7sL/85LltynTa/c+ZNxW+f+U3NqssY/belGlm//sZ4
	6s+D+QpXtkg4pDs8iFBiKc5INNRiLipOBABNj8JNDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd0pChrBBjsbhC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WDJA+aCLzEV
	N9fvZGxgXO3WxcjJISFgIjH38QQmCFtM4sK99WxdjFwcQgKLGCU2HDnIAuFMZpJoPnOIGaSK
	RUBV4uG7F+wgNpuAlsTquccZQWwRARWJy6emM4I0MAs0sko8ur8MrEhYIFhi4fNVYDavgKPE
	46dXwQZxCmhLbFnzDswWEkiSeHj2BzvEGRYSF5o6oOoFJX5MvscCYjMDLdu8rYkVwpaX2Lzm
	LfMERoFZSMpmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgZPJMegfjqgaL
	Q4wCHIxKPLwv2NSDhVgTy4orcw8xSnAwK4nwnhDRCBbiTUmsrEotyo8vKs1JLT7EmAwMjonM
	UqLJ+cBEl1cSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjLye
	UUbO4nY75pR9mnRXt0x7Vd0Jzf7ifEvD1M5ybidl7uCvZR7fo5yNNzpFLHnx/YzKlBMCpk93
	xcVvOs+0k9N/uXnRmw0nrofOi4pozO5dtHaxcCGrevtDn7y9ohb9D51rQo54PdQ756j5/vwj
	wzt8GUkeNrUXPknOnjAraVecsH8AQ2u7EktxRqKhFnNRcSIAKB+Jm2oDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 14:07:32 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:05, Cho KyongHo wrote:
> > System MMU driver is changed to control only a single instance of
> > System MMU at a time. Since a single instance of System MMU has only
> > a single clock descriptor for its clock gating, there is no need to
> > obtain two or more clock descriptors.
> >
> 
> This patch does much more than just making the driver use a single clock 
> descriptor. Please update the subject and description accordingly.
> 
Ok.

> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   drivers/iommu/exynos-iommu.c |  223 ++++++++++++++----------------------------
> >   1 file changed, 72 insertions(+), 151 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 8dc7031..a4499b2 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -171,9 +171,8 @@ struct sysmmu_drvdata {
> >   	struct device *sysmmu;	/* System MMU's device descriptor */
> >   	struct device *dev;	/* Owner of system MMU */
> >   	char *dbgname;
> > -	int nsfrs;
> > -	void __iomem **sfrbases;
> > -	struct clk *clk[2];
> > +	void __iomem *sfrbase;
> > +	struct clk *clk;
> >   	int activations;
> >   	rwlock_t lock;
> >   	struct iommu_domain *domain;
> > @@ -294,56 +293,39 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >   {
> >   	/* SYSMMU is in blocked when interrupt occurred. */
> >   	struct sysmmu_drvdata *data = dev_id;
> > -	struct resource *irqres;
> > -	struct platform_device *pdev;
> >   	enum exynos_sysmmu_inttype itype;
> >   	unsigned long addr = -1;
> > -
> > -	int i, ret = -ENOSYS;
> > +	int ret = -ENOSYS;
> >
> >   	read_lock(&data->lock);
> >
> >   	WARN_ON(!is_sysmmu_active(data));
> >
> > -	pdev = to_platform_device(data->sysmmu);
> > -	for (i = 0; i < (pdev->num_resources / 2); i++) {
> > -		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> > -		if (irqres && ((int)irqres->start == irq))
> > -			break;
> > -	}
> > -
> > -	if (i == pdev->num_resources) {
> > +	itype = (enum exynos_sysmmu_inttype)
> > +		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
> > +	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
> >   		itype = SYSMMU_FAULT_UNKNOWN;
> > -	} else {
> > -		itype = (enum exynos_sysmmu_inttype)
> > -			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
> > -		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
> > -			itype = SYSMMU_FAULT_UNKNOWN;
> > -		else
> > -			addr = __raw_readl(
> > -				data->sfrbases[i] + fault_reg_offset[itype]);
> > -	}
> > +	else
> > +		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
> >
> >   	if (data->domain)
> > -		ret = report_iommu_fault(data->domain, data->dev,
> > -				addr, itype);
> > +		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
> >
> >   	if ((ret == -ENOSYS) && data->fault_handler) {
> >   		unsigned long base = data->pgtable;
> >   		if (itype != SYSMMU_FAULT_UNKNOWN)
> > -			base = __raw_readl(
> > -					data->sfrbases[i] + REG_PT_BASE_ADDR);
> > +			base = __raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
> >   		ret = data->fault_handler(itype, base, addr);
> >   	}
> >
> >   	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> > -		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
> > +		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
> >   	else
> >   		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
> >   				data->dbgname, sysmmu_fault_name[itype]);
> >
> >   	if (itype != SYSMMU_FAULT_UNKNOWN)
> > -		sysmmu_unblock(data->sfrbases[i]);
> > +		sysmmu_unblock(data->sfrbase);
> >
> >   	read_unlock(&data->lock);
> >
> > @@ -354,20 +336,16 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> >   {
> >   	unsigned long flags;
> >   	bool disabled = false;
> > -	int i;
> >
> >   	write_lock_irqsave(&data->lock, flags);
> >
> >   	if (!set_sysmmu_inactive(data))
> >   		goto finish;
> >
> > -	for (i = 0; i < data->nsfrs; i++)
> > -		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > +	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
> >
> > -	if (data->clk[1])
> > -		clk_disable(data->clk[1]);
> > -	if (data->clk[0])
> > -		clk_disable(data->clk[0]);
> > +	if (data->clk)
> 
> I know this is already in the driver, but checking (struct clk *) for 
> NULL is incorrect. NULL is a valid pointer for dummy clocks on platforms 
> which do not provide particular clocks, to make this transparent to 
> drivers. IS_ERR() should be used to check whether a clock pointer is valid.
> 
> This patch is changing all the clock code anyway, so this change could 
> be squashed into it to fix this.
> 
Ok. Thank you for the information.

> > +		clk_disable(data->clk);
> >
> >   	disabled = true;
> >   	data->pgtable = 0;
> > @@ -393,7 +371,7 @@ finish:
> >   static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> >   			unsigned long pgtable, struct iommu_domain *domain)
> >   {
> > -	int i, ret = 0;
> > +	int ret = 0;
> >   	unsigned long flags;
> >
> >   	write_lock_irqsave(&data->lock, flags);
> > @@ -410,17 +388,14 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> >   		goto finish;
> >   	}
> >
> > -	if (data->clk[0])
> > -		clk_enable(data->clk[0]);
> > -	if (data->clk[1])
> > -		clk_enable(data->clk[1]);
> > +	if (data->clk)
> > +		clk_enable(data->clk);
> >
> >   	data->pgtable = pgtable;
> >
> > -	for (i = 0; i < data->nsfrs; i++) {
> > -		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> > -		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > -	}
> > +	__sysmmu_set_ptbase(data->sfrbase, pgtable);
> > +
> > +	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
> >
> >   	data->domain = domain;
> >
> > @@ -477,28 +452,26 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
> >   	read_lock_irqsave(&data->lock, flags);
> >
> >   	if (is_sysmmu_active(data)) {
> > -		int i;
> > -		for (i = 0; i < data->nsfrs; i++) {
> > -			unsigned int maj;
> > -			unsigned int num_inv = 1;
> > -			maj = __raw_readl(data->sfrbases[i] + REG_MMU_VERSION);
> > -			/*
> > -			 * L2TLB invalidation required
> > -			 * 4KB page: 1 invalidation
> > -			 * 64KB page: 16 invalidation
> > -			 * 1MB page: 64 invalidation
> > -			 * because it is set-associative TLB
> > -			 * with 8-way and 64 sets.
> > -			 * 1MB page can be cached in one of all sets.
> > -			 * 64KB page can be one of 16 consecutive sets.
> > -			 */
> > -			if ((maj >> 28) == 2) /* major version number */
> > -				num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
> > -			if (sysmmu_block(data->sfrbases[i])) {
> > -				__sysmmu_tlb_invalidate_entry(
> > -					data->sfrbases[i], iova, num_inv);
> > -				sysmmu_unblock(data->sfrbases[i]);
> > -			}
> > +		unsigned int maj;
> > +		unsigned int num_inv = 1;
> > +		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
> > +		/*
> > +		 * L2TLB invalidation required
> > +		 * 4KB page: 1 invalidation
> > +		 * 64KB page: 16 invalidation
> > +		 * 1MB page: 64 invalidation
> > +		 * because it is set-associative TLB
> > +		 * with 8-way and 64 sets.
> > +		 * 1MB page can be cached in one of all sets.
> > +		 * 64KB page can be one of 16 consecutive sets.
> > +		 */
> > +		if ((maj >> 28) == 2) /* major version number */
> > +			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
> > +
> > +		if (sysmmu_block(data->sfrbase)) {
> > +			__sysmmu_tlb_invalidate_entry(data->sfrbase, iova,
> > +							num_inv);
> > +			sysmmu_unblock(data->sfrbase);
> >   		}
> >   	} else {
> >   		dev_dbg(data->sysmmu,
> > @@ -517,12 +490,9 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >   	read_lock_irqsave(&data->lock, flags);
> >
> >   	if (is_sysmmu_active(data)) {
> > -		int i;
> > -		for (i = 0; i < data->nsfrs; i++) {
> > -			if (sysmmu_block(data->sfrbases[i])) {
> > -				__sysmmu_tlb_invalidate(data->sfrbases[i]);
> > -				sysmmu_unblock(data->sfrbases[i]);
> > -			}
> > +		if (sysmmu_block(data->sfrbase)) {
> > +			__sysmmu_tlb_invalidate(data->sfrbase);
> > +			sysmmu_unblock(data->sfrbase);
> >   		}
> >   	} else {
> >   		dev_dbg(data->sysmmu,
> > @@ -535,11 +505,10 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >
> >   static int exynos_sysmmu_probe(struct platform_device *pdev)
> >   {
> > -	int i, ret;
> > -	struct device *dev;
> > +	int ret;
> > +	struct device *dev = &pdev->dev;
> >   	struct sysmmu_drvdata *data;
> > -
> > -	dev = &pdev->dev;
> > +	struct resource *res;
> >
> >   	data = kzalloc(sizeof(*data), GFP_KERNEL);
> >   	if (!data) {
> > @@ -548,82 +517,39 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >   		goto err_alloc;
> >   	}
> >
> > -	ret = dev_set_drvdata(dev, data);
> > -	if (ret) {
> > -		dev_dbg(dev, "Unabled to initialize driver data\n");
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_dbg(dev, "Unable to find IOMEM region\n");
> > +		ret = -ENOENT;
> >   		goto err_init;
> >   	}
> >
> > -	data->nsfrs = pdev->num_resources / 2;
> > -	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
> > -								GFP_KERNEL);
> > -	if (data->sfrbases == NULL) {
> > -		dev_dbg(dev, "Not enough memory\n");
> > -		ret = -ENOMEM;
> > -		goto err_init;
> > +	data->sfrbase = ioremap(res->start, resource_size(res));
> > +	if (!data->sfrbase) {
> > +		dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n", res->start);
> > +		ret = -ENOENT;
> > +		goto err_res;
> >   	}
> >
> > -	for (i = 0; i < data->nsfrs; i++) {
> > -		struct resource *res;
> > -		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> > -		if (!res) {
> > -			dev_dbg(dev, "Unable to find IOMEM region\n");
> > -			ret = -ENOENT;
> > -			goto err_res;
> > -		}
> > -
> > -		data->sfrbases[i] = ioremap(res->start, resource_size(res));
> > -		if (!data->sfrbases[i]) {
> > -			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
> > -							res->start);
> > -			ret = -ENOENT;
> > -			goto err_res;
> > -		}
> > +	ret = platform_get_irq(pdev, 0);
> > +	if (ret <= 0) {
> > +		dev_dbg(dev, "Unable to find IRQ resource\n");
> > +		goto err_irq;
> >   	}
> >
> > -	for (i = 0; i < data->nsfrs; i++) {
> > -		ret = platform_get_irq(pdev, i);
> > -		if (ret <= 0) {
> > -			dev_dbg(dev, "Unable to find IRQ resource\n");
> > -			goto err_irq;
> > -		}
> > -
> > -		ret = request_irq(ret, exynos_sysmmu_irq, 0,
> > -					dev_name(dev), data);
> > -		if (ret) {
> > -			dev_dbg(dev, "Unabled to register interrupt handler\n");
> > -			goto err_irq;
> > -		}
> > +	ret = request_irq(ret, exynos_sysmmu_irq, 0,
> > +				dev_name(dev), data);
> > +	if (ret) {
> > +		dev_dbg(dev, "Unabled to register interrupt handler\n");
> > +		goto err_irq;
> >   	}
> >
> >   	if (dev_get_platdata(dev)) {
> > -		char *deli, *beg;
> > -		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
> > -
> > -		beg = platdata->clockname;
> > -
> > -		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
> > -			/* NOTHING */;
> > -
> > -		if (*deli == '\0')
> > -			deli = NULL;
> > -		else
> > -			*deli = '\0';
> > -
> > -		data->clk[0] = clk_get(dev, beg);
> > -		if (IS_ERR(data->clk[0])) {
> > -			data->clk[0] = NULL;
> > +		data->clk = clk_get(dev, "sysmmu");
> > +		if (IS_ERR(data->clk)) {
> > +			data->clk = NULL;
> 
> This is incorrect. IS_ERR() should be used through the driver and the 
> error value here should not be replaced with NULL.
> 
Ok.

Thank you for the review.

KyongHo.
