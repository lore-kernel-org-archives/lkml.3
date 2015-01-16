Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbbAPOFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:05:22 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57460 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbbAPOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:05:17 -0500
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vishnu Patekar <vishnupatekar0510@gmail.com>
Subject: [PATCH v4 4/5] ARM: sunxi: dts: Add A10/A20 PS2 pin muxing options
Date: Fri, 16 Jan 2015 19:33:40 +0530
Message-Id: <1421417021-3247-5-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   14 ++++++++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 2c31242..8fade3e 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -629,6 +629,20 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			ps20_pins_a: ps20@0 {
+				allwinner,pins = "PI20", "PI21";
+				allwinner,function = "ps2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				allwinner,pins = "PH12", "PH13";
+				allwinner,function = "ps2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index f35c691..f9dd274 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -866,6 +866,20 @@
 				    allwinner,drive = <0>;
 				    allwinner,pull = <0>;
 			};
+
+			ps20_pins_a: ps20@0 {
+				allwinner,pins = "PI20", "PI21";
+				allwinner,function = "ps2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				allwinner,pins = "PH12", "PH13";
+				allwinner,function = "ps2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.7.9.5

