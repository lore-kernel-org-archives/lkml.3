Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966Ab3HHJkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:40:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54970 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896Ab3HHJkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:40:49 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-a8-520367a0fa3d
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
Subject: [PATCH v9 13/16] iommu/exynos: turn on useful configuration options
Date: Thu, 08 Aug 2013 18:40:47 +0900
Message-id: <003101ce941b$5c9c0640$15d412c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF7PSq3mEwrMLTEy5i7W4euf0zw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zA90F6cxBBnfOcFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4o7hsUlJzMstSi/TtErgymlbZFHwXqrh60beBsZG/i5GTQ0LAROJi91U2CFtM4sK99UA2
	F4eQwDJGiQvtO9lgiq7s3MYEkZjOKLF9+xsWCOcvo8TNiduYQarYBLQkVs89zgiSEBH4zShx
	69kcVhCHWeA/k8TW203sXYwcHMICPhJHL4iDNLAIqEpcf/CXHcTmFbCUeHDhECOELSjxY/I9
	FhCbGWjo+p3HmSBseYnNa94yQ5ykILHj7GuwehEBPYnvT3ewQdSISOx78Y4RomYhh8T11x4Q
	uwQkvk0+xAJygoSArMSmA1BjJCUOrrjBMoFRbBaSzbOQbJ6FZPMsJBsWMLKsYhRNLUguKE5K
	LzLRK07MLS7NS9dLzs/dxAiJ+wk7GO8dsD7EmAy0fiKzlGhyPjBt5JXEGxqbGVmYmpgaG5lb
	mpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMelRikpcSgtzZYCW1fdQEfOJ
	p40SHucu0xPa0H2vw3PVm31pyZxsia4zOTdfdnWMfJnNOls3/3Ex/07z3QJS995cznWfMVX/
	eiPfuw4V0xlbNzqHf7d6sGhiVp3ZPlnfVK4PHhffKvrqhJ7WEpY9Y3bnNbcgG9Pfi+lH232/
	X5XRvFD7n8lUiaU4I9FQi7moOBEAXkvYUBEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQd0F6cxBBmefsVjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZjStsin4LlRx9aJvA2Mj
	fxcjJ4eEgInElZ3bmCBsMYkL99azdTFycQgJTGeU2L79DQuE85dR4ubEbcwgVWwCWhKr5x5n
	BEmICPxmlLj1bA4riMMs8J9JYuvtJvYuRg4OYQEfiaMXxEEaWARUJa4/+MsOYvMKWEo8uHCI
	EcIWlPgx+R4LiM0MNHT9zuNMELa8xOY1b5khTlKQ2HH2NVi9iICexPenO9ggakQk9r14xziB
	UWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp5VnUjsYVzZY
	HGIU4GBU4uHtCGAKEmJNLCuuzD3EKMHBrCTCe7EYKMSbklhZlVqUH19UmpNafIgxGejTicxS
	osn5wJSXVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MF8MK
	1+nON2HV3azyIFenoKg56tJO7S0R58pehYT+qms5/7Bz+7W6AyXGmVmbpqnH/Tb0Ylp+TfI6
	jznHr7MfW+Y2cU34u9Ere8vsiINRhx68cz26j2/eysrAeXOf38jeYKQW8dZs1fXVc223fX9R
	cz5QZPPiScoWzLMD5kRXHjlhcMA9JquGS4mlOCPRUIu5qDgRAFZboNFvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This turns on ACGEN and SYSSEL.

ACGEN is architectural clock gating that gates clocks by System MMU
itself if it is not active. Note that ACGEN is different from clock
gating by the CPU. ACGEN just gates clocks to the internal logic of
System MMU while clock gating by the CPU gates clocks to the System
MMU.

SYSSEL selects System MMU version in some Exynos SoCs. Some Exynos
SoCs have an option to select System MMU versions exclusively because
the SoCs adopts new System MMU version experimentally.

This also always selects LRU as TLB replacement policy. Selecting TLB
replacement policy is deprecated from System MMU 3.2. TLB in System
MMU 3.3 has single TLB replacement policy, LRU. The bit of MMU_CFG
selecting TLB replacement policy is remained as reserved.

QoS value of page table walking is set to 15 (highst value). System
MMU 3.3 can inherit QoS value of page table walking from its master
H/W's transaction. This new feature is enabled by default and QoS
value written to MMU_CFG is ignored.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 8240f7f..9e64483 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -82,6 +82,11 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_LRU		0x1
+#define CFG_QOS(n)	((n & 0xF) << 7)
+#define CFG_MASK	0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
+#define CFG_ACGEN	(1 << 24) /* System MMU 3.3 only */
+#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
 #define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
 
 #define REG_MMU_CTRL		0x000
@@ -449,12 +454,21 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data, int idx)
 {
-	unsigned long cfg = 0;
+	unsigned long cfg = CFG_LRU | CFG_QOS(15);
 	int maj, min = 0;
 
 	maj = __sysmmu_version(data, idx, &min);
-	if ((maj == 3) && (min > 1))
-		cfg |= CFG_FLPDCACHE;
+	if (maj == 3) {
+		if (min >= 2) {
+			cfg |= CFG_FLPDCACHE;
+			if (min == 3) {
+				cfg |= CFG_ACGEN;
+				cfg &= ~CFG_LRU;
+			} else {
+				cfg |= CFG_SYSSEL;
+			}
+		}
+	}
 
 	__raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
 }
-- 
1.7.2.5


