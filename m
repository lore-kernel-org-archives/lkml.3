Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3ICKhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:37:15 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:39047 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab3ICKhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:37:12 -0400
From: oliver+list@schinagl.nl
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        maxime.ripard@free-electrons.com, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCHv7 2/2] ARM: sunxi: dt: Add sunxi-sid to dts for sun4i, sun5i and sun7i
Date: Tue,  3 Sep 2013 12:33:28 +0200
Message-Id: <1378204408-1415-3-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
References: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

This patch shall add support for the sunxi-sid driver to the device
tree for A10, A10s, A13 and A20.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 arch/arm/boot/dts/sun4i-a10.dtsi  | 5 +++++
 arch/arm/boot/dts/sun5i-a10s.dtsi | 5 +++++
 arch/arm/boot/dts/sun5i-a13.dtsi  | 5 +++++
 arch/arm/boot/dts/sun7i-a20.dtsi  | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index b2bd6e1..179e024 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -267,6 +267,11 @@
 			reg = <0x01c20c90 0x10>;
 		};
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun4i-sid";
+			reg = <0x01c23800 0x10>;
+		};
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index b8fc1c2..724285cc 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -256,6 +256,11 @@
 			reg = <0x01c20c90 0x10>;
 		};
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun4i-sid";
+			reg = <0x01c23800 0x10>;
+		};
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 7363211..999fdb3 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -223,6 +223,11 @@
 			reg = <0x01c20c90 0x10>;
 		};
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun4i-sid";
+			reg = <0x01c23800 0x10>;
+		};
+
 		uart1: serial@01c28400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28400 0x400>;
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index fb81e78..ff3cc90 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -217,6 +217,11 @@
 			reg = <0x01c20c90 0x10>;
 		};
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun7i-a20-sid";
+			reg = <0x01c23800 0x200>;
+		};
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
-- 
1.8.1.5

