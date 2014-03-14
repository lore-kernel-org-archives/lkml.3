Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaCNFPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:15:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24431 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbaCNFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:15:07 -0400
X-AuditID: cbfee690-b7f266d00000287c-22-53229038d9e2
Date: Fri, 14 Mar 2014 14:14:31 +0900
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
Subject: [PATCH v11 27/27] iommu/exynos: enhanced error messages
Message-id: <20140314141431.320b055a618203746b1e3075@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zI12LCUrBBq/2i1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJWxd8FtxoJFYhUXZj5hbmA8LdjFyMkhIWAicX72ZnYI
	W0ziwr31bF2MXBxCAssYJRZtPM7YxcgBVvRkYSREfDqjxJtrq6GKJjNJfJ1wC6yIRUBV4l1P
	DsggNgEtidVzQXq5OEQE2oBqGg+xgDjMAnOZJT5+m8MGUiUs4CDR1X2GFcTmFXCUWPCrmwXi
	DAuJC00d7BBxQYkfk++BxZmBpm7e1sQKYctLbF7zlhlkqIRAJ4fEhCWXGEESLAICEt8mg2wD
	OVtWYtMBZoiZkhIHV9xgmcAoMgvJ2FlIxs5CMnYBI/MqRtHUguSC4qT0IhO94sTc4tK8dL3k
	/NxNjJDonbCD8d4B60OMyUArJzJLiSbnA6M/ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYOVuXTeoO9cl7dvjoE4HFV3/ZvEnSMVjMH5t0daek
	tV5Va4+okdX86GP+i/LX1LAsmJl4KVhfc7Km29bUuOUtZZOmXQ46n37Xsfp+Yt5uC6svr/J9
	zn113HlXLJmhdplwpp4SQ/TkzUfeTF9n7HezbUtLWcrvrjdHu+xfLJuzYGr1ua3aFr79SizF
	GYmGWsxFxYkAUdGtwfQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV2LCUrBBtMvCFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY++C24wFi8Qq
	Lsx8wtzAeFqwi5GDQ0LAROLJwsguRk4gU0ziwr31bF2MXBxCAtMZJd5cWw3lTGaS+DrhFiNI
	A4uAqsS7nhyQBjYBLYnVc48zgtSICLQB1TQeYgFxmAXmMkt8/DaHDaRKWMBBoqv7DCuIzSvg
	KLHgVzcLxDoLiQtNHewQcUGJH5PvgcWZgaZu3tbECmHLS2xe85Z5AiPfLCRls5CUzUJStoCR
	eRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcGp4Jr2DcVWDxSFGAQ5GJR7eGUcVg4VYE8uK
	K3MPMUpwMCuJ8FZFKAUL8aYkVlalFuXHF5XmpBYfYkwGensis5Rocj4wbeWVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OPrEKKZGXKn61HEpJkjva0XH6o
	3v+f+xS7ja1J8IowMetE3tQ72xO9+xOO5rIu5nA1O3jJT6Tl1eNdmeZTRfYLH+jaenuJX5ja
	BaN7Ms3fcpI6gn3Uq+ImNdWZ9yUXVFlN2GzalCNg1/6qqm3XKT7FTfWsClZZ67NqEl72/vxe
	ydvB0ZqpxFKckWioxVxUnAgAPmYgAlEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some redundant error message is removed and some error messages
are changed to error level from debug level.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4888383..b7f7731 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1012,7 +1012,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
 					__func__, &pgtable);
 	} else {
-		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
+		dev_err(dev, "%s: No IOMMU is attached\n", __func__);
 	}
 }
 
@@ -1112,10 +1112,8 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
-		if (!lv2ent_fault(pent)) {
-			WARN(1, "Trying mapping on 4KiB where mapping exists");
+		if (WARN_ON(!lv2ent_fault(pent)))
 			return -EADDRINUSE;
-		}
 
 		*pent = mk_lv2ent_spage(paddr);
 		pgtable_flush(pent, pent + 1);
@@ -1123,9 +1121,7 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 	} else { /* size == LPAGE_SIZE */
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
-			if (!lv2ent_fault(pent)) {
-				WARN(1,
-				"Trying mapping on 64KiB where mapping exists");
+			if (WARN_ON(!lv2ent_fault(pent))) {
 				if (i > 0)
 					memset(pent - i, 0, sizeof(*pent) * i);
 				return -EADDRINUSE;
@@ -1198,8 +1194,8 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 	}
 
 	if (ret)
-		pr_debug("%s: Failed to map iova %#x/%#zx bytes\n",
-							__func__, iova, size);
+		pr_err("%s: Failed(%d) to map %#zx bytes @ %#x\n",
+			__func__, ret, size, iova);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -1236,7 +1232,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		if (size < SECT_SIZE) {
+		if (WARN_ON(size < SECT_SIZE)) {
 			err_pgsize = SECT_SIZE;
 			goto err;
 		}
@@ -1271,7 +1267,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	if (size < LPAGE_SIZE) {
+	if (WARN_ON(size < LPAGE_SIZE)) {
 		err_pgsize = LPAGE_SIZE;
 		goto err;
 	}
@@ -1290,9 +1286,8 @@ done:
 err:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
-	WARN(1,
-	"%s: Failed due to size(%#zx) @ %#x is smaller than page size %#zx\n",
-	__func__, size, iova, err_pgsize);
+	pr_err("%s: Failed: size(%#zx) @ %#x is smaller than page size %#zx\n",
+		__func__, size, iova, err_pgsize);
 
 	return 0;
 }
-- 
1.7.9.5

