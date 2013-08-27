Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3H0OQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:16:30 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:51350 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3H0OQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:16:26 -0400
From: oliver+list@schinagl.nl
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, maxime.ripard@free-electrons.com,
        tomasz.figa@gmail.com, Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 2/2] Add sunxi-sid to dts for sun4i, sun5i and sun7i
Date: Tue, 27 Aug 2013 16:13:05 +0200
Message-Id: <1377612785-7868-3-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377612785-7868-1-git-send-email-oliver+list@schinagl.nl>
References: <1377612785-7868-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

This patch shall add support for the sunxi-sid driver to the device
table for sun4i, sun5i and sun7i.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 5 +++++
 arch/arm/boot/dts/sun5i-a13.dtsi | 5 +++++
 arch/arm/boot/dts/sun7i-a20.dtsi | 6 ++++++
 3 files changed, 16 insertions(+)

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
index fb81e78..bcf32b4 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -217,6 +217,12 @@
 			reg = <0x01c20c90 0x10>;
 		};
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun7i-sid";
+			reg = <0x01c23800 0x200>;
+		};
+
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
-- 
1.8.1.5

