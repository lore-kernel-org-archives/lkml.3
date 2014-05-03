Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaECFxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:53:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48936 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaECFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:53:38 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-c1-53648461a6a9
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] misc: exynos-chipid: Add Exynos Chipid driver support
Date: Sat, 03 May 2014 15:11:39 +0900
Message-id: <1399097500-4052-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+ZkW5iS0qwwc7N/BZ/Jx1jt2hevJ7N
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81os2vqF3WL9jNcsDpweLc09bB6/f01i9Ng/dw27
	x+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVsXv1D7aCdr2KC09esDQwvlXtYuTkkBAw
	kVi87TIrhC0mceHeerYuRi4OIYFljBJLJu5nhCl69WwKI0RiOqPEmn1X2CGcNiaJS99WsoFU
	sQnoSjx5P5cZxBYRyJa40nifGaSIWeAQo8T9w/PAioQFvCS29bwEs1kEVCX2vFvDAmLzCrhL
	rNy3FqiBA2idgsScSTYgYU4BD4kvD3eBlQsBlcyePxHqok3sEof2cEKMEZD4NvkQC0SrrMSm
	A8wQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkgE9O5gvH3A+hBj
	MtC4icxSosn5wAjKK4k3NDYzsjA1MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbG5ce2yq35/+edIdvKriz1xbarPUVmf2DV6D++dGmXCE+33al6MYeuGqv0V942
	MaJ7ZWsTrZojq1SblZ2vH9t0ieGccNhS7bL/uyfeXvyX87hzmdWpsNXSE2MWbr8d7qL54+7d
	luwdmqdF13UnxOqyrxbrEVrwe8viQ3NnX2/+euPF2fdamptClViKMxINtZiLihMBDyJZJJYC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQd3ElpRgg4vTuSz+TjrGbtG8eD2b
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8X6Ga9ZHDg9Wpp72Dx+/5rE6LF/7hp2
	j81L6j36tqxi9Pi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bu
	1T/YCtr1Ki48ecHSwPhWtYuRk0NCwETi1bMpjBC2mMSFe+vZuhi5OIQEpjNKrNl3hR3CaWOS
	uPRtJRtIFZuArsST93OZQWwRgWyJK433mUGKmAUOMUrcPzwPrEhYwEtiW89LMJtFQFViz7s1
	LCA2r4C7xMp9a4EaOIDWKUjMmWQDEuYU8JD48nAXWLkQUMns+RMZJzDyLmBkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHGHPpHcwrmqwOMQowMGoxMOrcDc5WIg1say4MhfoGA5mJRFe
	Fs2UYCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB0Z/Xkm8obGJmZGlkZmFkYm5OWnCSuK8
	B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw6izdv1hkm+xMuyKPwo6p0fz7V3Vlz/ql4HZbcOkp
	KY+53f2NJmWid09oCF7Xu729a9WuB2wvmeI//2Hg8D0SepJ36axvntGt4udCn1etriy4seEq
	L9vvVuYJjW6856+35bNd3+XCExyZ+H29o/akU1Gryn11w8/a1mgYnWX1VDRw8brqFW6jxFKc
	kWioxVxUnAgAZZIYMvQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos SoCs have Chipid IP, for identification of product IDs
and SoC revistions. Till now we are using static macros
such as soc_is_exynosxxxx and #ifdefs for run time identification
of SoCs and their revisions. This is leading to add new Kconfig,
soc_is_exynosXXXX definitions each time new SoC support is getting
added. So this driver intends to provide initialization code
all these functionalites and thus helping in removing macros.

CC: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/misc/Kconfig         |    7 ++++
 drivers/misc/Makefile        |    1 +
 drivers/misc/exynos-chipid.c |   83 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/exynos-soc.h   |   46 +++++++++++++++++++++++
 4 files changed, 137 insertions(+)
 create mode 100644 drivers/misc/exynos-chipid.c
 create mode 100644 include/linux/exynos-soc.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 1cb7408..f313bd3 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,13 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config EXYNOS_CHIPID
