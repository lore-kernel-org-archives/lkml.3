Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaHVIN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:13:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21282 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaHVINy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:13:54 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-c1-53f6fbbdd877
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, arnd@arndb.de,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Tomasz Figa <t.figa@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Fri, 22 Aug 2014 13:39:51 +0530
Message-id: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkVnfv72/BBjO2aFr8nXSM3WLZpLts
	Ft93fWG36F1wlc1i0+NrrBaXd81hs5hxfh+Txe3LvBafjv5ntVi0Fahi/YzXLBYdyxgtbj7b
	zuTA69HS3MPm8fvXJEaPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSujcc17loK9FhW7
	Z01iaWC8r9fFyMkhIWAiceXpf2YIW0ziwr31bF2MXBxCAksZJR7N/sEIU/Tu/jMWEFtIYDqj
	xJErMRBFE5gkjv2cygSSYBPQlXjyfi7YJBGBbIn+26vBGpgFGpgkbu9QAbGFBbwlGpedBKth
	EVCVOH31DBuIzSvgIfHyzDrWLkYOoGUKEnMm2YDMlxBYxS7xccdDqHoBiW+TD7FA1MhKbDoA
	dbSkxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREY6qf/PevbwXjzgPUh
	xmSgcROZpUST84GxklcSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGCUO2HFy/GURdp7jn7J+s/BroePH3kfGufxi75nX3u0jtW3fEyP5uRE7NpbY
	qE5MTDc0UzNOcc1c9r+4ZLKWrfuj7afZEmR0P8w+ZdVh7xJr98/l2ucZV7Qetehf4c/XvuIp
	EC7d8/D106qu+JtneWqyc96r8N36fenuvpn5/yc4TtrF71O2WYmlOCPRUIu5qDgRAN06ZR2L	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jQd29v78FG/ydImPxd9Ixdotlk+6y
	WXzf9YXdonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPls
	O5MDr0dLcw+bx+9fkxg9Ni+p9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B4
	53hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo
	+oYEwfUYGaCBhDWMGY1r3rMU7LWo2D1rEksD4329LkZODgkBE4l395+xQNhiEhfurWcDsYUE
	pjNKHLkS08XIBWRPYJI49nMqE0iCTUBX4sn7ucwgtohAtkT/7dVgzcwCDUwSt3eogNjCAt4S
	jctOgtWwCKhKnL56Bmwor4CHxMsz61i7GDmAlilIzJlkM4GRewEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4Eh6Jr2DcVWDxSFGAQ5GJR7eiC9fg4VYE8uKK3MPMUpwMCuJ8G6a9y1Y
	iDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnAKM8riTc0NjE3NTa1NLEwMbNUEuc92GodKCSQ
	nliSmp2aWpBaBNPHxMEp1cAY+1eTQ9siXcld//5G5r/TP3d/evx3RZrnur1nP+y5lqWj9+Ji
	0KPL36YtqftUl2fv+nPGpYncqn0nJC22eyxarJQyTWaruMr/HXs+BQeuUj7tMcXqsw7rgea/
	QfziywrPOwW3TZg5qTixbdW8zv7tE5p+sLD1MDQ2TI3mmO278lnMle9LD5zWVmIpzkg01GIu
	Kk4EAMP+qyq6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Currently a syscon entity can be only registered directly through a
platform device that binds to a dedicated driver. However in certain use
cases it is desirable to make a device used with another driver a syscon
interface provider. For example, certain SoCs (e.g. Exynos) contain
system controller blocks which perform various functions such as power
domain control, CPU power management, low power mode control, but in
addition contain certain IP integration glue, such as various signal
masks, coprocessor power control, etc. In such case, there is a need to
have a dedicated driver for such system controller but also share
registers with other drivers. The latter is where the syscon interface
is helpful.

This patch decouples syscon object from syscon driver, so that it can be
registered from any driver in addition to the original "syscon" platform
driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---

RFC patch [1] was posted by Tomasz Figa. This patch addresses some of
comments given by Arnd to RFC patch, and further decouples syscon from
device model. It also gives flexibility of registering with syscon at
early stage using device_node object.

[1]: https://lkml.org/lkml/2014/6/17/331

 drivers/mfd/syscon.c       |  112 ++++++++++++++++++++++++++++----------------
 include/linux/mfd/syscon.h |   14 ++++++
 2 files changed, 86 insertions(+), 40 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..a91db30 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -22,33 +23,32 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
+#include <linux/slab.h>
 
-static struct platform_driver syscon_driver;
+static DEFINE_SPINLOCK(syscon_list_slock);
+static LIST_HEAD(syscon_list);
 
 struct syscon {
+	struct device_node *np;
 	struct regmap *regmap;
+	struct list_head list;
 };
 
