Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaCNFFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:05:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56307 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaCNFFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:05:30 -0400
X-AuditID: cbfee68e-b7f566d000002344-dd-53228e183695
Date: Fri, 14 Mar 2014 14:05:28 +0900
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
Subject: [PATCH v11 09/27] iommu/exynos: remove dbgname from drvdata of a
 System MMU
Message-id: <20140314140528.48f5eede3def262bb16d38ce@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI13JPqVgg2spFnfunmO1mH8ESLw6
	8oPJYsF+a4vO2RvYLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2iymLDrNaHH7Tzmpx8k8v
	o8X6Ga9ZLGbeWsPiwO/x5OA8Jo/ZDRdZPP4d7mfyuHNtD5vH5iX1HpNvLGf06NuyitHj8yY5
	jytHzzAFcEZx2aSk5mSWpRbp2yVwZew4VFxwUK5izvRfzA2MjZJdjJwcEgImEssOfWODsMUk
	LtxbD2RzcQgJLGOUWHjpFztM0bvZx5ggEtMZJeaua2aEcCYzSVyfsw6sikVAVWLR30/MIDab
	gJbE6rnHwYpEBNqYJL42HmIBcZgF5jJLfPw2B2yhsECYxLdZPWAdvAKOEr9vHGeC2GchcaGp
	gx0iLijxY/I9FhCbGWjq5m1NrBC2vMTmNW+ZIeo7OSSOXS2EuEJA4ttkkGUcQHFZiU0HoEok
	JQ6uuMEygVFkFpKps5BMnYVk6gJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIbHbt4Px
	5gHrQ4zJQCsnMkuJJucDYz+vJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKAeNsyscjst+Ofvi44sAZfw57mUrxv8d33We/G3XCqnFew24V98aKE5El
	zJLq+vdKywVffzOKdvoeu+h0NDv3R3e2c27mc66+3r5aNsP4q2rB8Tlrdifq5k79UNTFncK0
	/VnPwTKupUIZ4VFTGnMl9/DueWGlkb/oNUdT/84a1r53cQetfv57d06JpTgj0VCLuag4EQBL
	m8C58wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQV2JPqVggwdvLCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYseNQccFBuYo5
	038xNzA2SnYxcnJICJhIvJt9jAnCFpO4cG89WxcjF4eQwHRGibnrmhkhnMlMEtfnrGMHqWIR
	UJVY9PcTM4jNJqAlsXrucbAiEYE2JomvjYdYQBxmgbnMEh+/zWEDqRIWCJP4NqsHrINXwFHi
	943jUPssJC40dbBDxAUlfky+xwJiMwNN3bytiRXClpfYvOYt8wRGvllIymYhKZuFpGwBI/Mq
	RtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODk8ExqB+PKBotDjAIcjEo8vA6HFYOFWBPLiitz
	DzFKcDArifBWRSgFC/GmJFZWpRblxxeV5qQWH2JMBvp7IrOUaHI+MHHllcQbGpuYGVkamVkY
	mZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjfU1wlLgby/w/Ap6CL31Uoy/5PL/t
	v+KSUZE091PrS1vfRJpNPfxbeMMXywTNMvU4Hs7ySx8Xtzu+/ap+58S1nXITXEovtXlqtLse
	YjET6uqVNjXO/mkkOPXnrpSt5cyTzcr+JzsoM4kcn2zxuqopqbWuffbrB19f3lbdGF4eFB91
	022N0BwlluKMREMt5qLiRAA46VO3UgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dbgname member from sysmmu_drvdata structure.
Kernel message for debugging already has the name of a single
System MMU node.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index a4499b2..36e6b73 100644
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
-			"(%s) Already enabled with page table %#lx\n",
-			data->dbgname, data->pgtable);
+		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
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
@@ -562,7 +556,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+	dev_dbg(dev, "Initialized\n");
 	return 0;
 err_irq:
 	free_irq(platform_get_irq(pdev, 0), data);
-- 
1.7.9.5