+	tristate "Support Exynos CHIPID"
+	default y
+	depends on ARCH_EXYNOS || ARM64
+	help
+	  If you say Y here you get support for the Exynos CHIP id.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7eb4b69..48c8fb5 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
+obj-$(CONFIG_EXYNOS_CHIPID)	+= exynos-chipid.o
diff --git a/drivers/misc/exynos-chipid.c b/drivers/misc/exynos-chipid.c
new file mode 100644
index 0000000..eb23339
--- /dev/null
+++ b/drivers/misc/exynos-chipid.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
+ *	      http://www.samsung.com/
+ *
+ * EXYNOS - CHIP ID support
+ * Author: Pankaj Dubey <pankaj.dubey@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/exynos-soc.h>
+
+#define EXYNOS4_SOC_MASK	0xFFFE0
+#define EXYNOS5_SOC_MASK	0xFFFFF
+
+#define PROD_ID_SHIFT	(12)
+
+static void __iomem	*exynos_chipid_base;
+unsigned int exynos_soc_id = EXYNOS_SOC_UNKNOWN;
+unsigned int exynos_soc_rev;
+
+struct exynos_chipid_data {
+	unsigned int product_id_mask;
+	unsigned int product_id_shift;
+};
+
+static struct exynos_chipid_data exynos4_chipid_data = {
+	.product_id_mask	= EXYNOS4_SOC_MASK,
+	.product_id_shift	= PROD_ID_SHIFT,
+};
+
+static struct exynos_chipid_data exynos5_chipid_data = {
+	.product_id_mask	= EXYNOS5_SOC_MASK,
+	.product_id_shift	= PROD_ID_SHIFT,
+};
+
+static struct of_device_id of_exynos_chipid_ids[] = {
+	{
+		.compatible	= "samsung,exynos4-chipid",
+		.data		= (void *)&exynos4_chipid_data,
+	},
+	{
+		.compatible	= "samsung,exynos5-chipid",
+		.data		= (void *)&exynos5_chipid_data,
+	},
+	{},
+};
+
+/**
+ * early_exynos_chipid_init - Early chipid initialization
+ */
+void __init early_exynos_chipid_init(void)
+{
+	struct device_node *np = NULL;
+	const struct of_device_id *match;
+	struct exynos_chipid_data *chipid_data;
+	int pro_id;
+
+	if (!exynos_chipid_base) {
+		np = of_find_matching_node_and_match(NULL,
+				of_exynos_chipid_ids, &match);
+		if (!np)
+			panic("%s, failed to find chipid node\n", __func__);
+
+		chipid_data = (struct exynos_chipid_data *) match->data;
+		exynos_chipid_base = of_iomap(np, 0);
+
+		if (!exynos_chipid_base)
+			panic("%s: failed to map registers\n", __func__);
+
+		pro_id  = __raw_readl(exynos_chipid_base);
+		exynos_soc_id = (pro_id >> chipid_data->product_id_shift)
+			& chipid_data->product_id_mask;
+		exynos_soc_rev = pro_id & 0xFF;
+		pr_info("Exynos: CPUID[0x%x] CPU_REV[0x%x] Detected\n",
+				exynos_soc_id, exynos_soc_rev);
+	}
+}
diff --git a/include/linux/exynos-soc.h b/include/linux/exynos-soc.h
new file mode 100644
index 0000000..cb3ae06
--- /dev/null
+++ b/include/linux/exynos-soc.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS SoC Chipid support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_SOC_H
+#define __EXYNOS_SOC_H
+
+/* enum holding product id of Exynos SoC
+ * Any new Exynos SoC product id should be added here
+ */
+enum exynos_soc_id {
+	EXYNOS4210 = 0xE4210,
+	EXYNOS4212 = 0xE4412,
+	EXYNOS4412 = 0xE4412,
+	EXYNOS5250 = 0x43520,
+	EXYNOS5420 = 0xE5420,
+	EXYNOS5440 = 0xE5440,
+	EXYNOS_SOC_UNKNOWN = -1,
+};
+
+/* enum holding revision id of Exynos SoC
+ * Any new Exynos SoC revision id should be added here
+ */
+enum exynos_soc_rev {
+	EXYNOS4210_REV_0	= 0x0,
+	EXYNOS4210_REV_1_0	= 0x10,
+	EXYNOS4210_REV_1_1	= 0x11,
+};
+
+/* Since we need chipid to be initialized as early as possible
+ * during secondary core bootup adding early initialization function
+ * Note: This should be called only after device tree gets unflatten
+ */
+extern void early_exynos_chipid_init(void);
+
+extern unsigned int exynos_soc_id;
+extern unsigned int exynos_soc_rev;
+
+#endif /* __EXYNOS_SOC_H */
-- 
1.7.10.4