-static int syscon_match_node(struct device *dev, void *data)
-{
-	struct device_node *dn = data;
-
-	return (dev->of_node == dn) ? 1 : 0;
-}
-
 struct regmap *syscon_node_to_regmap(struct device_node *np)
 {
-	struct syscon *syscon;
-	struct device *dev;
+	struct syscon *entry, *syscon = NULL;
 
-	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match_node);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
+	spin_lock(&syscon_list_slock);
 
-	syscon = dev_get_drvdata(dev);
+	list_for_each_entry(entry, &syscon_list, list)
+		if (entry->np == np) {
+			syscon = entry;
+			break;
+		}
 
-	return syscon->regmap;
+	spin_unlock(&syscon_list_slock);
+
+	return syscon ? syscon->regmap : ERR_PTR(-EPROBE_DEFER);
 }
 EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
 
@@ -68,24 +68,22 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
-static int syscon_match_pdevname(struct device *dev, void *data)
-{
-	return !strcmp(dev_name(dev), (const char *)data);
-}
-
 struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
 {
-	struct device *dev;
-	struct syscon *syscon;
-
-	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
-				 syscon_match_pdevname);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
-
-	syscon = dev_get_drvdata(dev);
+	struct syscon *entry, *syscon = NULL;
+	struct platform_device *pdev = NULL;
+
+	spin_lock(&syscon_list_slock);
+	list_for_each_entry(entry, &syscon_list, list) {
+		 pdev = of_find_device_by_node(entry->np);
+		if (pdev && !strcmp(dev_name(&pdev->dev), s)) {
+			syscon = entry;
+			break;
+		}
+	}
+	spin_unlock(&syscon_list_slock);
 
-	return syscon->regmap;
+	return syscon ? syscon->regmap : ERR_PTR(-EPROBE_DEFER);
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
 
@@ -121,17 +119,49 @@ static struct regmap_config syscon_regmap_config = {
 	.reg_stride = 4,
 };
 
+void of_syscon_unregister(struct device_node *np)
+{
+	struct syscon *entry;
+
+	spin_lock(&syscon_list_slock);
+
+	list_for_each_entry(entry, &syscon_list, list)
+		if (entry->np == np) {
+			list_del(&entry->list);
+			break;
+		}
+
+	spin_unlock(&syscon_list_slock);
+}
+EXPORT_SYMBOL_GPL(of_syscon_unregister);
+
+int of_syscon_register(struct device_node *np, struct regmap *regmap)
+{
+	struct syscon *syscon;
+
+	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
+	if (!syscon)
+		return -ENOMEM;
+
+	syscon->regmap = regmap;
+	syscon->np = np;
+
+	spin_lock(&syscon_list_slock);
+	list_add_tail(&syscon->list, &syscon_list);
+	spin_unlock(&syscon_list_slock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_syscon_register);
+
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct syscon_platform_data *pdata = dev_get_platdata(dev);
-	struct syscon *syscon;
+	struct regmap *regmap;
 	struct resource *res;
 	void __iomem *base;
-
-	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
-	if (!syscon)
-		return -ENOMEM;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -144,14 +174,16 @@ static int syscon_probe(struct platform_device *pdev)
 	syscon_regmap_config.max_register = res->end - res->start - 3;
 	if (pdata)
 		syscon_regmap_config.name = pdata->label;
-	syscon->regmap = devm_regmap_init_mmio(dev, base,
+	regmap = devm_regmap_init_mmio(dev, base,
 					&syscon_regmap_config);
-	if (IS_ERR(syscon->regmap)) {
+	if (IS_ERR(regmap)) {
 		dev_err(dev, "regmap init failed\n");
-		return PTR_ERR(syscon->regmap);
+		return PTR_ERR(regmap);
 	}
 
-	platform_set_drvdata(pdev, syscon);
+	ret = of_syscon_register(dev->of_node, regmap);
+	if (ret)
+		return ret;
 
 	dev_dbg(dev, "regmap %pR registered\n", res);
 
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 75e543b..dc2807b 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -18,8 +18,12 @@
 #include <linux/err.h>
 
 struct device_node;
+struct regmap;
 
 #ifdef CONFIG_MFD_SYSCON
+extern int of_syscon_register(struct device_node *np, struct regmap *regmap);
+extern void of_syscon_unregister(struct device_node *np);
+
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
@@ -27,6 +31,16 @@ extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
 #else
+static inline int of_syscon_register(struct device_node *np,
+				       struct regmap *regmap)
+{
+	return -ENOSYS;
+}
+
+static inline void of_syscon_unregister(struct device_node *np)
+{
+}
+
 static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.7.9.5

