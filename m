Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbbAYNlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:41:49 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51032 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbbAYNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:41:45 -0500
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vishnu Patekar <vishnupatekar0510@gmail.com>
Subject: [PATCH v5 4/4] ARM: sunxi: dts: Add A10/A20 PS2 pin muxing options
Date: Sun, 25 Jan 2015 19:10:09 +0530
Message-Id: <1422193209-17787-5-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422193209-17787-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1422193209-17787-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   14 ++++++++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 134100b..5536b01 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -769,6 +769,20 @@
 				allwinner,drive = <SUN4I_PINCTRL_10_MA>;
 				allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
 			};
+
+			ps20_pins_a: ps20@0 {
+				allwinner,pins = "PI20", "PI21";
+				allwinner,function = "ps2";
+				allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+				allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				allwinner,pins = "PH12", "PH13";
+				allwinner,function = "ps2";
+				allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+				allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+			};
 		};
 
 		timer@01c20c00 {
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index d7fc31f..f011203 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -973,6 +973,20 @@
 				    allwinner,drive = <SUN4I_PINCTRL_10_MA>;
 				    allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
 			};
+
+			ps20_pins_a: ps20@0 {
+				allwinner,pins = "PI20", "PI21";
+				allwinner,function = "ps2";
+				allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+				allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				allwinner,pins = "PH12", "PH13";
+				allwinner,function = "ps2";
+				allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+				allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.7.9.5

