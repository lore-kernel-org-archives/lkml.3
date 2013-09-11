Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3IKLQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:16:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26181 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3IKLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:55 -0400
X-AuditID: cbfee68e-b7f756d000004512-7b-523050adbb8a
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC 3/4] power: asv: Add support for exynos5250
Date: Wed, 11 Sep 2013 16:44:07 +0530
Message-id: <1378898048-25205-4-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
References: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSq7suwCDIYEI7m0XvgqtsFpseX2O1
	uLxrDpvFjPP7mCxuN65gs+hf2MtksX7GaxaLYzOWMFps/OphMWf6OyYHLo871/aweWxeUu/R
	t2UVo8ejxS2MHp83yQWwRnHZpKTmZJalFunbJXBlTGh5yFqwwLLi0BK7BsaPel2MnBwSAiYS
	P9e/Y4WwxSQu3FvP1sXIxSEksJRRYvbfWSwwRa/P7WCESExnlHh5+jkrhNPGJLHywjKgDAcH
	m4CRxKtjdiANIgIKEpt7n4HVMAs8Z5L4umcuG0hCWMBSYuKVBWA2i4CqxKtba8A28Aq4Siz8
	vQtqm4JE67JD7CAzOQXcJNZMsQcJCwGV3N58ihlkpoTAJnaJzvcnWSHmCEh8m3yIBaReQkBW
	YtMBZogxkhIHV9xgmcAovICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYPif/vesbwfj
	zQPWhxiTgcZNZJYSTc4Hxk9eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhgn1uwLLHLm0Jl6+5ITt+nsj9d8T0YlB8wL/pEZLOwmof1Y7XdaiIeL
	q3O507IFPg7FB72UnvgU712zp/2PYkbjV0/ZQ4oW56aHBXY8WbD9Y8/MF3NsX9r+uZVwivVN
	jMLp7UFTBD//6Q2c8f6JjqfHX+Gq6gJt98T/W6oOJhZl/VZjPf7nfaUSS3FGoqEWc1FxIgAB
	hsKGlQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd21AQZBBl17LC16F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rxu3EFm0X/wl4mi/UzXrNYHJuxhNFi41cPiznT3zE5cHncubaHzWPzknqP
	vi2rGD0eLW5h9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aE
	loesBQssKw4tsWtg/KjXxcjJISFgIvH63A5GCFtM4sK99WxdjFwcQgLTGSVenn7OCuG0MUms
	vLAMqIqDg03ASOLVMTuQBhEBBYnNvc/AapgFnjNJfN0zlw0kISxgKTHxygIwm0VAVeLVrTUs
	IDavgKvEwt+7WCC2KUi0LjvEDjKTU8BNYs0Ue5CwEFDJ7c2nmCcw8i5gZFjFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERxdz6R2MK5ssDjEKMDBqMTDe0NOP0iINbGsuDL3EKMEB7OSCO8D
	U4MgId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HRn5eSbyhsYm5qbGppYmFiZklacJK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCKKuyXEdordqbJ5PbseZfe5a5her4maoNtQqVFRjn3
	160Sr2ZEb/wqZL89Izewuvm/8nwe+6imy1N5t666+lc87EbUk63/FbcqaSRN2B/7nOWb2IyP
	4uE1jfLrHB+tKDm5n1dT3la7Mz+n7ESh/yRLOf9nm65EfOvNf3xX3nODyvdVau4PeK2UWIoz
	Eg21mIuKEwEKuak/8gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support (only for ARM ASV) for exynos5250 chips which
have fused ASV group.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/power/asv/Makefile         |    2 +-
 drivers/power/asv/exynos-asv.c     |    9 +++
 drivers/power/asv/exynos-asv.h     |    1 +
 drivers/power/asv/exynos5250-asv.c |  141 ++++++++++++++++++++++++++++++++++++
 4 files changed, 152 insertions(+), 1 deletions(-)
 create mode 100644 drivers/power/asv/exynos5250-asv.c

