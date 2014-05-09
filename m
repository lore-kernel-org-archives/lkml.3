Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaEINoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:44:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:15566 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaEINoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:44:30 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] ARM: at91: add PWM pinctrl to SAMA5D3
Date: Fri, 9 May 2014 15:44:27 +0200
Message-ID: <a5a0a9b8090f80f40daf3a13849b3961d9d617d6.1399642907.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 82 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 9caa06b3641e..ed7943745f23 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -583,6 +583,88 @@
 					};
 				};
 
+				pwm0 {
+					pinctrl_pwm0_pwmh0_0: pwm0_pwmh0-0 {
+						atmel,pins =
+							<AT91_PIOA 20 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PA20 periph B, conflicts with ISI_D4 and LCDDAT20 */
+					};
+					pinctrl_pwm0_pwmh0_1: pwm0_pwmh0-1 {
+						atmel,pins =
+							<AT91_PIOB 0 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB0 periph B, conflicts with GTX0 */
+					};
+
+					pinctrl_pwm0_pwmh1_0: pwm0_pwmh1-0 {
+						atmel,pins =
+							<AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PA22 periph B, conflicts with ISI_D6 and LCDDAT22 */
+					};
+					pinctrl_pwm0_pwmh1_1: pwm0_pwmh1-1 {
+						atmel,pins =
+							<AT91_PIOB 4 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB4 periph B, conflicts with GRX0 */
+					};
+					pinctrl_pwm0_pwmh1_2: pwm0_pwmh1-2 {
+						atmel,pins =
+							<AT91_PIOB 27 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PB27 periph C, conflicts with G125CKO and RTS1 */
+					};
+
+					pinctrl_pwm0_pwmh2_0: pwm0_pwmh2-0 {
+						atmel,pins =
+							<AT91_PIOB 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB8 periph B, conflicts with GTXCK */
+					};
+					pinctrl_pwm0_pwmh2_1: pwm0_pwmh2-1 {
+						atmel,pins =
+							<AT91_PIOD 5 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD5 periph C, conflicts with MCI0_DA4 and TIOA0 */
+					};
+
+					pinctrl_pwm0_pwmh3_0: pwm0_pwmh3-0 {
+						atmel,pins =
+							<AT91_PIOB 12 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB12 periph B, conflicts with GRXDV */
+					};
+					pinctrl_pwm0_pwmh3_1: pwm0_pwmh3-1 {
+						atmel,pins =
+							<AT91_PIOD 7 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD7 periph C, conflicts with MCI0_DA6 and TCLK0 */
+					};
+
+					pinctrl_pwm0_pwml0_0: pwm0_pwml0-0 {
+						atmel,pins =
+							<AT91_PIOA 21 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PA21 periph B, conflicts with ISI_D5 and LCDDAT21 */
+					};
+					pinctrl_pwm0_pwml0_1: pwm0_pwml0-1 {
+						atmel,pins =
+							<AT91_PIOB 1 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB1 periph B, conflicts with GTX1 */
+					};
+
+					pinctrl_pwm0_pwml1_0: pwm0_pwml1-0 {
+						atmel,pins =
+							<AT91_PIOA 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PA23 periph B, conflicts with ISI_D7 and LCDDAT23 */
+					};
+					pinctrl_pwm0_pwml1_1: pwm0_pwml1-1 {
+						atmel,pins =
+							<AT91_PIOB 5 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB5 periph B, conflicts with GRX1 */
+					};
+					pinctrl_pwm0_pwml1_2: pwm0_pwml1-2 {
+						atmel,pins =
+							<AT91_PIOE 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PE31 periph B, conflicts with IRQ */
+					};
+
+					pinctrl_pwm0_pwml2_0: pwm0_pwml2-0 {
+						atmel,pins =
+							<AT91_PIOB 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB9 periph B, conflicts with GTXEN */
+					};
+					pinctrl_pwm0_pwml2_1: pwm0_pwml2-1 {
+						atmel,pins =
+							<AT91_PIOD 6 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD6 periph C, conflicts with MCI0_DA5 and TIOB0 */
+					};
+
+					pinctrl_pwm0_pwml3_0: pwm0_pwml3-0 {
+						atmel,pins =
+							<AT91_PIOB 13 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB13 periph B, conflicts with GRXER */
+					};
+					pinctrl_pwm0_pwml3_1: pwm0_pwml3-1 {
+						atmel,pins =
+							<AT91_PIOD 8 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD8 periph C, conflicts with MCI0_DA7 */
+					};
+				};
+
 				spi0 {
 					pinctrl_spi0: spi0-0 {
 						atmel,pins =
-- 
1.8.2.2

