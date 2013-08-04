Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3HDJez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:34:55 -0400
Received: from up.free-electrons.com ([94.23.35.102]:36872 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285Ab3HDJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:34:17 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/6] ARM: sun5i: dt: Fix A10s SoC bus base address
Date: Sun,  4 Aug 2013 11:34:02 +0200
Message-Id: <1375608844-13159-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375608844-13159-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375608844-13159-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a typo in the base address used for the soc node in the A10s
device tree. Fix it with the proper base address.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
index 24dd8bb..3c9f8b3 100644
--- a/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
@@ -18,7 +18,7 @@
 	model = "Olimex A10s-Olinuxino Micro";
 	compatible = "olimex,a10s-olinuxino-micro", "allwinner,sun5i-a10s";
 
-	soc@01c20000 {
+	soc@01c00000 {
 		emac: ethernet@01c0b000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&emac_pins_a>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index ec6c2b6..ee0ff9b 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -157,7 +157,7 @@
 		};
 	};
 
-	soc@01c20000 {
+	soc@01c00000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.8.3.4

