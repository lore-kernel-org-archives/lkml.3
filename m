Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaD0Hl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31218 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaD0Hju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:50 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-de-535cb444f0d9
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 22/31] iommu/exynos: use exynos-iommu specific typedef
Date: Sun, 27 Apr 2014 13:07:54 +0530
Message-id: <1398584283-22846-23-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkTtd1S0ywwbNWdos7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Bbfd31ht+hdcJXNYtPja6wWl3fNYbOYcX4fk8WFFRvZLf71HmS0mLLo
	MKvF4TftrBYn//QyWrRc72WyWD/jNYvFql1/GC1m3lrD4iDs8eTgPCaP2Q0XWTz+He5n8tg5
	6y67x51re9g8Ni+p95h8YzmjR9+WVYwenzfJeVw5eoYpgCuKyyYlNSezLLVI3y6BK+PIXt2C
	2QkVdy7MYWpgbPLrYuTkkBAwkZh67jYThC0mceHeerYuRi4OIYGljBKHLyxngina9mkxI0Ri
	EaPExu8TGUESQgITmCSe3qkCsdkEDCW237vCClIkIrCaUaLv4hl2EIdZ4C6TxJxV78A6hAW8
	JB63bWYFsVkEVCXmLugFs3kFPCTOL34CtJsDaJ2CxJxJNiBhTqDwkzt7WCCWuUu8PfUFbIGE
	wFQOiUc35jJDzBGQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJ
	ucWleel6yfm5mxiB0Xj637P+HYx3D1gfYkwGGjeRWUo0OR8YzXkl8YbGZkYWpiamxkbmlmak
	CSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZFb8UrpTIP7f6KWbS77YLO7pfnj
	FQfnrWwOC09UKPGJneyyd6t223nPa+ZdJTaF5xY7w4rtdWRKggTFTrl/+MQ13V6abfkvZRt/
	/2RHh2Xyy5d84v3+rk1zhkZTTvvbp25/LrvX6JUH5QQueyVpFd0aLmzxrEHx7PIY7m+ez7iO
	H9SsfVf0SomlOCPRUIu5qDgRAINSPc/cAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV2XLTHBBv2PzS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaNFyvZfJYv2M1ywWq3b9YbSYeWsNi4Owx5OD85g8ZjdcZPH4d7ifyWPn
	rLvsHneu7WHz2Lyk3mPyjeWMHn1bVjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDXlBTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZR/bqFsxOqLhzYQ5TA2OTXxcjJ4eEgInEtk+LGSFsMYkL99az
	dTFycQgJLGKU2Ph9IlhCSGACk8TTO1UgNpuAocT2e1dYQYpEBFYzSvRdPMMO4jAL3GWSmLPq
	HViHsICXxOO2zawgNouAqsTcBb1gNq+Ah8T5xU+AVnAArVOQmDPJBiTMCRR+cmcPC8Qyd4m3
	p76wTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjONafSe1gXNlgcYhRgINRiYd3
	gWRMsBBrYllxZe4hRgkOZiURXs7pQCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB6ahvJJ4
	Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpglFcsVoy4NydEPKxi
	w7+rKg/ccxPvVhyY9EEs+o62mEyIRe2db7ceZkQKx67jPnHsJ8My4eKcSyJ3V96/Xd5Uf+D+
	zE2bWyJVU7bcv3vvttOUr2w8FQYGTyzz+VIMr2euPdLTdrU/btHciMYVzrV2/E8rv0W3Rvtv
	5JerY7nn8qc1fQ2n871QJZbijERDLeai4kQAJG74uzkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit introduces sysmmu_pte_t for page table entries and
sysmmu_iova_t vor I/O virtual address that is manipulated by
exynos-iommu driver. The purpose of the typedef is to remove
dependencies to the driver code from the change of CPU architecture
from 32 bit to 64 bit.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  117 ++++++++++++++++++++++++------------------
 1 file changed, 67 insertions(+), 50 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 08a7ce0..00915f2 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -33,6 +33,9 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
+typedef u32 sysmmu_iova_t;
+typedef u32 sysmmu_pte_t;
+
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
@@ -54,20 +57,32 @@
 #define lv2ent_small(pent) ((*(pent) & 2) == 2)
 #define lv2ent_large(pent) ((*(pent) & 3) == 1)
 
+static u32 sysmmu_page_offset(sysmmu_iova_t iova, u32 size)
+{
+	return iova & (size - 1);
+}
+
 #define section_phys(sent) (*(sent) & SECT_MASK)
-#define section_offs(iova) ((iova) & 0xFFFFF)
+#define section_offs(iova) sysmmu_page_offset((iova), SECT_SIZE)
 #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
