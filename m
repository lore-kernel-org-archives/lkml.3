Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaELGU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:20:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35494 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaELGQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:44 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-8b-5370674a5b37
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
Subject: [PATCH v13 08/19] iommu/exynos: remove dbgname from drvdata of a
 System MMU
Date: Mon, 12 May 2014 11:44:53 +0530
Message-id: <1399875304-19948-9-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkStcrvSDY4MwJTYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6Mp08OMhdcka9o2zqdqYGxUaqLkYNDQsBEYtef+i5GTiBTTOLCvfVsXYxc
	HEICSxklfvzbwAqRMJFYf+4yE0RiEaPEntdrGCGcCUwS21d3s4BUsQkYSmy/d4UVJCEisJpR
	ou/iGXYQh1lgNrPEkUeLGUGqhAXCJJ50XwfrYBFQlfjX2ga2g1fAXWL1y7OsEDcpSMyZZAMS
	5hTwkPi8egobiC0EVHLs1VWwBRICWzgk9qybxAQxR0Di2+RDLBC9shKbDjBDnC0pcXDFDZYJ
	jMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgRG6+l/z/p3MN49YH2IMRlo3ERmKdHk
	fGC055XEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	Rs/nl9o6fj1OvsuvfLuM8Vze0zuSr94b1E8xXlPcI9tw9rRKX/k2Zvcyu3+nAl44lkxpcfpV
	G7a8qXNng/3/F4cnuT+pz+qvCBG3yYp2dZM8tyL39qWD0pqnGfdc5jnM8W7b/5989dvPTF5l
	7511NWD6vqW8WwrVGOx/hBdPSE3ZfPiKrdBcJyWW4oxEQy3mouJEAFY1xlXsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV2v9IJggxWr5S3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjx9cpC54Ip8RdvW6UwNjI1SXYyc
	HBICJhLrz11mgrDFJC7cW8/WxcjFISSwiFFiz+s1jBDOBCaJ7au7WUCq2AQMJbbfu8IKkhAR
	WM0o0XfxDDuIwywwm1niyKPFjCBVwgJhEk+6r4N1sAioSvxrbWMFsXkF3CVWvzwLZHMA7VOQ
	mDPJBiTMKeAh8Xn1FDYQWwio5Nirq6wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAhOBs+kdjCubLA4xCjAwajEw/uBoSBYiDWxrLgy9xCjBAezkgjvR3+gEG9KYmVValF+fFFp
	TmrxIcZkoKMmMkuJJucDE1VeSbyhsYm5qbGppYmFiZklacJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTDyTVrY6KJgwfAmo3lWx5W5h/4ETOI9+JLz85PdT9ZadBnvqvq2SulL4+VPSzrv
	3bm48JBtZYG9ZmnCfH7pylM2nE0yN3SyMnmmsOTxvey6ytMk97DE6nFQ96SNZc5/GyekqLx+
	GLf//GabTafkC9SFJPd9an3Se401JmOC3/UXJY2H1cQOe3xXYinOSDTUYi4qTgQAgTylekoD	AAA=
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
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index ef771a2..be7a7b9 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -170,7 +170,6 @@ struct sysmmu_drvdata {
 	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
-	char *dbgname;
 	void __iomem *sfrbase;
 	struct clk *clk;
 	int activations;
@@ -321,8 +320,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
-				data->dbgname, sysmmu_fault_name[itype]);
+		dev_dbg(data->sysmmu, "%s is not handled.\n",
+				sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
@@ -354,10 +353,10 @@ finish:
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
@@ -384,7 +383,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			ret = 1;
 		}
 
-		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Already enabled\n");
 		goto finish;
 	}
 
@@ -399,7 +398,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	data->domain = domain;
 
-	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
+	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
@@ -415,16 +414,15 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 
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
-			"(%s) Already enabled with page table %#x\n",
-			data->dbgname, data->pgtable);
+		dev_err(data->sysmmu, "Already enabled with page table %#x\n",
+			data->pgtable);
 	} else {
 		data->dev = dev;
 	}
@@ -474,9 +472,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -495,9 +491,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -560,7 +554,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+	dev_dbg(dev, "Initialized\n");
 	return 0;
 err_irq:
 	free_irq(platform_get_irq(pdev, 0), data);
-- 
1.7.9.5

