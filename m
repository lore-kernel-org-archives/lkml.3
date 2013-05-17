Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3EQNoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:44:07 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:40091 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab3EQNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:44:04 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@ardb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 2/2] Add sunxi-sid to dts for sun4i and sun5i
Date: Fri, 17 May 2013 15:35:44 +0200
Message-Id: <1368797744-13737-3-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
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
index e7ef619..1043db2 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -163,6 +163,11 @@
 		reg = <0x01c20000 0x300000>;
 		ranges;
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun4i-sid";
+			reg = <0x01c23800 0x10>;
+		};
+
 		intc: interrupt-controller@01c20400 {
 			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 8ba65c1..f715132 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -153,6 +153,11 @@
 		reg = <0x01c20000 0x300000>;
 		ranges;
 
+		sid: eeprom@01c23800 {
+			compatible = "allwinner,sun4i-sid";
+			reg = <0x01c23800 0x10>;
+		};
+
 		intc: interrupt-controller@01c20400 {
 			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
-- 
1.8.1.5