-#define lpage_offs(iova) ((iova) & 0xFFFF)
+#define lpage_offs(iova) sysmmu_page_offset((iova), LPAGE_SIZE)
 #define spage_phys(pent) (*(pent) & SPAGE_MASK)
-#define spage_offs(iova) ((iova) & 0xFFF)
-
-#define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
-#define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
+#define spage_offs(iova) sysmmu_page_offset((iova), SPAGE_SIZE)
 
 #define NUM_LV1ENTRIES 4096
-#define NUM_LV2ENTRIES 256
+#define NUM_LV2ENTRIES (SECT_SIZE / SPAGE_SIZE)
 
-#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(long))
+static u32 lv1ent_offset(sysmmu_iova_t iova)
+{
+	return iova >> SECT_ORDER;
+}
+
+static u32 lv2ent_offset(sysmmu_iova_t iova)
+{
+	return (iova >> SPAGE_ORDER) & (NUM_LV2ENTRIES - 1);
+}
+
+#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(sysmmu_pte_t))
 
 #define SPAGES_PER_LPAGE (LPAGE_SIZE / SPAGE_SIZE)
 
@@ -124,14 +139,14 @@
 
 static struct kmem_cache *lv2table_kmem_cache;
 
-static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
+static sysmmu_pte_t *section_entry(sysmmu_pte_t *pgtable, sysmmu_iova_t iova)
 {
 	return pgtable + lv1ent_offset(iova);
 }
 
-static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
+static sysmmu_pte_t *page_entry(sysmmu_pte_t *sent, sysmmu_iova_t iova)
 {
-	return (unsigned long *)phys_to_virt(
+	return (sysmmu_pte_t *)phys_to_virt(
 				lv2table_base(sent)) + lv2ent_offset(iova);
 }
 
@@ -183,7 +198,7 @@ struct exynos_iommu_owner {
 
 struct exynos_iommu_domain {
 	struct list_head clients; /* list of sysmmu_drvdata.node */
-	unsigned long *pgtable; /* lv1 page table, 16KB */
+	sysmmu_pte_t *pgtable; /* lv1 page table, 16KB */
 	short *lv2entcnt; /* free lv2 entry counter for each section */
 	spinlock_t lock; /* lock for this structure */
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
@@ -277,7 +292,7 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 }
 
 static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-				unsigned long iova, unsigned int num_inv)
+				sysmmu_iova_t iova, unsigned int num_inv)
 {
 	unsigned int i;
 	for (i = 0; i < num_inv; i++) {
@@ -288,7 +303,7 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 }
 
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
-				       unsigned long pgd)
+				       phys_addr_t pgd)
 {
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
@@ -297,22 +312,22 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 
 static void show_fault_information(const char *name,
 		enum exynos_sysmmu_inttype itype,
-		phys_addr_t pgtable_base, unsigned long fault_addr)
+		phys_addr_t pgtable_base, sysmmu_iova_t fault_addr)
 {
-	unsigned long *ent;
+	sysmmu_pte_t *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at %#lx by %s(Page table base: %pa)\n",
+	pr_err("%s occurred at %#x by %s(Page table base: %pa)\n",
 		sysmmu_fault_name[itype], fault_addr, name, &pgtable_base);
 
 	ent = section_entry(phys_to_virt(pgtable_base), fault_addr);
-	pr_err("\tLv1 entry: 0x%lx\n", *ent);
+	pr_err("\tLv1 entry: %#x\n", *ent);
 
 	if (lv1ent_page(ent)) {
 		ent = page_entry(ent, fault_addr);
-		pr_err("\t Lv2 entry: 0x%lx\n", *ent);
+		pr_err("\t Lv2 entry: %#x\n", *ent);
 	}
 }
 
@@ -321,7 +336,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
 	enum exynos_sysmmu_inttype itype;
-	unsigned long addr = -1;
+	sysmmu_iova_t addr = -1;
 	int ret = -ENOSYS;
 
 	WARN_ON(!is_sysmmu_active(data));
@@ -345,7 +360,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 			__func__);
 		BUG();
 	} else {
-		unsigned long base =
+		unsigned int base =
 				__raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
 		show_fault_information(dev_name(data->sysmmu),
 					itype, base, addr);
@@ -411,7 +426,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	unsigned long cfg = CFG_LRU | CFG_QOS(15);
+	unsigned int cfg = CFG_LRU | CFG_QOS(15);
 	int maj, min = 0;
 
 	maj = __sysmmu_version(data, &min);
@@ -449,7 +464,7 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 }
 
 static int __sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+			phys_addr_t pgtable, struct iommu_domain *domain)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -478,12 +493,12 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 }
 
 /* __exynos_sysmmu_enable: Enables System MMU
-*
-* returns -error if an error occurred and System MMU is not enabled,
-* 0 if the System MMU has been just enabled and 1 if System MMU was already
-* enabled before.
-*/
-static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
+ *
+ * returns -error if an error occurred and System MMU is not enabled,
+ * 0 if the System MMU has been just enabled and 1 if System MMU was already
+ * enabled before.
+ */
+static int __exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable,
 				  struct iommu_domain *domain)
 {
 	int ret = 0;
@@ -517,7 +532,7 @@ static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
 	return ret;
 }
 
