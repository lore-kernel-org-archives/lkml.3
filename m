Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab3FBPAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 11:00:54 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:37185 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3FBPAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 11:00:24 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 2/2] Add sunxi-sid to dts for sun4i and sun5i
Date: Sun,  2 Jun 2013 16:58:50 +0200
Message-Id: <1370185130-15332-3-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

This should add support for the sunxi-sid driver to the device table for sun4i and sun5i

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 5 +++++
 arch/arm/boot/dts/sun5i-a13.dtsi | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index e7ef619..bc71d64 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -213,6 +213,11 @@
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
index 8ba65c1..c80c81b 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -196,6 +196,11 @@
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
-- 
1.8.1.5

