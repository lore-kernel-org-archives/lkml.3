Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaG1Txy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:53:54 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54652 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG1Txu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:53:50 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/3] arm: dts: omap3-gta04: Rename gta04.dts to gta04.dtsi and add a4 model
Date: Mon, 28 Jul 2014 21:53:31 +0200
Message-Id: <1406577213-9642-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406577213-9642-1-git-send-email-marek@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation of adding more boards which have common moved
to omap3-gta04.dtsi. Other boards have only small additions to omap3-gta04a4.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/Makefile                              |  2 +-
 arch/arm/boot/dts/{omap3-gta04.dts => omap3-gta04.dtsi} |  0
 arch/arm/boot/dts/omap3-gta04a4.dts                     | 13 +++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)
 rename arch/arm/boot/dts/{omap3-gta04.dts => omap3-gta04.dtsi} (100%)
 create mode 100644 arch/arm/boot/dts/omap3-gta04a4.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 82f498b..3dc9d44 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -283,7 +283,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
 	omap3-devkit8000.dtb \
 	omap3-evm.dtb \
 	omap3-evm-37xx.dtb \
-	omap3-gta04.dtb \
+	omap3-gta04a4.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
 	omap3-ldp.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dtsi
similarity index 100%
rename from arch/arm/boot/dts/omap3-gta04.dts
rename to arch/arm/boot/dts/omap3-gta04.dtsi
diff --git a/arch/arm/boot/dts/omap3-gta04a4.dts b/arch/arm/boot/dts/omap3-gta04a4.dts
new file mode 100644
index 0000000..c918bb1
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04a4.dts
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2014 Marek Belisko <marek@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "omap3-gta04.dtsi"
+
+/ {
+	model = "Goldelico GTA04A4";
+};
-- 
1.9.1

