Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaELGWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:22:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25584 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaELGQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:21 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-87-53706733ddf9
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 01/19] iommu/exynos: fix build errors
Date: Mon, 12 May 2014 11:44:46 +0530
Message-id: <1399875304-19948-2-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkRtc4vSDYoP2dtMWdu+dYLf5OOsZu
	Mf8IkPXqyA8miwX7rS06Z29gt/i+6wu7Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLC6s2Mhu8a/3
	IKPFlEWHWS0Ov2lntTj5p5fR4sjD3ewWLdd7mSzWz3jNYrFq1x9Gi5m31rA4iHo8OTiPyeP3
	r0mMHrMbLrJ4/Dvcz+Sxc9Zddo871/aweWxeUu8x+cZyRo++LasYPT5vkvO4cvQMUwB3FJdN
	SmpOZllqkb5dAlfGx4vvGAse1lfcW7yAtYHxf1oXIyeHhICJxL1JR5khbDGJC/fWs3UxcnEI
	CSxllLh3/BNrFyMHWNHP7XUQ8UWMEl3HHrNCOBOYJD6197GAdLMJGEpsv3cFLCEisJpRou/i
	GXYQh1lgNrPEkUeLGUGqhAUsJX53L2cCsVkEVCXuLwJZwcnBK+AucWj9FUaIdQoScybZgIQ5
	BTwkPq+ewgZiCwGVHHt1FWyBhMBaDonJk/qZIeYISHybfIgFoldWYtMBqHckJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAaD3979nEHYz3D1gfYkwGGjeRWUo0OR8Y
	7Xkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLh5
	utz7Xs+p86bHJKfy/0lgvnuXQ7djT4numdwVPGxWGYYx1abftv3s5/Fv2avpfHRHe3Wjhizz
	7Yuc7xT0jt7IDxBxmCXvfWfHv2+x4UGRXAnChpGHy93XrJhgXF6mlMd17NydDoZL06MDjO0n
	PrT7dJt50bqbPNX6i05NjUxeWeW9Jmz1ViWW4oxEQy3mouJEAHqvsEvsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3j9IJgg93vuC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZny8+I6x4GF9xb3FC1gbGP+ndTFy
	cEgImEj83F7XxcgJZIpJXLi3nq2LkYtDSGARo0TXscesEM4EJolP7X0sIFVsAoYS2+9dAUuI
	CKxmlOi7eIYdxGEWmM0sceTRYkaQKmEBS4nf3cuZQGwWAVWJ+4s+sYLYvALuEofWX2GEWK0g
	MWeSDUiYU8BD4vPqKWwgthBQybFXV1knMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iRGcCp5J7WBc2WBxiFGAg1GJh/cDQ0GwEGtiWXFl7iFGCQ5mJRHej/5AId6UxMqq1KL8+KLS
	nNTiQ4zJQEdNZJYSTc4Hpqm8knhDYxNzU2NTSxMLEzNL0oSVxHkPtFoHCgmkJ5akZqemFqQW
	wWxh4uCUamD09w6322Yluttapr5AvcxY4XV62Uv+2VWrXplw179n3vPr7bHLfbPWf3XxaCrX
	YImSVt/QsXta+5KSqJBTzaH2Ke+cxQ+p5n7t50mwtJp2dcudVYFfGpjz/Tbz39xRGffZOEeA
	/4tC6qI591/bh+TvWHIl95mr4IZmf9OVkgaiTSLiicLiVUosxRmJhlrMRcWJABVROFxJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
removing remaining use of it from exynos-iommu driver, thus causing a
compilation error.

This patch fixes the error by removing respective include line
from exynos-iommu.c.

Use of __pa and __va macro is changed to virt_to_phys and phys_to_virt
which are recommended in driver code. printk formatting of physical
address is also fixed to %pa.

Also System MMU driver is changed to control only a single instance
of System MMU at a time. Since a single instance of System MMU has only
a single clock descriptor for its clock gating, single address range
for control registers, there is no need to obtain two or more clock
descriptors and ioremaped region.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  255 ++++++++++++++----------------------------
 1 file changed, 85 insertions(+), 170 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0740189..8d7c3f9 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -29,8 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
