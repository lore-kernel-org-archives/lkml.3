Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaCNFNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:13:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24137 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaCNFNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:13:36 -0400
X-AuditID: cbfee68f-b7f156d00000276c-1a-53228fdff695
Date: Fri, 14 Mar 2014 14:13:02 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 24/27] iommu/exynos: use exynos-iommu specific typedef
Message-id: <20140314141302.393cfdf96dd7b82eee3f700e@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA937/UrBBjMOCVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJWx8PgHxoI3MRU7V/E1MK717mLk5JAQMJH48uUEG4Qt
	JnHh3nogm4tDSGAZo0Tzni4mmKIXe9sYIRKLGCWez13EAuFMZpLYfWsJK0gVi4CqxMaN7WA2
	m4CWxOq5x8E6RATamCS+Nh4C62AWmMss8fHbHLCFwgJeEp8uHGYBsXkFHCWufZrJArHPQuJC
	Uwc7RFxQ4sfke2BxZqCpm7c1sULY8hKb17xlBhkqIdDJIfHs7gt2iDMEJL5NBtnGAZSQldh0
	gBlipqTEwRU3WCYwisxCMnYWkrGzkIxdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMk
	fvt3MN49YH2IMRlo5URmKdHkfGD855XEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGRvXwj6GGX4W27H/i9k2/Iavay/HKPIlXuZNX6stquBvX1IgE
	mGpG/Onez3OI++RFDqkvq552CcZ6r4masrG0acF55m2SXyoixXwYYivyi18+9V0UKx+jdKRx
	0QbXhSv0N3M9cp8cvS1h09/b+4Q2Jub4iejyNh+ZeCjR7Esw47s5PqudSjZvVGIpzkg01GIu
	Kk4EAHDKd571AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd37/UrBBj+PcFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+HxD4wFb2Iq
	dq7ia2Bc693FyMkhIWAi8WJvGyOELSZx4d56ti5GLg4hgUWMEs/nLmKBcCYzSey+tYQVpIpF
	QFVi48Z2MJtNQEti9dzjjCBFIgJtTBJfGw+BdTALzGWW+PhtDhtIlbCAl8SnC4dZQGxeAUeJ
	a59mskDss5C40NTBDhEXlPgx+R5YnBlo6uZtTawQtrzE5jVvmScw8s1CUjYLSdksJGULGJlX
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnh2dSOxhXNlgcYhTgYFTi4XU4rBgsxJpYVlyZ
	e4hRgoNZSYS3KkIpWIg3JbGyKrUoP76oNCe1+BBjMtDfE5mlRJPzgYkrryTe0NjEzMjSyMzC
	yMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYfQoj5v/9dGX7mvnTtr5IfuEy12rL
	OYbTe/efK2h0vRXwMzvOuym81okloj37/pE3j9qur5bsEiuY9rRk6qnTRkWx1/qWLNrPJ/X6
	SeQxJ9WZH66YzmA6V2rcGF+kerQylnva07BoX92JG7JPGpTksHAJBHPq/tXh3nMl9lVDztzk
	f/snhejoKLEUZyQaajEXFScCAI3MdWdSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces sysmmu_pte_t for page table entries and
sysmmu_iova_t vor I/O virtual address that is manipulated by
exynos-iommu driver. The purpose of the typedef is to remove
dependencies to the driver code from the change of CPU architecture
from 32 bit to 64 bit.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  103 ++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e375501..6e716cc 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -56,19 +56,19 @@
 #define lv2ent_large(pent) ((*(pent) & 3) == 1)
 
 #define section_phys(sent) (*(sent) & SECT_MASK)
-#define section_offs(iova) ((iova) & 0xFFFFF)
+#define section_offs(iova) ((sysmmu_iova_t)(iova) & 0xFFFFF)
 #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
-#define lpage_offs(iova) ((iova) & 0xFFFF)
+#define lpage_offs(iova) ((sysmmu_iova_t)(iova) & 0xFFFF)
 #define spage_phys(pent) (*(pent) & SPAGE_MASK)
-#define spage_offs(iova) ((iova) & 0xFFF)
+#define spage_offs(iova) ((sysmmu_iova_t)(iova) & 0xFFF)
 
-#define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
-#define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
+#define lv1ent_offset(iova) ((sysmmu_iova_t)(iova) >> SECT_ORDER)
+#define lv2ent_offset(iova) (((sysmmu_iova_t)(iova) & 0xFF000) >> SPAGE_ORDER)
 
 #define NUM_LV1ENTRIES 4096
