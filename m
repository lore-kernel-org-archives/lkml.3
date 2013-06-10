Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3FJJHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:07:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46928 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab3FJJHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:07:13 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <b-cousson@ti.com>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>, <swarren@nvidia.com>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <lee.jones@linaro.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
Date: Mon, 10 Jun 2013 14:34:18 +0530
Message-ID: <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1370855059-5342-1-git-send-email-j-keerthy@ti.com>
References: <1370855059-5342-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds palmas mfd and palmas regulator nodes.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/palmas.dtsi |   98 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/palmas.dtsi

diff --git a/arch/arm/boot/dts/palmas.dtsi b/arch/arm/boot/dts/palmas.dtsi
new file mode 100644
index 0000000..4c5162f
--- /dev/null
+++ b/arch/arm/boot/dts/palmas.dtsi
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+&palmas {
+	compatible = "ti,palmas";
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	palmas_pmic {
+		compatible = "ti,palmas-pmic";
+		interrupt-parent = <&palmas>;
+		interrupts = <14 IRQ_TYPE_NONE>;
+		interrupt-name = "short-irq";
+
+		ti,ldo6-vibrator;
+
+		regulators {
+			smps123_reg: smps123 {
+				regulator-name = "smps123";
+			};
+
+			smps45_reg: smps45 {
+				regulator-name = "smps45";
+			};
+
+			smps6_reg: smps6 {
+				regulator-name = "smps6";
+			};
+
+			smps7_reg: smps7 {
+				regulator-name = "smps7";
+			};
+
+			smps8_reg: smps8 {
+				regulator-name = "smps8";
+			};
+
+			smps9_reg: smps9 {
+				regulator-name = "smps9";
+			};
+
+			smps10_reg: smps10 {
+				regulator-name = "smps10";
+			};
+
+			ldo1_reg: ldo1 {
+				regulator-name = "ldo1";
+			};
+
+			ldo2_reg: ldo2 {
+				regulator-name = "ldo2";
+			};
+
+			ldo3_reg: ldo3 {
+				regulator-name = "ldo3";
+			};
+
+			ldo4_reg: ldo4 {
+				regulator-name = "ldo4";
+			};
+
+			ldo5_reg: ldo5 {
+				regulator-name = "ldo5";
+			};
+
+			ldo6_reg: ldo6 {
+				regulator-name = "ldo6";
+			};
+
+			ldo7_reg: ldo7 {
+				regulator-name = "ldo7";
+			};
+
+			ldo8_reg: ldo8 {
+				regulator-name = "ldo8";
+			};
+
+			ldo9_reg: ldo9 {
+				regulator-name = "ldo9";
+			};
+
+			ldoln_reg: ldoln {
+				regulator-name = "ldoln";
+			};
+
+			ldousb_reg: ldousb {
+				regulator-name = "ldousb";
+			};
+		};
+	};
+};
-- 
1.7.5.4