diff --git a/drivers/power/asv/Makefile b/drivers/power/asv/Makefile
index 9a94868..a471c8e 100644
--- a/drivers/power/asv/Makefile
+++ b/drivers/power/asv/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_POWER_ASV)			+= asv.o
-obj-$(CONFIG_POWER_EXYNOS_ASV)		+= exynos-asv.o
+obj-$(CONFIG_POWER_EXYNOS_ASV)		+= exynos-asv.o exynos5250-asv.o
diff --git a/drivers/power/asv/exynos-asv.c b/drivers/power/asv/exynos-asv.c
index d3f43a4..7449b55 100644
--- a/drivers/power/asv/exynos-asv.c
+++ b/drivers/power/asv/exynos-asv.c
@@ -46,9 +46,18 @@ static int exynos_asv_probe(struct platform_device *pdev)
 	exynos_asv_info->base = base;
 
 	/* call SoC specific intialisation routine */
+	if (of_machine_is_compatible("samsung,exynos5250")) {
+		ret = exynos5250_asv_init(exynos_asv_info);
+		if (ret) {
+			pr_err("%s: exynos5250_asv_init failed : %d\n",
+				__func__, ret);
+			goto err;
+		}
+	}
 
 	register_asv_member(exynos_asv_info->asv_list, exynos_asv_info->nr_mem);
 
+err:
 	iounmap(base);
 err_map:
 	of_node_put(chip_id);
diff --git a/drivers/power/asv/exynos-asv.h b/drivers/power/asv/exynos-asv.h
index 89a1ae8..a31becb 100644
--- a/drivers/power/asv/exynos-asv.h
+++ b/drivers/power/asv/exynos-asv.h
@@ -18,4 +18,5 @@ struct exynos_asv_common {
 	void __iomem *base;
 };
 
+extern int exynos5250_asv_init(struct exynos_asv_common *exynos_info);
 #endif	/* __EXYNOS_ASV_D_H */
