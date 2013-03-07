Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3CGDhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:37:50 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:57355 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263Ab3CGDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:37:49 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 14/16] ARM: dts: add spi nodes for atmel SoC
Date: Thu, 7 Mar 2013 11:35:00 +0800
Message-ID: <1362627300-9479-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: add spi nodes for sam9260, sam9263, sam9g45 and sam9n12]
[wenyou.yang@atmel.com: remove spi property "cs-gpios" to the board dts files]
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9260.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |   18 ++++++++++++++++++
 5 files changed, 90 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index cb7bcc5..6e31dc8 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -471,6 +471,24 @@
 				status = "disabled";
 			};
 
+			spi0: spi@fffc8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffc8000 0x200>;
+				interrupts = <12 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffcc000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffcc000 0x200>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
 			adc0: adc@fffe0000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 271d4de..6c6d9ae 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -462,6 +462,24 @@
 				reg = <0xfffffd40 0x10>;
 				status = "disabled";
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 6b1d4ca..e085b8a 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -531,6 +531,24 @@
 				reg = <0xfffffd40 0x10>;
 				status = "disabled";
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 7750f98..f3f87ef3 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -373,6 +373,24 @@
 				#size-cells = <0>;
 				status = "disabled";
 			};
+
+			spi0: spi@f0000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xf0000000 0x100>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index aa98e64..83a4889 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -505,6 +505,24 @@
 					trigger-value = <0x6>;
 				};
 			};
+
+			spi0: spi@f0000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xf0000000 0x100>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91rm9200-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

