Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaKWRUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:20:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaKWRUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:20:42 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?q?=EA=B9=80=ED=95=99=EC=A3=BC?= <ruppi.kim@hardkernel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH v3 4/5] ARM: dts: add pinctrl support to Exynos5410
Date: Sun, 23 Nov 2014 18:20:32 +0100
Message-Id: <1416763234-3249-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <547216FE.3010900@suse.de>
References: <547216FE.3010900@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakjoo Kim <ruppi.kim@hardkernel.com>

Add the required pin configuration support to Exynos5410 using pinctrl
interface.

Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
[AF: Rebased, style changes]
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2 -> v3:
 * Added wake-up IRQ controller node (Tomasz Figa)
 
 v1 -> v2:
 * Filled in Sob from Hakjoo Kim
 
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi | 406 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         |  36 +++
 2 files changed, 442 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-pinctrl.dtsi

diff --git a/arch/arm/boot/dts/exynos5410-pinctrl.dtsi b/arch/arm/boot/dts/exynos5410-pinctrl.dtsi
new file mode 100644
index 000000000000..f9aa6bb55464
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-pinctrl.dtsi
@@ -0,0 +1,406 @@
+/*
+ * Exynos5410 SoC pin-mux and pin-config device tree source
+ *
+ * Copyright (c) 2013 Hardkernel Co., Ltd.
+ *              http://www.hardkernel.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+&pinctrl_0 {
+	gpa0: gpa0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpa1: gpa1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpa2: gpa2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb0: gpb0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb1: gpb1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb2: gpb2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb3: gpb3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc0: gpc0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc3: gpc3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc1: gpc1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc2: gpc2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm5: gpm5 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpd1: gpd1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpe0: gpe0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpe1: gpe1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf1: gpf1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg0: gpg0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg1: gpg1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg2: gpg2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gph0: gph0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gph1: gph1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm7: gpm7 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy0: gpy0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy1: gpy1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy2: gpy2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy3: gpy3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy4: gpy4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy5: gpy5 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy6: gpy6 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpy7: gpy7 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpx0: gpx0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&combiner>;
+		#interrupt-cells = <2>;
+		interrupts = <23 0>,
+		             <24 0>,
+		             <25 0>,
+		             <25 1>,
+		             <26 0>,
+		             <26 1>,
+		             <27 0>,
+		             <27 1>;
+	};
+
+	gpx1: gpx1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		interrupt-parent = <&combiner>;
+		#interrupt-cells = <2>;
+		interrupts = <28 0>,
+		             <28 1>,
+		             <29 0>,
+		             <29 1>,
+		             <30 0>,
+		             <30 1>,
+		             <31 0>,
+		             <31 1>;
+	};
+
+	gpx2: gpx2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpx3: gpx3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_1 {
+	gpj0: gpj0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj1: gpj1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj2: gpj2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj3: gpj3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj4: gpj4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk0: gpk0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk1: gpk1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk2: gpk2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpk3: gpk3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_2 {
+	gpv0: gpv0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpv1: gpv1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpv2: gpv2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpv3: gpv3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpv4: gpv4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
+&pinctrl_3 {
+	gpz: gpz {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index 731eefd23fa9..460335606466 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -21,6 +21,10 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
+		pinctrl0 = &pinctrl_0;
+		pinctrl1 = &pinctrl_1;
+		pinctrl2 = &pinctrl_2;
+		pinctrl3 = &pinctrl_3;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
@@ -218,4 +222,36 @@
 			status = "disabled";
 		};
 	};
+
+	pinctrl_0: pinctrl@13400000 {
+		compatible = "samsung,exynos5410-pinctrl";
+		reg = <0x13400000 0x1000>;
+		interrupts = <0 45 0>;
+
+		wakeup-interrupt-controller {
+			compatible = "samsung,exynos4210-wakeup-eint";
+			interrupt-parent = <&gic>;
+			interrupts = <0 32 0>;
+		};
+	};
+
+	pinctrl_1: pinctrl@14000000 {
+		compatible = "samsung,exynos5410-pinctrl";
+		reg = <0x14000000 0x1000>;
+		interrupts = <0 46 0>;
+	};
+
+	pinctrl_2: pinctrl@10d10000 {
+		compatible = "samsung,exynos5410-pinctrl";
+		reg = <0x10d10000 0x1000>;
+		interrupts = <0 50 0>;
+	};
+
+	pinctrl_3: pinctrl@03860000 {
+		compatible = "samsung,exynos5410-pinctrl";
+		reg = <0x03860000 0x1000>;
+		interrupts = <0 47 0>;
+	};
 };
+
+#include "exynos5410-pinctrl.dtsi"
-- 
2.1.2

