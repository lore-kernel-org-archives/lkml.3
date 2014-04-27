Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaD0HlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31169 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaD0Hjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:33 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-65-535cb4344bc2
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
Subject: [PATCH v12 16/31] iommu/exynos: turn on useful configuration options
Date: Sun, 27 Apr 2014 13:07:48 +0530
Message-id: <1398584283-22846-17-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkStdkS0ywweVnohZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8b7m7eZ
	Cu7IVlyfv4e9gfG5eBcjJ4eEgInE5QOzmSBsMYkL99azgdhCAksZJbpXpsPUPLjWyd7FyAUU
	X8QocXfSTSYIZwKTxMSZLxhBqtgEDCW237vCCpIQEVjNKNF38QxYC7PAXSaJOavegVUJC/hK
	TP24lKWLkYODRUBVYtFOAZAwr4CHxKmPjewgYQkBBYk5k2xAwpxA4Sd39rBAXOQu8fbUF7D5
	EgJzOSRO9W5lBkmwCAhIfJt8iAWiV1Zi0wFmiKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CIT
	veLE3OLSvHS95PzcTYzAaDz979mEHYz3DlgfYkwGGjeRWUo0OR8YzXkl8YbGZkYWpiamxkbm
	lmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJjQsVl/fc8+K9GoWMHD26Yw
	fci3fXP/SOnP4Nv1E17enLXe8NzWFTf3Vn13mPzxx3aBT1d4XDpWloUrWKxYsIvnSda8D7kv
	K1sSprZ/kzn0rmLR7b9shfNzN7400NxfIJG+m3PdtMxt95Lznh5dc16U69WPq7mL7/6/EbA6
	QUSvzqLV11hsfm2tEktxRqKhFnNRcSIAAARoAtwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV2TLTHBBh+ncVvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgz3t+8zVRwR7bi+vw97A2Mz8W7GDk5JARMJB5c62SHsMUkLtxb
	z9bFyMUhJLCIUeLupJtMEM4EJomJM18wglSxCRhKbL93hRUkISKwmlGi7+IZdhCHWeAuk8Sc
	Ve/AqoQFfCWmflzK0sXIwcEioCqxaKcASJhXwEPi1MdGdpCwhICCxJxJNiBhTqDwkzt7WEBs
	IQF3ibenvrBOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM42p9J72Bc1WBxiFGA
	g1GJh/eHdEywEGtiWXFl7iFGCQ5mJRFezulAId6UxMqq1KL8+KLSnNTiQ4zJQDdNZJYSTc4H
	JqK8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBMTb58Zlee
	XPGF2Q8PxHqmvNpoo6z9PXOV87JbL2/JKCsceXUnZeW6fL8fvjUlit1prCbRAe9kmzRYl11/
	NId1xYwnPAqO345HrTOeptrA8nSHWeuMUP0lGYueMnzOyGD77R5xoynWci6jw5mdrFdS4p46
	l/w79Ws+95sJPxOc2AtF17IrGkQqsRRnJBpqMRcVJwIA7yXHOjoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This turns on FLPD_CACHE, ACGEN and SYSSEL.

FLPD_CACHE is a cache of 1st level page table entries that contains
the address of a 2nd level page table to reduce latency of page table
walking.

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
 drivers/iommu/exynos-iommu.c |   52 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 45c792c..810bcaf 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -81,6 +81,13 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_LRU		0x1
+#define CFG_QOS(n)	((n & 0xF) << 7)
+#define CFG_MASK	0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
+#define CFG_ACGEN	(1 << 24) /* System MMU 3.3 only */
+#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
+#define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
+
 #define REG_MMU_CTRL		0x000
 #define REG_MMU_CFG		0x004
 #define REG_MMU_STATUS		0x008
@@ -97,6 +104,12 @@
 
 #define REG_MMU_VERSION		0x034
 
+#define MMU_MAJ_VER(val)	((val) >> 7)
+#define MMU_MIN_VER(val)	((val) & 0x7F)
+#define MMU_RAW_VER(reg)	(((reg) >> 21) & ((1 << 11) - 1)) /* 11 bits */
+
+#define MAKE_MMU_VER(maj, min)	((((maj) & 0xF) << 7) | ((min) & 0x7F))
+
 #define REG_PB0_SADDR		0x04C
 #define REG_PB0_EADDR		0x050
 #define REG_PB1_SADDR		0x054
@@ -206,6 +219,29 @@ static void sysmmu_unblock(void __iomem *sfrbase)
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
 }
 
+static unsigned int __raw_sysmmu_version(struct sysmmu_drvdata *data)
+{
+	return MMU_RAW_VER(__raw_readl(data->sfrbase + REG_MMU_VERSION));
+}
+
+static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
+				     unsigned int *minor)
+{
+	unsigned int ver = 0;
+
+	ver = __raw_sysmmu_version(data);
+	if (ver > MAKE_MMU_VER(3, 3)) {
+		dev_err(data->sysmmu, "%s: version(%d.%d) is higher than 3.3\n",
+			__func__, MMU_MAJ_VER(ver), MMU_MIN_VER(ver));
+		BUG();
+	}
+
+	if (minor)
+		*minor = MMU_MIN_VER(ver);
+
+	return MMU_MAJ_VER(ver);
+}
+
 static bool sysmmu_block(void __iomem *sfrbase)
 {
 	int i = 120;
@@ -360,7 +396,21 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	unsigned long cfg = 0;
+	unsigned long cfg = CFG_LRU | CFG_QOS(15);
+	int maj, min = 0;
+
+	maj = __sysmmu_version(data, &min);
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
1.7.9.5

