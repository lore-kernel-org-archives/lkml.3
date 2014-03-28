Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaC1KMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:12:09 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35109 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaC1KMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:12:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH trivial 3/3] ARM: dts: Grammar /that will/it will/
Date: Fri, 28 Mar 2014 11:11:39 +0100
Message-Id: <1396001499-17638-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
References: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++--
 arch/arm/boot/dts/dra7.dtsi   |    2 +-
 arch/arm/boot/dts/omap3.dtsi  |    2 +-
 arch/arm/boot/dts/omap4.dtsi  |    2 +-
 arch/arm/boot/dts/omap5.dtsi  |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 70f7f3eb5fb4..2a66fd484284 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -90,8 +90,8 @@
 
 	/*
 	 * XXX: Use a flat representation of the AM33XX interconnect.
-	 * The real AM33XX interconnect network is quite complex.Since
-	 * that will not bring real advantage to represent that in DT
+	 * The real AM33XX interconnect network is quite complex. Since
+	 * it will not bring real advantage to represent that in DT
 	 * for the moment, just use a fake OCP bus entry to represent
 	 * the whole bus hierarchy.
 	 */
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index c19e90ecf95e..9daab63fe457 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -89,7 +89,7 @@
 	/*
 	 * XXX: Use a flat representation of the SOC interconnect.
 	 * The real OMAP interconnect network is quite complex.
-	 * Since that will not bring real advantage to represent that in DT for
+	 * Since it will not bring real advantage to represent that in DT for
 	 * the moment, just use a fake OCP bus entry to represent the whole bus
 	 * hierarchy.
 	 */
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index a5fc83b9c835..5ae8141d3713 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -69,7 +69,7 @@
 	/*
 	 * XXX: Use a flat representation of the OMAP3 interconnect.
 	 * The real OMAP interconnect network is quite complex.
-	 * Since that will not bring real advantage to represent that in DT for
+	 * Since it will not bring real advantage to represent that in DT for
 	 * the moment, just use a fake OCP bus entry to represent the whole bus
 	 * hierarchy.
 	 */
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index a07ea359ae20..c95adadb0bbf 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -91,7 +91,7 @@
 	/*
 	 * XXX: Use a flat representation of the OMAP4 interconnect.
 	 * The real OMAP interconnect network is quite complex.
-	 * Since that will not bring real advantage to represent that in DT for
+	 * Since it will not bring real advantage to represent that in DT for
 	 * the moment, just use a fake OCP bus entry to represent the whole bus
 	 * hierarchy.
 	 */
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index aa9878c0aaad..0d875ba32fa9 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -101,7 +101,7 @@
 	/*
 	 * XXX: Use a flat representation of the OMAP3 interconnect.
 	 * The real OMAP interconnect network is quite complex.
-	 * Since that will not bring real advantage to represent that in DT for
+	 * Since it will not bring real advantage to represent that in DT for
 	 * the moment, just use a fake OCP bus entry to represent the whole bus
 	 * hierarchy.
 	 */
-- 
1.7.9.5

