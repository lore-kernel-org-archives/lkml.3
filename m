Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaG1TyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:54:04 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:46363 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaG1Txx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:53:53 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 3/3] arm: dts: Add gta04a5 model
Date: Mon, 28 Jul 2014 21:53:33 +0200
Message-Id: <1406577213-9642-4-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406577213-9642-1-git-send-email-marek@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add model a5 which have additional jack detection.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/Makefile          |  1 +
 arch/arm/boot/dts/omap3-gta04a5.dts | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04a5.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7d45fde..576c595 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -285,6 +285,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
 	omap3-evm-37xx.dtb \
 	omap3-gta04a3.dtb \
 	omap3-gta04a4.dtb \
+	omap3-gta04a5.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
 	omap3-ldp.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04a5.dts b/arch/arm/boot/dts/omap3-gta04a5.dts
new file mode 100644
index 0000000..210317c3
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04a5.dts
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2014 H. Nikolaus Schaller <hns@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "omap3-gta04.dtsi"
+
+/ {
+	model = "Goldelico GTA04A5;
+
+	sound {
+		ti,jack-det-gpio = <&twl_gpio 2 0>;    /* GTA04A5 only */
+	};
+};
-- 
1.9.1