diff --git a/drivers/power/asv/exynos5250-asv.c b/drivers/power/asv/exynos5250-asv.c
new file mode 100644
index 0000000..293b3f1
--- /dev/null
+++ b/drivers/power/asv/exynos5250-asv.c
@@ -0,0 +1,141 @@
+/* exynos5250 - ASV(Adaptive Supply Voltage)
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/power/asv-driver.h>
+#include "exynos-asv.h"
+
+#define FUSED_SG_OFFSET		3
+#define ORIG_SG_OFFSET		17
+#define ORIG_SG_MASK		0xF
+#define MOD_SG_OFFSET		21
+#define MOD_SG_MASK		0x7
+
+#define ARM_LEVEL_NR		16
+#define ARM_GRP_NR		12
+
+#define CHIP_ID_OFFSET		0x4
+
+struct exynos5250_asv_info {
+	unsigned int package_id;
+	/* we may need more info as global data */
+};
+
+static struct exynos5250_asv_info asv_group __initdata;
+
+static unsigned int asv_voltage[ARM_LEVEL_NR][ARM_GRP_NR + 1] __initdata = {
+	{ 1700000, 1300000, 1275000, 1275000, 1262500, 1250000, 1225000,
+	1212500, 1200000, 1187500, 1175000, 1150000, 1125000 },	/* L0 */
+	{ 1600000, 1250000, 1225000, 1225000, 1212500, 1200000, 1187500,
+	1175000, 1162500, 1150000, 1137500, 1112500, 1100000 },	/* L1 */
+	{ 1500000, 1225000, 1187500, 1175000, 1162500, 1150000, 1137500,
+	1125000, 1112500, 1100000, 1087500, 1075000, 1062500 },	/* L2 */
+	{ 1400000, 1200000, 1125000, 1125000, 1125000, 1112500, 1100000,
+	1087500, 1075000, 1062500, 1050000, 1037500, 1025000 },	/* L3 */
+	{ 1300000, 1150000, 1100000, 1100000, 1100000, 1087500, 1075000,
+	1062500, 1050000, 1037500, 1025000, 1012500, 1000000 },	/* L4 */
+	{ 1200000, 1125000, 1075000, 1075000, 1062500, 1050000, 1037500,
+	1025000, 1012500, 1000000,  987500,  975000,  975000 },	/* L5 */
+	{ 1100000, 1100000, 1050000, 1050000, 1037500, 1025000, 1012500,
+	1000000,  987500,  975000,  962500,  950000,  925000 },	/* L6 */
+	{ 1000000, 1075000, 1037500, 1037500, 1012500, 1000000,  987500,
+	975000,  962500,  950000,  937500,  925000,  912500 },	/* L7 */
+	{ 900000, 1050000, 1025000, 1012500,  987500,  975000,  962500,
+	950000,  937500,  925000,  912500,  912500,  900000 },	/* L8 */
+	{ 800000, 1025000, 1000000,  987500,  975000,  962500,  950000,
+	937500,  925000,  912500,  900000,  900000,  900000 },	/* L9 */
+	{ 700000, 1012500,  975000,  962500,  950000,  937500,  925000,
+	912500,  900000,  900000,  900000,  900000,  900000 },	/* L10 */
+	{ 600000, 1000000,  962500,  950000,  937500,  925000,  912500,
+	900000,  900000,  900000,  900000,  900000,  900000 },	/* L11 */
+	{ 500000, 975000,  950000,  937500,  925000,  912500,  900000,
+	900000,  900000,  900000,  900000,  900000,  887500 },	/* L12 */
+	{ 400000, 950000,  937500,  925000,  912500,  900000,  900000,
+	900000,  900000,  900000,  900000,  887500,  887500 },	/* L13 */
+	{ 300000, 937500,  925000,  912500,  900000,  900000,  900000,
+	900000,  900000,  900000,  887500,  887500,  875000 },	/* L14 */
+	{ 200000, 925000,  912500,  900000,  900000,  900000,  900000,
+	900000,  900000,  887500,  887500,  875000,  875000 },	/* L15 */
+};
+
+static int __init exynos5250_get_asv_group(struct asv_info *asv_info)
+{
+	int exynos_asv_grp;
+	u32 exynos_orig_sp;
+	u32 exynos_mod_sp;
+	u32 package_id = asv_group.package_id;
+
+	/* If ASV group is fused then retrieve it */
+	if ((package_id >> FUSED_SG_OFFSET) & 0x1) {
+		exynos_orig_sp = (package_id >> ORIG_SG_OFFSET) & ORIG_SG_MASK;
+		exynos_mod_sp = (package_id >> MOD_SG_OFFSET) & MOD_SG_MASK;
+
+		exynos_asv_grp = exynos_orig_sp - exynos_mod_sp;
+		if (exynos_asv_grp < 0) {
+			pr_warn("%s: Invalid ASV group: %d\n", __func__,
+				exynos_asv_grp);
+			exynos_asv_grp = 0;	/* go for default */
+		}
+	} else {
+		pr_warn("%s: ASV group not fused for : %s\n", __func__,
+			asv_info->name);
+		exynos_asv_grp = 0;		/* go for default */
+	}
+
+	asv_info->asv_grp = exynos_asv_grp;
+	return 0;
+}
+
+static int __init exynos5250_init_arm_asv_table(struct asv_info *asv_info)
+{
+	struct asv_freq_table *dvfs_table;
+	int i, asv_grp = asv_info->asv_grp;
+
+	dvfs_table = kzalloc(sizeof(struct asv_freq_table) * ARM_LEVEL_NR,
+			GFP_KERNEL);
+	if (!dvfs_table)
+		return -ENOMEM;
+
+	for (i = 0; i < ARM_LEVEL_NR; i++) {
+		dvfs_table[i].freq = asv_voltage[i][0];
+		dvfs_table[i].volt = asv_voltage[i][asv_grp + 1];
+	}
+
+	asv_info->dvfs_table = dvfs_table;
+	return 0;
+}
+
+/* TODO: Implement .init_asv callback to set ABB value */
+
+static struct asv_ops exynos5250_arm_asv_ops __initdata = {
+	.get_asv_group = exynos5250_get_asv_group,
+	.init_asv_table = exynos5250_init_arm_asv_table,
+};
+
+static struct asv_info exynos5250_asv_member[] __initdata = {
+	{
+		.type		= ASV_ARM,
+		.name		= "VDD_ARM",
+		.ops		= &exynos5250_arm_asv_ops,
+		.nr_dvfs_level	= ARM_LEVEL_NR,
+	},
+};
+
+int __init exynos5250_asv_init(struct exynos_asv_common *exynos_info)
+{
+	asv_group.package_id = readl(exynos_info->base + CHIP_ID_OFFSET);
+
+	exynos_info->asv_list = exynos5250_asv_member;
+	exynos_info->nr_mem = ARRAY_SIZE(exynos5250_asv_member);
+
+	return 0;
+}
-- 
1.7.0.4