-#define NUM_LV2ENTRIES 256
+#define NUM_LV2ENTRIES (SECT_SIZE / SPAGE_SIZE)
 
-#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(long))
+#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(sysmmu_pte_t))
 
 #define SPAGES_PER_LPAGE (LPAGE_SIZE / SPAGE_SIZE)
 
@@ -133,16 +133,19 @@
 		&((struct exynos_iommu_owner *)dev->archdata.iommu)->mmu_list, \
 		entry)
 
+typedef u32 sysmmu_iova_t;
+typedef u32 sysmmu_pte_t;
+
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
 
@@ -194,7 +197,7 @@ struct exynos_iommu_owner {
 
 struct exynos_iommu_domain {
 	struct list_head clients; /* list of sysmmu_drvdata.node */
-	unsigned long *pgtable; /* lv1 page table, 16KB */
+	sysmmu_pte_t *pgtable; /* lv1 page table, 16KB */
 	short *lv2entcnt; /* free lv2 entry counter for each section */
 	spinlock_t lock; /* lock for this structure */
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
@@ -288,7 +291,7 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 }
 
 static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-				unsigned long iova, unsigned int num_inv)
+				sysmmu_iova_t iova, unsigned int num_inv)
 {
 	unsigned int i;
 	for (i = 0; i < num_inv; i++) {
@@ -299,7 +302,7 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 }
 
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
-				       unsigned long pgd)
+				       phys_addr_t pgd)
 {
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
@@ -308,22 +311,22 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 
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
 
@@ -332,7 +335,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
 	enum exynos_sysmmu_inttype itype;
-	unsigned long addr = -1;
+	sysmmu_iova_t addr = -1;
 	int ret = -ENOSYS;
 
 	WARN_ON(!is_sysmmu_active(data));
@@ -355,7 +358,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 			__func__);
 		BUG();
 	} else {
-		unsigned long base =
+		unsigned int base =
 				__raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
 		show_fault_information(dev_name(data->sysmmu),
 					itype, base, addr);
@@ -418,7 +421,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	unsigned long cfg = CFG_LRU | CFG_QOS(15);
+	unsigned int cfg = CFG_LRU | CFG_QOS(15);
 	int maj, min = 0;
 
 	maj = __sysmmu_version(data, &min);
@@ -454,7 +457,7 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 }
 
 static int __sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+			phys_addr_t pgtable, struct iommu_domain *domain)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -483,12 +486,12 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
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
@@ -522,7 +525,7 @@ static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
 	return ret;
 }
 
-int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
+int exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable)
 {
 	BUG_ON(!memblock_is_memory(pgtable));
 
@@ -553,7 +556,7 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 					size_t size)
 {
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
@@ -592,7 +595,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 			__master_clk_disable(data);
 		} else {
 			dev_dbg(dev,
-				"disabled. Skipping TLB invalidation @ %#lx\n",
+				"disabled. Skipping TLB invalidation @ %#x\n",
 				iova);
 		}
 
@@ -864,7 +867,7 @@ static int exynos_iommu_domain_init(struct iommu_domain *domain)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pgtable = (unsigned long *)__get_free_pages(
+	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(
 						GFP_KERNEL | __GFP_ZERO, 2);
 	if (!priv->pgtable)
 		goto err_pgtable;
@@ -987,19 +990,19 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 	}
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
 
@@ -1012,18 +1015,18 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
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
@@ -1039,7 +1042,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 	return 0;
 }
 
-static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
+static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
@@ -1071,11 +1074,12 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
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
 
@@ -1089,7 +1093,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 		ret = lv1set_section(entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
-		unsigned long *pent;
+		sysmmu_pte_t *pent;
 
 		pent = alloc_lv2entry(entry, iova,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
@@ -1102,7 +1106,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	}
 
 	if (ret)
-		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
+		pr_debug("%s: Failed to map iova %#x/%#zx bytes\n",
 							__func__, iova, size);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
@@ -1111,13 +1115,14 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
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
 
@@ -1184,7 +1189,7 @@ err:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	WARN(1,
-	"%s: Failed due to size(%#x) @ %#08lx is smaller than page size %#x\n",
+	"%s: Failed due to size(%#zx) @ %#x is smaller than page size %#zx\n",
 	__func__, size, iova, err_pgsize);
 
 	return 0;
@@ -1194,7 +1199,7 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 					  dma_addr_t iova)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	unsigned long *entry;
+	sysmmu_pte_t *entry;
 	unsigned long flags;
 	phys_addr_t phys = 0;
 
-- 
1.7.9.5

