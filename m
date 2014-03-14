Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaCNFJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:09:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11230 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaCNFJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:09:05 -0400
X-AuditID: cbfee690-b7f266d00000287c-e7-53228eef2b9d
Date: Fri, 14 Mar 2014 14:09:03 +0900
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
Subject: [PATCH v11 18/27] iommu/exynos: turn on useful configuration options
Message-id: <20140314140903.52429ecd28498bb636fb8ad2@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zI933fUrBBrMvGFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVxYMle1oJ1shU9kyYwNTAeEO9i5OSQEDCRmNR0hgXC
	FpO4cG89WxcjF4eQwDJGieutTaxdjBxgRae2qEDEFzFKfP7RBtYgJDCZSeLQQjMQm0VAVeLu
	pYdgcTYBLYnVc48zgjSICLQxSXxtPMQC4jALzGWW+PhtDhtIlbCAr0T73iuMIDavgKPEvvsb
	2CHOsJC40NTBDhEXlPgx+R7YVGagqZu3gVwEYstLbF7zlhlkqITARA6JB+ffM0GcISDxbTLI
	NpCzZSU2HWCGmCkpcXDFDZYJjCKzkIydhWTsLCRjFzAyr2IUTS1ILihOSi8y0StOzC0uzUvX
	S87P3cQIid4JOxjvHbA+xJgMtHIis5Rocj4w+vNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFNVlCS/7dnc4z41hTMzOeT4mx1c6n1ka5S3G3y
	9bPw96ZnImenySwVmzeZp/nQjOt3XHwObn+qZz53/USrx34vlaZEl/CsazvErBA+aabI5oPB
	ZbevRi0zErj8ct7awy2nZ746W3NejLkj/rX2VM3SnP2PD+9tf3LZJTe7z17Dae2WdTvTK6uU
	WIozEg21mIuKEwGPP0g19AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd33fUrBBodea1vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48CSvawF62Qr
	eiZNYGpgPCDexcjBISFgInFqi0oXIyeQKSZx4d56ti5GLg4hgUWMEp9/tLGAJIQEJjNJHFpo
	BmKzCKhK3L30ECzOJqAlsXrucUaQBhGBNiaJr42HWEAcZoG5zBIfv81hA6kSFvCVaN97hRHE
	5hVwlNh3fwM7xDoLiQtNHewQcUGJH5PvgU1lBpq6eVsTK4QtL7F5zVvmCYx8s5CUzUJSNgtJ
	2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwanhmfQOxlUNFocYBTgYlXh4ZxxVDBZi
	TSwrrsw9xCjBwawkwlsVoRQsxJuSWFmVWpQfX1Sak1p8iDEZ6O+JzFKiyfnAtJVXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYy8LQLnurqOhZ19/k/n7a4y
	3z1Xj8bKHLmQvOjxIlPp5PtnhH16zrke7BIMNt7zlLXUc621mFS6qpLNOQv16/8v5l8/cfHo
	Icvljax67ie0dGt152tW62yyv6wU8Vsq3Mi88tpz0Xwz/6LjSwMZ3Zt7Ws6+W7R5bW76ln2z
	/s3Y++hRqspuoUtKLMUZiYZazEXFiQBTDZ6EUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 6834556..9037da0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -82,6 +82,13 @@
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
@@ -98,6 +105,12 @@
 
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
@@ -217,6 +230,29 @@ static void sysmmu_unblock(void __iomem *sfrbase)
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
@@ -367,7 +403,21 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 
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

