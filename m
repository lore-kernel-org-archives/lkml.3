Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaEJHDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:03:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16497 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaEJHCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:02:10 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-67-536dcef0b844
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 5/6] soc: samsung: exynos-chipid: Add Exynos Chipid driver
 support
Date: Sat, 10 May 2014 16:20:18 +0900
Message-id: <1399706419-13976-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t8zY90P53KDDRYuFLP4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCwWbf3CbrF+xmsWB3aP378mMXpsXlLv0bdlFaPH501yASxRXDYp
	qTmZZalF+nYJXBmvljgUXHCouD5vCksD40zTLkYODgkBE4nXDSldjJxAppjEhXvr2boYuTiE
	BJYxSrw8d4QRImEiseFKMzuILSSwiFHiYoM5RFEbk0Tz7fssIAk2AV2JJ+/nMoPYIgLZElca
	74PZzALpEg/eTmAFWSYsEC7x4HINSJhFQFXi08p9YPN5BTwkTk3fyQRxj4LEnEk2IGFOAU+J
	HT+62CDW1kgsb3gBdc5kdonFh1QgxghIfJt8iAWiVVZi0wFmiBJJiYMrbrBMYBRewMiwilE0
	tSC5oDgpvchIrzgxt7g0L10vOT93EyMkoPt2MN48YH2IMRlo3ERmKdHkfGBE5JXEGxqbGVmY
	mpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnmcm6dGRH398vWo
	6NHaDcUOv9d5nuW7uOrYzfT2F/UvJ3Ka7RO4f2b7JG79CUwyx6eL7Qk6fbanSvP3NZ0Jv6oK
	lp267RZ6yGvmtu8/1k2WLdNYzGisbdnQsUmh8oXIubT956Yy6V46e/H1LpGjmYzFCzbxPBNb
	s7blwFJ5/ZffVq+zXnnJdT2fEktxRqKhFnNRcSIAWR9veX4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jAd0P53KDDY40CFr8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZr5Y4FFxwqLg+bwpLA+NM0y5GTg4J
	AROJDVea2SFsMYkL99azgdhCAosYJS42mHcxcgHZbUwSzbfvs4Ak2AR0JZ68n8sMYosIZEtc
	abwPZjMLpEs8eDuBtYuRg0NYIFziweUakDCLgKrEp5X7GEFsXgEPiVPTdzKBlEgIKEjMmWQD
	EuYU8JTY8aMLam2NxPKGF4wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOmWdS
	OxhXNlgcYhTgYFTi4S14mxMsxJpYVlyZe4hRgoNZSYR3xcHcYCHelMTKqtSi/Pii0pzU4kOM
	yUBHTWSWEk3OB8ZzXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUw5kwNSpauNO5/smdS3+91e086v0/c27Zmx+f3hdekm2e2PMo7+tK0RCAqg3FdiT9HkNry
	1ty6O5xnivcUX2K88/mdVnPIbPNV7m+St1g9VD1reIVdyrhuedE7qbKyisqaklUvgv5en9oU
	/+mplf7/bg+7afXScx7N1/RSjoh20/qb7KotFG+nxFKckWioxVxUnAgABvFHct0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos SoCs have Chipid, for identification of product IDs
and SoC revistions. Till now we are using static macros
such as soc_is_exynosNNNN and #ifdefs for run time identification
of SoCs and their revisions. This is leading to add new Kconfig,
soc_is_exynosNNNN definitions each time new SoC support is getting
added. So this driver intends to provide initialization code
all these functionalites and thus helping in removing macros.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/soc/Kconfig                 |    1 +
 drivers/soc/Makefile                |    1 +
 drivers/soc/samsung/Kconfig         |   10 +++
 drivers/soc/samsung/Makefile        |    1 +
 drivers/soc/samsung/exynos-chipid.c |  166 +++++++++++++++++++++++++++++++++++
 include/linux/exynos-soc.h          |   46 ++++++++++
 6 files changed, 225 insertions(+)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/exynos-soc.h

diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 07a11be..86e52b1 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,5 +1,6 @@
 menu "SOC specific Drivers"
 
 source "drivers/soc/qcom/Kconfig"
+source "drivers/soc/samsung/Kconfig"
 
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 0f7c447..ee890aa 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
+obj-$(CONFIG_ARCH_EXYNOS)	+= samsung/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..dacc95d
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,10 @@
+
+# SAMSUNG Soc drivers
+#
+config EXYNOS_CHIPID
+	tristate "Support Exynos CHIPID"
+	default y
+	select SOC_BUS
+	depends on ARCH_EXYNOS || ARM64
+	help
+	  If you say Y here you get support for the Exynos CHIP id.
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
new file mode 100644
index 0000000..855ca05
--- /dev/null
+++ b/drivers/soc/samsung/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EXYNOS_CHIPID)	+= exynos-chipid.o
diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
new file mode 100644
index 0000000..b5bccd9
--- /dev/null
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
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
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
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
+enum exynos_soc_revision exynos_revision;
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
+bool is_soc_id_compatible(enum exynos_soc_id soc_id)
+{
+	return soc_id == exynos_soc_id;
+}
+
+bool is_soc_rev_compatible(enum exynos_soc_revision soc_rev)
+{
+	return soc_rev == exynos_revision;
+}
+
+static const char *exynos_soc_id_to_name(enum exynos_soc_id id)
+{
+	const char *soc_name;
+	switch (id) {
+	case EXYNOS4210:
+		soc_name = "EXYNOS4210";
+		break;
+	case EXYNOS4212:
+		soc_name = "EXYNOS4212";
+		break;
+	case EXYNOS4412:
+		soc_name = "EXYNOS4412";
+		break;
+	case EXYNOS5250:
+		soc_name = "EXYNOS5250";
+		break;
+	case EXYNOS5420:
+		soc_name = "EXYNOS5420";
+		break;
+	case EXYNOS5440:
+		soc_name = "EXYNOS5440";
+		break;
+	default:
+		soc_name = "";
+	}
+	return soc_name;
+}
+
+struct device * __init exynos_soc_device_init(void)
+{
+	struct soc_device_attribute *soc_dev_attr;
+	struct soc_device *exynos_soc_dev;
+	struct device_node *root;
+	int ret;
+
+	if (!exynos_chipid_base)
+		early_exynos_chipid_init();
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		return NULL;
+
+	soc_dev_attr->family = "Samsung Exynos";
+
+	root = of_find_node_by_path("/");
+	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
+	of_node_put(root);
+	if (ret)
+		goto free_soc;
+
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", exynos_revision);
+	if (!soc_dev_attr->revision)
+		goto free_soc;
+
+	soc_dev_attr->soc_id = exynos_soc_id_to_name(exynos_soc_id);
+
+	exynos_soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(exynos_soc_dev))
+		goto free_rev;
+
+	return soc_device_to_device(exynos_soc_dev);
+
+free_rev:
+	kfree(soc_dev_attr->revision);
+free_soc:
+	kfree(soc_dev_attr);
+	return NULL;
+}
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
+		exynos_revision = pro_id & 0xFF;
+		pr_info("Exynos: CPU[%s] CPU_REV[0x%x] Detected\n",
+				exynos_soc_id_to_name(exynos_soc_id),
+				exynos_revision);
+	}
+
+}
diff --git a/include/linux/exynos-soc.h b/include/linux/exynos-soc.h
new file mode 100644
index 0000000..ebd4366
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
+	EXYNOS4212 = 0xE4212,
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
+enum exynos_soc_revision {
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
+extern struct device *exynos_soc_device_init(void);
+extern bool is_soc_id_compatible(enum exynos_soc_id soc_id);
+extern bool is_soc_rev_compatible(enum exynos_soc_revision soc_rev);
+
+#endif /* __EXYNOS_SOC_H */
-- 
1.7.10.4

