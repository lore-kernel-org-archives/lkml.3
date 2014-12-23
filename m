Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaLWNEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:04:34 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:62325 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaLWNEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:04:33 -0500
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Walter Lozano <walter@vanguardiasur.com.ar>
Subject: [PATCH] ARM: socfpga: dts: Add adxl34x
Date: Tue, 23 Dec 2014 10:04:22 -0300
Message-Id: <1419339862-29852-1-git-send-email-walter@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DTS bindings for the adxl34x digital
accelerometer.

Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
---
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
index 16ea6f5..f99d7dec 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
@@ -68,3 +68,20 @@
 &usb1 {
 	status = "okay";
 };
+
+&gpio2 {
+	status = "okay";
+};
+
+&i2c1{
+	status = "okay";
+
+	accel1: accel1@53{
+		compatible = "adxl34x";
+		reg = <0x53>;
+
+		interrupt-parent = < &portc >;
+		interrupts = <3 2>;
+
+	};
+};
-- 
1.7.10.4

