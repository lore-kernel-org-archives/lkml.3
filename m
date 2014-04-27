Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaD0Huh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:50:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57818 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaD0HkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:02 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-2a-535cb44d5721
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
Subject: [PATCH v12 25/31] iommu/exynos: enhanced error messages
Date: Sun, 27 Apr 2014 13:07:57 +0530
Message-id: <1398584283-22846-26-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRtd3S0ywwfY5chZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bhNZsY
	CyaKV+y9dpO9gXGTUBcjJ4eEgInEhVnz2CFsMYkL99azdTFycQgJLGWUaD+wmAmmaNKuO4wQ
	iUWMEg9f7mWCcCYwSXy9/AasnU3AUGL7vSusIAkRgdWMEn0Xz7CDOMwCd5kk5qx6xwhSJSzg
	IPH88Aagdg4OFgFViT3XPUHCvAIeEhvn/GUDCUsIKEjMmWQDEuYECj+5s4cFxBYScJd4e+oL
	2HwJgbkcEgdnHGcFSbAICEh8m3yIBaJXVmLTAWaIqyUlDq64wTKBUXgBI8MqRtHUguSC4qT0
	IkO94sTc4tK8dL3k/NxNjMB4PP3vWe8OxtsHrA8xJgONm8gsJZqcD4znvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg5D2W41vN/qBs/79OUYny
	OStu3/i4pXj3Y8Guj0t4u2rerFmbfPzbWUbNo/u22XcEfqmJ6t296dsCqaILZX++N3FqzX5Z
	7njz69ypNz9a3Wkqtmac+PjqyjKBLUp/uqSZVef8mPFjZ2oGo0m6rdn9rOI4MXv7HW2fb7yV
	zEv89iOs38C8pXmxjBJLcUaioRZzUXEiALYoi2fdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3fLTHBBlMnCFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzDq/ZxFgwUbxi77Wb7A2Mm4S6GDk5JARMJCbtusMIYYtJXLi3
	nq2LkYtDSGARo8TDl3uZIJwJTBJfL79hB6liEzCU2H7vCitIQkRgNaNE38Uz7CAOs8BdJok5
	q96BzRIWcJB4fngDUDsHB4uAqsSe654gYV4BD4mNc/6ygYQlBBQk5kyyAQlzAoWf3NnDAmIL
	CbhLvD31hXUCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR/kxqB+PKBotDjAIc
	jEo8vAskY4KFWBPLiitzDzFKcDArifByTgcK8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4w
	EeWVxBsam5ibGptamliYmFmSJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Mu+4KT/y4F
	+7bftn3tK+2z0ePWjR79ujMFu5t3fTnw2oT3mG/F1+z1e3bdzPog/W9x+XEeuyMlh+9HpAmv
	utEQv9RIaH/i4WjFimnzmrZsmcBzc3qf9fOHj4+9rYpoTbHMCze3jWl16n5z9S3H327usFc/
	6pvDPlW6uZ1x/bN60rMPV+cw/HBVYinOSDTUYi4qTgQAYJZebToDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Some redundant error message is removed and some error messages
are changed to error level from debug level.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 35b055e..4009eb2 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1018,7 +1018,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
 					__func__, &pagetable);
 	else
-		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
+		dev_err(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static sysmmu_pte_t *alloc_lv2entry(struct exynos_iommu_domain *priv,
@@ -1117,10 +1117,8 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
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
@@ -1128,9 +1126,7 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
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
@@ -1203,8 +1199,8 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 	}
 
 	if (ret)
-		pr_debug("%s: Failed to map iova %#x/%#zx bytes\n",
-							__func__, iova, size);
+		pr_err("%s: Failed(%d) to map %#zx bytes @ %#x\n",
+			__func__, ret, size, iova);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -1241,7 +1237,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		if (size < SECT_SIZE) {
+		if (WARN_ON(size < SECT_SIZE)) {
 			err_pgsize = SECT_SIZE;
 			goto err;
 		}
@@ -1276,7 +1272,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	if (size < LPAGE_SIZE) {
+	if (WARN_ON(size < LPAGE_SIZE)) {
 		err_pgsize = LPAGE_SIZE;
 		goto err;
 	}
@@ -1295,9 +1291,8 @@ done:
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

