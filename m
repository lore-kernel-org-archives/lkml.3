Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaELGR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17859 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaELGRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:16 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-82-5370676a6552
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
Subject: [PATCH v13 18/19] iommu/exynos: turn on useful configuration options
Date: Mon, 12 May 2014 11:45:03 +0530
Message-id: <1399875304-19948-19-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkSjcrvSDYYNNffYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6MQzfvMRfMVa54svAYYwPjOpkuRk4OCQETibXdj1ghbDGJC/fWs4HYQgJL
	GSV2vHKFqWk89gaohgsovohR4vv/tSwQzgQmiY1LXzCBVLEJGEpsv3cFrEpEYDWjRN/FM+wg
	DrPAbGaJI48WM4JUCQv4Svw8sQdsH4uAqsTPa/uYQWxeAQ+Jja2LgcZyAO1TkJgzyQYkzAkU
	/rx6CtRJ7hLHXl0FWyAhsIVD4saPyywQcwQkvk0+BNUrK7HpADPE2ZISB1fcYJnAKLyAkWEV
	o2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmC0nv73rH8H490D1ocYk4HGTWSWEk3OB0Z7Xkm8
	obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgDG2ukOL+
	uySv4L6agc7tGnve7Vt8Euat3Vxau+jugptV7673vflo0vzzQchurWPSqWkvQ9UnV3gF/z0U
	/qM5nbVo7dk5jDK/XVTeyB2L9WG6e9Krb++eH06rVKUeNZkcFufm79yk9aX2S01wtnVcq8yG
	DTf57Sa+LV6487xk9fdOnj/NP99zKrEUZyQaajEXFScCABfUaBPsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd2s9IJggwtz1C3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZhy6eY+5YK5yxZOFxxgbGNfJdDFy
	ckgImEg0HnvDCmGLSVy4t56ti5GLQ0hgEaPE9/9rWSCcCUwSG5e+YAKpYhMwlNh+7worSEJE
	YDWjRN/FM+wgDrPAbGaJI48WM4JUCQv4Svw8sQdsLouAqsTPa/uYQWxeAQ+Jja2LgcZyAO1T
	kJgzyQYkzAkU/rx6ChuILSTgLnHs1VXWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIEJ4Nn0jsYVzVYHGIU4GBU4uH9wFAQLMSaWFZcmXuIUYKDWUmE96M/UIg3JbGyKrUoP76o
	NCe1+BBjMtBRE5mlRJPzgYkqryTe0NjE3NTY1NLEwsTMkjRhJXHeg63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYAywjW5d5ff3tcsTo/Zm2j/dP7macX1IfUSJdt6ntv3B51MP/Bxe7lBR1VPfu
	mWX2ntF4tmjmmRtSRw+mfy/cbdE6YdfFR47dE14LKct9+2j39KRuvZzCvVUOiw+UW1yYst0h
	ax1TtO7qsm/7dkosPctu9O5wiXrxq8+upyt13jw+dkbi3DXGh0osxRmJhlrMRcWJACa1la5K	AwAA
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

This patch also adds simplifies the sysmmu version checking by
introducing some macros.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index b937490..26fb4d7 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -93,6 +93,13 @@ static u32 lv2ent_offset(sysmmu_iova_t iova)
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
@@ -109,6 +116,12 @@ static u32 lv2ent_offset(sysmmu_iova_t iova)
 
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
@@ -219,6 +232,11 @@ static void sysmmu_unblock(void __iomem *sfrbase)
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
 }
 
+static unsigned int __raw_sysmmu_version(struct sysmmu_drvdata *data)
+{
+	return MMU_RAW_VER(__raw_readl(data->sfrbase + REG_MMU_VERSION));
+}
+
 static bool sysmmu_block(void __iomem *sfrbase)
 {
 	int i = 120;
@@ -374,7 +392,21 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	unsigned int cfg = 0;
+	unsigned int cfg = CFG_LRU | CFG_QOS(15);
+	unsigned int ver;
+
+	ver = __raw_sysmmu_version(data);
+	if (MMU_MAJ_VER(ver) == 3) {
+		if (MMU_MIN_VER(ver) >= 2) {
+			cfg |= CFG_FLPDCACHE;
+			if (MMU_MIN_VER(ver) == 3) {
+				cfg |= CFG_ACGEN;
+				cfg &= ~CFG_LRU;
+			} else {
+				cfg |= CFG_SYSSEL;
+			}
+		}
+	}
 
 	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
 }
@@ -494,13 +526,11 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 
 	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
-		unsigned int maj;
 		unsigned int num_inv = 1;
 
 		if (!IS_ERR(data->clk_master))
 			clk_enable(data->clk_master);
 
-		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
 		 * L2TLB invalidation required
 		 * 4KB page: 1 invalidation
@@ -511,7 +541,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 		 * 1MB page can be cached in one of all sets.
 		 * 64KB page can be one of 16 consecutive sets.
 		 */
-		if ((maj >> 28) == 2) /* major version number */
+		if (MMU_MAJ_VER(__raw_sysmmu_version(data)) == 2)
 			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 
 		if (sysmmu_block(data->sfrbase)) {
-- 
1.7.9.5

