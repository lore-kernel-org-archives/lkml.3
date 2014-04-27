Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaD0Hko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41730 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaD0HjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:14 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-35-535cb4206f2b
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
Subject: [PATCH v12 09/31] iommu/exynos: remove dbgname from drvdata of a
 System MMU
Date: Sun, 27 Apr 2014 13:07:41 +0530
Message-id: <1398584283-22846-10-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRldhS0ywQd9cQ4s7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Bbfd31ht+hdcJXNYtPja6wWl3fNYbOYcX4fk8WFFRvZLf71HmS0mLLo
	MKvF4TftrBYn//QyWrRc72WyWD/jNYvFql1/GC1m3lrD4iDs8eTgPCaP2Q0XWTz+He5n8tg5
	6y67x51re9g8Ni+p95h8YzmjR9+WVYwenzfJeVw5eoYpgCuKyyYlNSezLLVI3y6BK6NtxmnW
	gm0GFUuv32dvYDyl3sXIySEhYCLx+/tTNghbTOLCvfVANheHkMBSRonOA8eYYIq6/txigUgs
	YpTYv3wHI0hCSGACk8TKYzogNpuAocT2e1dYQYpEBFYzSvRdPMMO4jAL3GWSmLPqHViHsECY
	xM6DV9hBbBYBVYlby5Yyg9i8Ah4SV48dBarhAFqnIDFnkg1ImBMo/OTOHhaIZe4Sb099AVsg
	ITCTQ2LntxnMEHMEJL5NPsQC0SsrsekAM8TVkhIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5x
	Ym5xaV66XnJ+7iZGYDye/vesfwfj3QPWhxiTgcZNZJYSTc4HxnNeSbyhsZmRhamJqbGRuaUZ
	acJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUS7/P/tO6f5PUxrTsU1Nefzsj
	tYnXI/tuWqzrOZ6TmZPVJrHcmfWn9nJ9p1Xs5ftd1Q2rJgQt1imY94mj7qngHLYjZ07o/ii4
	ErDoyOs9vctd103VD/0byJtgsim0+uWRea41vcwNNfrsItNVvBee5mf6a31x2xLbf693SN68
	t6R17Zafh6V0lFiKMxINtZiLihMB6HTOA90CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV2FLTHBBl29ahZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFdUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBrSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCGsaMthmnWQu2GVQsvX6fvYHxlHoXIyeHhICJRNefWywQtpjEhXvr
	2boYuTiEBBYxSuxfvoMRJCEkMIFJYuUxHRCbTcBQYvu9K6wgRSICqxkl+i6eYQdxmAXuMknM
	WfUOrENYIExi58Er7CA2i4CqxK1lS5lBbF4BD4mrx44C1XAArVOQmDPJBiTMCRR+cmcPC8Qy
	d4m3p76wTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjONqfSe1gXNlgcYhRgINR
	iYd3gWRMsBBrYllxZe4hRgkOZiURXs7pQCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OByai
	vJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgPHygqrLox1op
	QZaPgit9pObOWvPK93jXg9j/Z2LvbUmdcrpH413Jv4g5m08xXXGN4mCQ0rRZN/ES3/lLwQpN
	AtLBNUbmc5bPObDB3uXGK8usZfc3i0lujDO8eexRks632LDpfP2/uh9J+SYo7nDR2fjJSORd
	7Jqd19ommyufPTHf79wyxesitUosxRmJhlrMRcWJAFW7JNY6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch removes dbgname member from sysmmu_drvdata structure.
Kernel message for debugging already has the name of a single
System MMU node. It also removes some compilation warnings.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   54 +++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 29 deletions(-)
 mode change 100644 => 100755 drivers/iommu/exynos-iommu.c

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
old mode 100644
new mode 100755
index a15216f..1af2d23
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -169,7 +169,6 @@ struct sysmmu_drvdata {
 	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
-	char *dbgname;
 	void __iomem *sfrbase;
 	struct clk *clk;
 	int activations;
@@ -320,8 +319,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
-				data->dbgname, sysmmu_fault_name[itype]);
+		dev_dbg(data->sysmmu, "%s is not handled.\n",
+				sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
@@ -353,10 +352,10 @@ finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
-		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled\n");
 	else
-		dev_dbg(data->sysmmu, "(%s) %d times left to be disabled\n",
-					data->dbgname, data->activations);
+		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
+					data->activations);
 
 	return disabled;
 }
@@ -383,7 +382,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			ret = 1;
 		}
 
-		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Already enabled\n");
 		goto finish;
 	}
 
@@ -398,7 +397,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	data->domain = domain;
 
-	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
+	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
@@ -414,16 +413,15 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 
 	ret = pm_runtime_get_sync(data->sysmmu);
 	if (ret < 0) {
-		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Failed to enable\n");
 		return ret;
 	}
 
 	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
 	if (WARN_ON(ret < 0)) {
 		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu,
-			"(%s) Already enabled with page table %#lx\n",
-			data->dbgname, data->pgtable);
+		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
+			data->pgtable);
 	} else {
 		data->dev = dev;
 	}
@@ -473,9 +471,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -494,9 +490,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -559,7 +553,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+	dev_dbg(dev, "Initialized\n");
 	return 0;
 err_irq:
 	free_irq(platform_get_irq(pdev, 0), data);
@@ -659,6 +653,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	struct exynos_iommu_domain *priv = domain->priv;
+	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	int ret;
 
@@ -682,15 +677,15 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (ret < 0) {
-		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
-				__func__, __pa(priv->pgtable));
+		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
+					__func__, &pagetable);
 		pm_runtime_put(data->sysmmu);
 	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
+		dev_dbg(dev, "%s: IOMMU with pgtable %pa already attached\n",
+					__func__, &pagetable);
 	} else {
-		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
-					__func__, __pa(priv->pgtable));
+		dev_dbg(dev, "%s: Attached new IOMMU with pgtable %pa\n",
+					__func__, &pagetable);
 	}
 
 	return ret;
@@ -702,6 +697,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	struct exynos_iommu_domain *priv = domain->priv;
 	struct list_head *pos;
+	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	bool found = false;
 
@@ -718,13 +714,13 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
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
-- 
1.7.9.5

