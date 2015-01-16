Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbbAPOFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:05:30 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34805 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbbAPOFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:05:25 -0500
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vishnu Patekar <vishnupatekar0510@gmail.com>
Subject: [PATCH v4 5/5] ARM: sunxi: dts: Add PS2 nodes for A20 lime2 board
Date: Fri, 16 Jan 2015 19:33:41 +0530
Message-Id: <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
index ed364d5..3365f12 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
@@ -113,6 +113,18 @@
 			status = "okay";
 		};
 
+		ps20: ps2@01c2a000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ps20_pins_a>;
+			status = "okay";
+		};
+
+		ps21: ps2@01c2a400 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ps21_pins_a>;
+			status = "okay";
+		};
+
 		i2c0: i2c@01c2ac00 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c0_pins_a>;
-- 
1.7.9.5