-int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
+int exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable)
 {
 	BUG_ON(!memblock_is_memory(pgtable));
 
@@ -548,7 +563,7 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 					size_t size)
 {
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
@@ -590,7 +605,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 				clk_disable(data->clk_master);
 		} else {
 			dev_dbg(dev,
-				"disabled. Skipping TLB invalidation @ %#lx\n",
+				"disabled. Skipping TLB invalidation @ %#x\n",
 				iova);
 		}
 
@@ -856,7 +871,7 @@ static int exynos_iommu_domain_init(struct iommu_domain *domain)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pgtable = (unsigned long *)__get_free_pages(
+	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(
 						GFP_KERNEL | __GFP_ZERO, 2);
 	if (!priv->pgtable)
 		goto err_pgtable;
@@ -978,19 +993,19 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
-static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
+static sysmmu_pte_t *alloc_lv2entry(sysmmu_pte_t *sent, sysmmu_iova_t iova,
 					short *pgcounter)
 {
 	if (lv1ent_section(sent)) {
-		WARN(1, "Trying mapping on %#08lx mapped with 1MiB page", iova);
+		WARN(1, "Trying mapping on %#08x mapped with 1MiB page", iova);
 		return ERR_PTR(-EADDRINUSE);
 	}
 
 	if (lv1ent_fault(sent)) {
-		unsigned long *pent;
+		sysmmu_pte_t *pent;
 
 		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
-		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
+		BUG_ON((unsigned int)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
 
@@ -1003,18 +1018,18 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	return page_entry(sent, iova);
 }
 
-static int lv1set_section(unsigned long *sent, unsigned long iova,
+static int lv1set_section(sysmmu_pte_t *sent, sysmmu_iova_t iova,
 			  phys_addr_t paddr, short *pgcnt)
 {
 	if (lv1ent_section(sent)) {
-		WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+		WARN(1, "Trying mapping on 1MiB@%#08x that is mapped",
 			iova);
 		return -EADDRINUSE;
 	}
 
 	if (lv1ent_page(sent)) {
 		if (*pgcnt != NUM_LV2ENTRIES) {
-			WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+			WARN(1, "Trying mapping on 1MiB@%#08x that is mapped",
 				iova);
 			return -EADDRINUSE;
 		}
@@ -1030,7 +1045,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 	return 0;
 }
 
-static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
+static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
@@ -1062,11 +1077,12 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 	return 0;
 }
 
-static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 			 phys_addr_t paddr, size_t size, int prot)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	unsigned long *entry;
+	sysmmu_pte_t *entry;
+	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	unsigned long flags;
 	int ret = -ENOMEM;
 
@@ -1080,7 +1096,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 		ret = lv1set_section(entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
-		unsigned long *pent;
+		sysmmu_pte_t *pent;
 
 		pent = alloc_lv2entry(entry, iova,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
@@ -1093,7 +1109,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	}
 
 	if (ret)
-		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
+		pr_debug("%s: Failed to map iova %#x/%#zx bytes\n",
 							__func__, iova, size);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
@@ -1102,13 +1118,14 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 
 static size_t exynos_iommu_unmap(struct iommu_domain *domain,
-					       unsigned long iova, size_t size)
+				       unsigned long l_iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
 	struct exynos_iommu_owner *owner;
-	unsigned long flags;
-	unsigned long *ent;
+	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
+	sysmmu_pte_t *ent;
 	size_t err_pgsize;
+	unsigned long flags;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -1175,7 +1192,7 @@ err:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	WARN(1,
-	"%s: Failed due to size(%#x) @ %#08lx is smaller than page size %#x\n",
+	"%s: Failed due to size(%#zx) @ %#x is smaller than page size %#zx\n",
 	__func__, size, iova, err_pgsize);
 
 	return 0;
@@ -1185,7 +1202,7 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 					  dma_addr_t iova)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	unsigned long *entry;
+	sysmmu_pte_t *entry;
 	unsigned long flags;
 	phys_addr_t phys = 0;
 
-- 
1.7.9.5

