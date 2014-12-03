Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaLCUpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:45:03 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42994 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbaLCUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:44:34 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 10/11] ARM: at91/dt: add EBI (External Bus Interface) node in sama5d3 dtsi
Date: Wed,  3 Dec 2014 21:44:14 +0100
Message-Id: <1417639455-17410-11-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EBI node and EBI pin muxing.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index d49dab7..d011ade 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -530,6 +530,63 @@
 					};
 				};
 
+				ebi {
+					pinctrl_ebi_addr: ebi-addr-0 {
+						atmel,pins =
+							<AT91_PIOE 0 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 1 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 2 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 3 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 4 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 5 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 6 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 7 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 8 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 9 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 10 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 11 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 12 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 13 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 14 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 15 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 16 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 17 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 18 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 19 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 20 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 21 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 22 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 23 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 24 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOE 25 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ebi_cs0: ebi-cs0-0 {
+						atmel,pins =
+							<AT91_PIOE 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ebi_cs1: ebi-cs1-0 {
+						atmel,pins =
+							<AT91_PIOE 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ebi_cs2: ebi-cs2-0 {
+						atmel,pins =
+							<AT91_PIOE 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ebi_nwr1_nbs1: ebi-nwr1-nbs1-0 {
+						atmel,pins =
+							<AT91_PIOE 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ebi_nwait: ebi-nwait-0 {
+						atmel,pins =
+							<AT91_PIOE 30 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
 				i2c0 {
 					pinctrl_i2c0: i2c0-0 {
 						atmel,pins =
@@ -1407,6 +1464,32 @@
 			status = "disabled";
 		};
 
+		ebi: ebi@10000000 {
+			compatible = "atmel,sama5d3-ebi", "simple-bus";
+			#address-cells = <2>;
+			#size-cells = <1>;
+			atmel,smc = <&hsmc>;
+			atmel,matrix = <&matrix>;
+			reg = <0x10000000 0x10000000
+			       0x40000000 0x30000000>;
+			ranges = <0x0 0x0 0x10000000 0x10000000
+				  0x1 0x0 0x40000000 0x10000000
+				  0x2 0x0 0x50000000 0x10000000
+				  0x3 0x0 0x60000000 0x10000000>;
+			clocks = <&mck>;
+
+			/*
+			 * TODO: EBI pins should be referenced here, but they
+			 * conflict with NAND pins, which should actually be a
+			 * sub device of the EBI bus and thus should not
+			 * request it's own set of pins as they are shared
+			 * with other devices connected on the EBI bus.
+			 *
+			 * pinctrl-names = "default";
+			 * pinctrl-0 = <&pinctrl_ebi_addr>;
+			 */
+		};
+
 		nand0: nand@60000000 {
 			compatible = "atmel,at91rm9200-nand";
 			#address-cells = <1>;
-- 
1.9.1

