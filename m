Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaC1KMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:12:07 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35209 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaC1KMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:12:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH trivial 1/3] ARM: dts: Grammar /is uses/ is used/
Date: Fri, 28 Mar 2014 11:11:37 +0100
Message-Id: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/am33xx.dtsi |    2 +-
 arch/arm/boot/dts/dra7.dtsi   |    2 +-
 arch/arm/boot/dts/omap4.dtsi  |    2 +-
 arch/arm/boot/dts/omap5.dtsi  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 6d95d3df33c7..70f7f3eb5fb4 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -68,7 +68,7 @@
 	};
 
 	/*
-	 * The soc node represents the soc top level view. It is uses for IPs
+	 * The soc node represents the soc top level view. It is used for IPs
 	 * that are not memory mapped in the MPU view or for the MPU itself.
 	 */
 	soc {
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1fd75aa4639d..c19e90ecf95e 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -75,7 +75,7 @@
 	};
 
 	/*
-	 * The soc node represents the soc top level view. It is uses for IPs
+	 * The soc node represents the soc top level view. It is used for IPs
 	 * that are not memory mapped in the MPU view or for the MPU itself.
 	 */
 	soc {
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d3f8a6e8ca20..a07ea359ae20 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -67,7 +67,7 @@
 	};
 
 	/*
-	 * The soc node represents the soc top level view. It is uses for IPs
+	 * The soc node represents the soc top level view. It is used for IPs
 	 * that are not memory mapped in the MPU view or for the MPU itself.
 	 */
 	soc {
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index a72813a9663e..aa9878c0aaad 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -87,7 +87,7 @@
 	};
 
 	/*
-	 * The soc node represents the soc top level view. It is uses for IPs
+	 * The soc node represents the soc top level view. It is used for IPs
 	 * that are not memory mapped in the MPU view or for the MPU itself.
 	 */
 	soc {
-- 
1.7.9.5

