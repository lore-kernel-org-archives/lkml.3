Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaCQMoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:44:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32172 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205AbaCQMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:43:57 -0400
X-AuditID: cbfee68f-b7f156d00000276c-8b-5326ee0b5f9f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 2/4] charger-manager: Get power_supply device using
 of_power_supply_get_dev()
Date: Mon, 17 Mar 2014 21:43:45 +0900
Message-id: <1395060227-23378-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkUJf7nVqwQftvUYvrX56zWkx68p7Z
	YuLKycwWZ5vesFtc3jWHzeJ24wo2BzaPnbPusntsXqHl0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBknD+1jLmgSr5j05DNLA+N64S5GTg4JAROJvWcXskHYYhIX7q0Hsrk4hASWMkpM7njB
	ClP05vtnqMR0Rol1b9+yQziNTBLr1m4Bq2IT0JLY/+IG2CgRAV2Jmz2X2UFsZoFaiX3XmsBq
	hAWSJT6//8IEYrMIqEocWNfBAmLzCrhK3Dq0jBlim5zEhz2PwHo5BdwkLu+cBhYXAqpZ/XQx
	O0RNO7vE/iUKEHMEJL5NPgQ0hwMoLiux6QDUGEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIzCgT/971r+D8e4B60OMyUDjJjJLiSbnAyMiryTe0NjMyMLUxNTYyNzS
	jDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwLtulUdwiuab9mO78zt7SoPYJ
	l1Peu6kGzBHem9LKorTbYE7gmYNWD5vu+jsmlwsmnpv8K+V06/Lf3yW2Hjr4ZG4Jv8+fSxF1
	z20jQu+ltFkez5QzfCZ5/aPhXj5rk85w280VO7wFn81an8XUdGyVV8MJRe3mt56fKj6ee/Bo
	x3dDr4ZcFaUwJZbijERDLeai4kQA3K5VT34CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQV3ud2rBBuva+Cyuf3nOajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmnDy0j7mgSbxi0pPPLA2M64W7GDk5JARMJN58
	/8wGYYtJXLi3Hsjm4hASmM4ose7tW3YIp5FJYt3aLawgVWwCWhL7X9wA6xAR0JW42XOZHcRm
	FqiV2HetCaxGWCBZ4vP7L0wgNouAqsSBdR0sIDavgKvErUPLmCG2yUl82PMIrJdTwE3i8s5p
	YHEhoJrVTxezT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOGKeSe9gXNVgcYhR
	gINRiYd3grJasBBrYllxZe4hRgkOZiURXq23QCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3O
	B0ZzXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwcugf3990
	btNvj3MXLRY0b6/+t2XDE47PBr+sFz2/wd63P2vGrcTemjyXthfdMjceHPxn+1A47K6KrVbi
	opyvjj8aGoXYNEvu+LZKX/nT+GNr3uvThxTDb30X/vrlvtS5vdNuXf7Io7R8mzPfInX7/Y2Z
	01pEFVfcfrvkbKbkdOuGUzUK3w3MGZRYijMSDbWYi4oTAU/keoPcAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use of_power_supply_get_dev() dt funtion to get power_supply device
instead of legacy method. This patch get direclty the instance of power supply
device from dt.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
---
 drivers/power/charger-manager.c       | 22 ++++++++++++++++------
 include/linux/power/charger-manager.h |  2 ++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..a5bb9ae 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include <linux/power/charger-manager.h>
+#include <linux/power/of_power_supply.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>
@@ -1584,7 +1585,12 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 		}
 	}
 
-	of_property_read_string(np, "cm-fuel-gauge", &desc->psy_fuel_gauge);
+	desc->fuel_gauge = of_power_supply_get_dev(dev,
+						POWER_SUPPLY_DEV_FUELGAUGE, 0);
+	if (IS_ERR_OR_NULL(desc->fuel_gauge)) {
+		dev_err(dev, "Failed to get device instance of fuel-gague\n");
+		return ERR_PTR(-ENODEV);
+	}
 
 	of_property_read_string(np, "cm-thermal-zone", &desc->thermal_zone);
 
@@ -1739,11 +1745,15 @@ static int charger_manager_probe(struct platform_device *pdev)
 		}
 	}
 
-	cm->fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
-	if (!cm->fuel_gauge) {
-		dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
-			desc->psy_fuel_gauge);
-		return -ENODEV;
+	if (desc->fuel_gauge) {
+		cm->fuel_gauge = desc->fuel_gauge;
+	} else {
+		cm->fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
+		if (!cm->fuel_gauge) {
+			dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
+					desc->psy_fuel_gauge);
+			return -ENODEV;
+		}
 	}
 
 	if (desc->polling_interval_ms == 0 ||
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 07e7945..92cc47a 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -175,6 +175,7 @@ struct charger_regulator {
  * @num_charger_regulator: the number of entries in charger_regulators
  * @charger_regulators: array of charger regulators
  * @psy_fuel_gauge: the name of power-supply for fuel gauge
+ * @fuel_gauge: power_supply device for fuel gauge
  * @thermal_zone : the name of thermal zone for battery
  * @temp_min : Minimum battery temperature for charging.
  * @temp_max : Maximum battery temperature for charging.
@@ -210,6 +211,7 @@ struct charger_desc {
 	struct charger_regulator *charger_regulators;
 
 	const char *psy_fuel_gauge;
+	struct power_supply *fuel_gauge;
 
 	const char *thermal_zone;
 
-- 
1.8.0

