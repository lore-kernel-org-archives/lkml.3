Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaCLSJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:09:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56573 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbaCLSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:08:06 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [PATCH v3 8/9] ARM: dt/sunxi: add A20 NAND controller pin definitions
Date: Wed, 12 Mar 2014 19:07:43 +0100
Message-Id: <1394647664-8258-9-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the NAND controller pin configs.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi |   80 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 4c14ed8..c8095c5 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -443,6 +443,86 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			nand_pins_a: nand_base0@0 {
+				allwinner,pins = "PC0", "PC1", "PC2",
+						"PC5", "PC8", "PC9", "PC10",
+						"PC11", "PC12", "PC13", "PC14",
+						"PC15", "PC16";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs0_pins_a: nand_cs@0 {
+				allwinner,pins = "PC4";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs1_pins_a: nand_cs@1 {
+				allwinner,pins = "PC3";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs2_pins_a: nand_cs@2 {
+				allwinner,pins = "PC17";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs3_pins_a: nand_cs@3 {
+				allwinner,pins = "PC18";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs4_pins_a: nand_cs@4 {
+				allwinner,pins = "PC19";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs5_pins_a: nand_cs@5 {
+				allwinner,pins = "PC20";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs6_pins_a: nand_cs@6 {
+				allwinner,pins = "PC21";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_cs7_pins_a: nand_cs@7 {
+				allwinner,pins = "PC22";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_rb0_pins_a: nand_rb@0 {
+				allwinner,pins = "PC6";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			nand_rb1_pins_a: nand_rb@1 {
+				allwinner,pins = "PC7";
+				allwinner,function = "nand0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.7.9.5

