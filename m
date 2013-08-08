Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab3HHJkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:40:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54848 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab3HHJkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:40:13 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-05-5203677c6fd5
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 11/16] iommu/exynos: remove calls to Runtime PM API functions
Date: Thu, 08 Aug 2013 18:40:12 +0900
Message-id: <002f01ce941b$47796910$d66c3b30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF6crUyZZ3JhpTr6Ox4P2C4gD8g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zfd2adOYggxNbtCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUVw2Kak5mWWpRfp2CVwZJ76rFKwUqTi/YC57A+MFgS5GTg4JAROJtv7jjBC2mMSFe+vZ
	uhi5OIQEljFKTF38jbmLkQOsaP/KcIj4IkaJiftPsIE0CAn8ZZTYNS8OxGYT0JJYPRdkEBeH
	iMBvRolbz+awgjjMAv+ZJLbebmIHqRIWCJB4OP8UmM0ioCpx6Ng0FhCbV8BS4sKStYwQtqDE
	j8n3wOLMQFPX7zzOBGHLS2xe85YZ4lQFiR1nXzOCXCcioCexbZc9RImIxL4X78COkBBYyCGx
	9PZ2ZohdAhLfJh9igfhGVmLTAagxkhIHV9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQX
	FCelF5noFSfmFpfmpesl5+duYoTE/YQdjPcOWB9iTAZaP5FZSjQ5H5g28kriDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyJpTovjw4lXFJs0NTpGK
	SpvOFvOtvun2L8PFb1b7r6mbPRzeJZ1rVn30/9XWyX1G/9WPzr3N/HmKKdfi2ZwVHdN2yHmx
	XvvWLvbObs8/gz/9Kf4vbrJ7yvMvvn8tPkPViSl6iaPKnI9duRJnZyz5dH213tlL8ncadW89
	m7T7dvY5/xQ599M3+JRYijMSDbWYi4oTAflix+kRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jAd2adOYgg0MvVC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	xysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM058VylYKVJxfsFc9gbG
	CwJdjBwcEgImEvtXhncxcgKZYhIX7q1n62Lk4hASWMQoMXH/CTaQhJDAX0aJXfPiQGw2AS2J
	1XOPM4IUiQj8ZpS49WwOK4jDLPCfSWLr7SZ2kCphgQCJh/NPgdksAqoSh45NYwGxeQUsJS4s
	WcsIYQtK/Jh8DyzODDR1/c7jTBC2vMTmNW+ZIU5SkNhx9jUjyKUiAnoS23bZQ5SISOx78Y5x
	AqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4qz6R2MK5s
	sDjEKMDBqMTD2xHAFCTEmlhWXJl7iFGCg1lJhPdiMVCINyWxsiq1KD++qDQntfgQYzLQoxOZ
	pUST84EJL68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGFsZ
	+fadmnd5dYFm/5lWzkD9PdW8QbdbvndV2BupHfRZVzo9KcD8H3uMZMXpmSzbdFrrv8ouXKqU
	taq6qe5m1MqpE1cun/bK8ntH/YMr+owdst2z1y35c0FISGdjkt7xSv6OrfK7nikt539cy/40
	+Qt3ScWKpmczO/cIddxqeLomRNl5onJ4gBJLcUaioRZzUXEiAHwZNMNuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime power management by exynos-iommu driver independently from
master H/W's runtime pm is not useful for power saving since attaching
master H/W in probing time turns on its local power endlessly.
Thus this removes runtime pm API calls.
Runtime PM support is added in the following commits to exynos-iommu
driver.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e8f3e82..686e3c8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -491,15 +491,8 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 
 	BUG_ON(!memblock_is_memory(pgtable));
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0) {
-		dev_dbg(data->sysmmu, "Failed to enable\n");
-		return ret;
-	}
-
 	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
 	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
 		dev_err(data->sysmmu,
 			"Already enabled with page table %#lx\n",
 			data->pgtable);
@@ -516,7 +509,6 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	bool disabled;
 
 	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
 
 	return disabled;
 }
@@ -626,8 +618,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_runtime_enable(dev);
-
 	data->sysmmu = dev;
 	data->clk = devm_clk_get(dev, "sysmmu");
 	if (IS_ERR(data->clk)) {
@@ -759,12 +749,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	unsigned long flags;
 	int ret;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0)
-		return ret;
-
-	ret = 0;
-
 	spin_lock_irqsave(&priv->lock, flags);
 
 	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
@@ -781,7 +765,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		pm_runtime_put(data->sysmmu);
 	} else if (ret > 0) {
 		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
 					__func__, __pa(priv->pgtable));
@@ -826,9 +809,6 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
 finish:
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (found)
-		pm_runtime_put(data->sysmmu);
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
-- 
1.7.2.5


