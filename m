Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbaLLScT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:32:19 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55621 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905AbaLLScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:32:14 -0500
From: VishnuPatekar <vishnupatekar0510@gmail.com>
To: linux-input@vger.kernel.org, maxime.ripard@free-electrons.com,
        dmitry.torokhov@gmail.com, hdegoede@redhat.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        benh@kernel.crashing.org, msalter@redhat.com, ralf@linux-mips.org,
        jdelvare@suse.de, VishnuPatekar <vishnupatekar0510@gmail.com>
Subject: [PATCHv3 4/5] ARM: sunxi: dts: Add A10/A20 PS2 pin muxing options
Date: Fri, 12 Dec 2014 23:55:47 +0530
Message-Id: <1418408748-9797-5-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the pinmuxing options for Allwinner A10 and A20.

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   14 ++++++++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index ef9a01c..5a29039 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -630,6 +630,20 @@
 				allwinner,pull = <0>;
 			};
 
+			ps20_pins_a: ps20@0 {
+				    allwinner,pins = "PI20", "PI21";
+				    allwinner,function = "ps2";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				    allwinner,pins = "PH12", "PH13";
+				    allwinner,function = "ps2";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+
 		};
 
 		timer@01c20c00 {
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 6ab7714..247def0 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -867,6 +867,20 @@
 				    allwinner,pull = <0>;
 			};
 
+			ps20_pins_a: ps20@0 {
+				    allwinner,pins = "PI20", "PI21";
+				    allwinner,function = "ps2";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+
+			ps21_pins_a: ps21@0 {
+				    allwinner,pins = "PH12", "PH13";
+				    allwinner,function = "ps2";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+
 		};
 
 		timer@01c20c00 {
-- 
1.7.9.5

