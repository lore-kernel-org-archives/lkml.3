Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3EBKqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:46:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab3EBKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:46:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>, linux-i2c@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: sun5i: olinuxino: Enable the i2c controllers
Date: Thu,  2 May 2013 12:45:57 +0200
Message-Id: <1367491557-6027-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A13-Olinuxino makes use of the 3 i2c controllers found on the Allwinner
A13. Enable them in the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
index 3ca5506..80497e3 100644
--- a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
+++ b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
@@ -37,6 +37,24 @@
 			pinctrl-0 = <&uart1_pins_b>;
 			status = "okay";
 		};
+
+		i2c0: i2c@01c2ac00 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c0_pins_a>;
+			status = "okay";
+		};
+
+		i2c1: i2c@01c2b000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c1_pins_a>;
+			status = "okay";
+		};
+
+		i2c2: i2c@01c2b400 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c2_pins_a>;
+			status = "okay";
+		};
 	};
 
 	leds {
-- 
1.8.1.2

