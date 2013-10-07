Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3JGB6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:58:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13905 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3JGB6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:58:02 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-c5-5252152847a4
Date: Mon, 07 Oct 2013 10:58:00 +0900
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 16/20] iommu/exynos: turn on useful configuration options
Message-id: <20131007105800.ab2c86aa52528614188e0719@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY10N0aAggz8fDSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlTGv/yBLwUOhiu3zDzI1MH7g62Lk5JAQMJHo
	3zSRFcIWk7hwbz1bFyMXh5DAMkaJwxfPs8MU7TzwEyoxnVFiwrNN7BDOJCaJCccOATkcHCwC
	qhIfrsSANLAJaEmsnnucEaRGRKCNSeJr4yEWEIdZ4DSzxKrdK5hBqoQFfCW2vXzLCGLzCjhK
	HH87BeoOC4kLTR3sEHFBiR+T77GA2MxAUzdva2KFsOUlNq95ywwyVEJgIofElqWrwBpYBAQk
	vk0G2cYBlJCV2HSAGWKmpMTBFTdYJjCKzEIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3
	uDQvXS85P3cTIySS+3cw3j1gfYgxGWjlRGYp0eR8YCLIK4k3NDYzsjA1MTU2Mrc0I01YSZxX
	rcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj2c+mCiuGLCeh3UVPjl41zHcU2bxb6Jpv
	H+dXzdW5lv4fVwgvdNRX3HmXfUZGT4rIUYmfj1blTTZf4rpWx371q9ZdBb2+Octu1my8ExGy
	hFlwoc+NppjSA6frWtNNWpIvW83j2sXy2EFxalhJzhkeP5byTe4s33xm68bfjpUVuSKhf0xm
	wSklluKMREMt5qLiRADOCCoJ+gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQV0N0aAgg1VzdSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjXv9B
	loKHQhXb5x9kamD8wNfFyMkhIWAisfPATzYIW0ziwr31QDYXh5DAdEaJCc82sUM4k5gkJhw7
	BORwcLAIqEp8uBID0sAmoCWxeu5xRpAaEYE2JomvjYdYQBxmgdPMEqt2r2AGqRIW8JXY9vIt
	I4jNK+AocfztFFaIdRYSF5o62CHighI/Jt9jAbGZgaZu3tbECmHLS2xe85Z5AiPfLCRls5CU
	zUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJp4JrWDcWWDxSFGAQ5GJR7eHfcD
	g4RYE8uKK3MPMUpwMCuJ8F6qAwrxpiRWVqUW5ccXleakFh9iTAZ6eyKzlGhyPjCF5ZXEGxqb
	mBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDYwBnxPd9S48LyS68arfm
	dvILv5w9vIwuq64o1x7jcbc91l10j+19lPc9t7MdH6o2ZNvtrJvEszjwunNDTOmBaac3WNw4
	ejv39JdA+9C1cz7E7Xz4XTBg2Txz7sr/3Gke0wVajoTGx+14K9qYyiPOMkdvseT+BZc/53E8
	4vC4kmjtW1N4ZsqqPCWW4oxEQy3mouJEAOrOmllXAwAA
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
index d9c5416..03031dc 100644
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
@@ -372,12 +377,21 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	unsigned long cfg = 0;
+	unsigned long cfg = CFG_LRU | CFG_QOS(15);
 	int maj, min = 0;
 
 	maj = __sysmmu_version(data, &min);
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
 
 	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
 }
-- 
1.7.2.5

