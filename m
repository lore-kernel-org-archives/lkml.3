Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaG3MSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:18:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36811 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 74/94] ARM: dts: imx: Add alias for ethernet controller
Date: Wed, 30 Jul 2014 14:15:03 +0200
Message-Id: <67aa6a14db5db52cb96380f037de1b56cd8a938c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marex@denx.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 22970070e027cbbb9b2878f8f7c31d0d7f29e94d upstream.

Add alias for FEC ethernet on i.MX to allow bootloaders (like U-Boot)
patch-in the MAC address for FEC using this alias.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/imx25.dtsi | 1 +
 arch/arm/boot/dts/imx27.dtsi | 1 +
 arch/arm/boot/dts/imx51.dtsi | 1 +
 arch/arm/boot/dts/imx53.dtsi | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index 737ed5da8f71..de1611966d8b 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -30,6 +30,7 @@
 		spi2 = &spi3;
 		usb0 = &usbotg;
 		usb1 = &usbhost1;
+		ethernet0 = &fec;
 	};
 
 	cpus {
diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index b7a1c6d950b9..c07aea4f66cb 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -30,6 +30,7 @@
 		spi0 = &cspi1;
 		spi1 = &cspi2;
 		spi2 = &cspi3;
+		ethernet0 = &fec;
 	};
 
 	aitc: aitc-interrupt-controller@e0000000 {
diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index 54cee6517902..6d2a5343691f 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -27,6 +27,7 @@
 		spi0 = &ecspi1;
 		spi1 = &ecspi2;
 		spi2 = &cspi;
+		ethernet0 = &fec;
 	};
 
 	tzic: tz-interrupt-controller@e0000000 {
diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index dc72353de0b3..50eda500f39a 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -33,6 +33,7 @@
 		spi0 = &ecspi1;
 		spi1 = &ecspi2;
 		spi2 = &cspi;
+		ethernet0 = &fec;
 	};
 
 	cpus {
-- 
2.0.1