-
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
@@ -108,7 +106,8 @@ static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 
 static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
 {
-	return (unsigned long *)__va(lv2table_base(sent)) + lv2ent_offset(iova);
+	return (unsigned long *)phys_to_virt(
+				lv2table_base(sent)) + lv2ent_offset(iova);
 }
 
 enum exynos_sysmmu_inttype {
@@ -132,7 +131,7 @@ enum exynos_sysmmu_inttype {
  *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
  */
 typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
-			unsigned long pgtable_base, unsigned long fault_addr);
+			phys_addr_t pgtable_base, unsigned long fault_addr);
 
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
@@ -170,14 +169,13 @@ struct sysmmu_drvdata {
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
 	char *dbgname;
-	int nsfrs;
-	void __iomem **sfrbases;
-	struct clk *clk[2];
+	void __iomem *sfrbase;
+	struct clk *clk;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
-	unsigned long pgtable;
+	phys_addr_t pgtable;
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -266,17 +264,17 @@ void exynos_sysmmu_set_fault_handler(struct device *dev,
 }
 
 static int default_fault_handler(enum exynos_sysmmu_inttype itype,
-		     unsigned long pgtable_base, unsigned long fault_addr)
+			phys_addr_t pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
-			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+	pr_err("%s occurred at 0x%lx(Page table base: %pa)\n",
+			sysmmu_fault_name[itype], fault_addr, &pgtable_base);
 
-	ent = section_entry(__va(pgtable_base), fault_addr);
+	ent = section_entry(phys_to_virt(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
 
 	if (lv1ent_page(ent)) {
@@ -295,56 +293,39 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
 	enum exynos_sysmmu_inttype itype;
 	unsigned long addr = -1;
-
-	int i, ret = -ENOSYS;
+	int ret = -ENOSYS;
 
 	read_lock(&data->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
-	pdev = to_platform_device(data->sysmmu);
-	for (i = 0; i < (pdev->num_resources / 2); i++) {
-		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		if (irqres && ((int)irqres->start == irq))
-			break;
-	}
-
-	if (i == pdev->num_resources) {
+	itype = (enum exynos_sysmmu_inttype)
+		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
+	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
 		itype = SYSMMU_FAULT_UNKNOWN;
-	} else {
-		itype = (enum exynos_sysmmu_inttype)
-			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
-		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
-			itype = SYSMMU_FAULT_UNKNOWN;
-		else
-			addr = __raw_readl(
-				data->sfrbases[i] + fault_reg_offset[itype]);
-	}
+	else
+		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
 
 	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev,
-				addr, itype);
+		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
 
 	if ((ret == -ENOSYS) && data->fault_handler) {
 		unsigned long base = data->pgtable;
 		if (itype != SYSMMU_FAULT_UNKNOWN)
-			base = __raw_readl(
-					data->sfrbases[i] + REG_PT_BASE_ADDR);
+			base = __raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
 		ret = data->fault_handler(itype, base, addr);
 	}
 
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
-		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
+		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
 	else
 		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
 				data->dbgname, sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
-		sysmmu_unblock(data->sfrbases[i]);
+		sysmmu_unblock(data->sfrbase);
 
 	read_unlock(&data->lock);
 
@@ -355,20 +336,16 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 {
 	unsigned long flags;
 	bool disabled = false;
-	int i;
 
 	write_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
-	for (i = 0; i < data->nsfrs; i++)
-		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	if (data->clk[1])
-		clk_disable(data->clk[1]);
-	if (data->clk[0])
-		clk_disable(data->clk[0]);
+	if (!IS_ERR(data->clk))
+		clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -394,7 +371,7 @@ finish:
 static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			unsigned long pgtable, struct iommu_domain *domain)
 {
-	int i, ret = 0;
+	int ret = 0;
 	unsigned long flags;
 
 	write_lock_irqsave(&data->lock, flags);
@@ -411,27 +388,22 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (data->clk[0])
-		clk_enable(data->clk[0]);
-	if (data->clk[1])
-		clk_enable(data->clk[1]);
+	if (!IS_ERR(data->clk))
+		clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
-	for (i = 0; i < data->nsfrs; i++) {
-		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
-		}
-
-		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	__sysmmu_set_ptbase(data->sfrbase, pgtable);
+	if ((readl(data->sfrbase + REG_MMU_VERSION) >> 28) == 3) {
+		/* System MMU version is 3.x */
+		__raw_writel((1 << 12) | (2 << 28),
+				data->sfrbase + REG_MMU_CFG);
+		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 0);
+		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 1);
 	}
 
+	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
+
 	data->domain = domain;
 
 	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
@@ -458,7 +430,7 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 	if (WARN_ON(ret < 0)) {
 		pm_runtime_put(data->sysmmu);
 		dev_err(data->sysmmu,
-			"(%s) Already enabled with page table %#lx\n",
+			"(%s) Already enabled with page table %#x\n",
 			data->dbgname, data->pgtable);
 	} else {
 		data->dev = dev;
@@ -486,13 +458,10 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate_entry(
-						data->sfrbases[i], iova);
-				sysmmu_unblock(data->sfrbases[i]);
-			}
+		if (sysmmu_block(data->sfrbase)) {
+			__sysmmu_tlb_invalidate_entry(
+					data->sfrbase, iova);
+			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
 		dev_dbg(data->sysmmu,
@@ -511,12 +480,9 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate(data->sfrbases[i]);
-				sysmmu_unblock(data->sfrbases[i]);
-			}
+		if (sysmmu_block(data->sfrbase)) {
+			__sysmmu_tlb_invalidate(data->sfrbase);
+			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
 		dev_dbg(data->sysmmu,
@@ -529,11 +495,10 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
 {
-	int i, ret;
-	struct device *dev;
+	int ret;
+	struct device *dev = &pdev->dev;
 	struct sysmmu_drvdata *data;
-
-	dev = &pdev->dev;
+	struct resource *res;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
@@ -542,82 +507,37 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	ret = dev_set_drvdata(dev, data);
-	if (ret) {
-		dev_dbg(dev, "Unabled to initialize driver data\n");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_dbg(dev, "Unable to find IOMEM region\n");
+		ret = -ENOENT;
 		goto err_init;
 	}
 
-	data->nsfrs = pdev->num_resources / 2;
-	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
-								GFP_KERNEL);
-	if (data->sfrbases == NULL) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_init;
+	data->sfrbase = ioremap(res->start, resource_size(res));
+	if (!data->sfrbase) {
+		dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n", res->start);
+		ret = -ENOENT;
+		goto err_res;
 	}
 
-	for (i = 0; i < data->nsfrs; i++) {
-		struct resource *res;
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			dev_dbg(dev, "Unable to find IOMEM region\n");
-			ret = -ENOENT;
-			goto err_res;
-		}
-
-		data->sfrbases[i] = ioremap(res->start, resource_size(res));
-		if (!data->sfrbases[i]) {
-			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
-							res->start);
-			ret = -ENOENT;
-			goto err_res;
-		}
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_dbg(dev, "Unable to find IRQ resource\n");
+		goto err_irq;
 	}
 
-	for (i = 0; i < data->nsfrs; i++) {
-		ret = platform_get_irq(pdev, i);
-		if (ret <= 0) {
-			dev_dbg(dev, "Unable to find IRQ resource\n");
-			goto err_irq;
-		}
-
-		ret = request_irq(ret, exynos_sysmmu_irq, 0,
-					dev_name(dev), data);
-		if (ret) {
-			dev_dbg(dev, "Unabled to register interrupt handler\n");
-			goto err_irq;
-		}
+	ret = request_irq(ret, exynos_sysmmu_irq, 0,
+				dev_name(dev), data);
+	if (ret) {
+		dev_dbg(dev, "Unabled to register interrupt handler\n");
+		goto err_irq;
 	}
 
 	if (dev_get_platdata(dev)) {
-		char *deli, *beg;
-		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
-
-		beg = platdata->clockname;
-
-		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
-			/* NOTHING */;
-
-		if (*deli == '\0')
-			deli = NULL;
-		else
-			*deli = '\0';
-
-		data->clk[0] = clk_get(dev, beg);
-		if (IS_ERR(data->clk[0])) {
-			data->clk[0] = NULL;
+		data->clk = clk_get(dev, "sysmmu");
+		if (IS_ERR(data->clk))
 			dev_dbg(dev, "No clock descriptor registered\n");
-		}
-
-		if (data->clk[0] && deli) {
-			*deli = ',';
-			data->clk[1] = clk_get(dev, deli + 1);
-			if (IS_ERR(data->clk[1]))
-				data->clk[1] = NULL;
-		}
-
-		data->dbgname = platdata->dbgname;
 	}
 
 	data->sysmmu = dev;
@@ -626,22 +546,17 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	__set_fault_handler(data, &default_fault_handler);
 
+	platform_set_drvdata(pdev, data);
+
 	if (dev->parent)
 		pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
 err_irq:
-	while (i-- > 0) {
-		int irq;
-
-		irq = platform_get_irq(pdev, i);
-		free_irq(irq, data);
-	}
+	free_irq(platform_get_irq(pdev, 0), data);
 err_res:
-	while (data->nsfrs-- > 0)
-		iounmap(data->sfrbases[data->nsfrs]);
-	kfree(data->sfrbases);
+	iounmap(data->sfrbase);
 err_init:
 	kfree(data);
 err_alloc:
@@ -722,7 +637,7 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kfree(phys_to_virt(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -735,6 +650,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	struct exynos_iommu_domain *priv = domain->priv;
+	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	int ret;
 
@@ -746,7 +662,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
+	ret = __exynos_sysmmu_enable(data, pagetable, domain);
 
 	if (ret == 0) {
 		/* 'data->node' must not be appeared in priv->clients */
@@ -758,17 +674,15 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (ret < 0) {
-		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
-				__func__, __pa(priv->pgtable));
+		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
+					__func__, &pagetable);
 		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
-	} else {
-		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
-					__func__, __pa(priv->pgtable));
+		return ret;
 	}
 
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable %pa %s\n",
+		__func__, &pagetable, (ret == 0) ? "" : ", again");
+
 	return ret;
 }
 
@@ -778,6 +692,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	struct exynos_iommu_domain *priv = domain->priv;
 	struct list_head *pos;
+	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	bool found = false;
 
@@ -794,13 +709,13 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		goto finish;
 
 	if (__exynos_sysmmu_disable(data)) {
-		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
-					__func__, __pa(priv->pgtable));
+		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
+					__func__, &pagetable);
 		list_del_init(&data->node);
 
 	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
-					__func__, __pa(priv->pgtable));
+		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %pa delayed",
+					__func__, &pagetable);
 	}
 
 finish:
@@ -821,7 +736,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 		if (!pent)
 			return NULL;
 
-		*sent = mk_lv1ent_page(__pa(pent));
+		*sent = mk_lv1ent_page(virt_to_phys(pent));
 		*pgcounter = NUM_LV2ENTRIES;
 		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
 		pgtable_flush(sent, sent + 1);
-- 
1.7.9.5

