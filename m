Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994Ab3ECJSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:18:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761678Ab3ECJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:18:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>, linux-i2c@vger.kernel.org,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: sun5i: olinuxino: Enable the i2c controllers
Date: Fri,  3 May 2013 11:17:49 +0200
Message-Id: <1367572669-24354-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367572669-24354-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367572669-24354-1-git-send-email-maxime.ripard@free-electrons.com>
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

