Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3EaUwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:52:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60525 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3EaUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:52:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <b.brezillon@overkiz.com>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>, <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] ARM: at91/dt: add pinctrl definition for at91 tc blocks
Date: Fri, 31 May 2013 22:52:37 +0200
Message-ID: <1370033557-17114-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1369389956-30466-1-git-send-email-b.brezillon@overkiz.com>
References: <1369389956-30466-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

This patch adds pinctrl configurations for at91 Timer Counter blocks.
These pin definitions can be referenced by "atmel,tcb-pwm" devices to
setup pins as PWM output for instance.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
[nicolas.ferre@atmel.com: switch to pinctrl pre-processor macros]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Boris,

Here is your patch modified with pinctrl macros used.
I plan to stack it on top of our at91-3.11-dt branch now.

Thanks and best regards,

Nicolas Ferre

 arch/arm/boot/dts/at91rm9200.dtsi  | 76 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi | 76 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi | 38 +++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi | 76 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi | 76 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 76 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 418 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 4aad0d9..b91cf78 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -398,6 +398,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOA 13 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOA 14 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOA 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOA 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOA 21 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOA 20 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <AT91_PIOA 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <AT91_PIOA 28 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <AT91_PIOA 29 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <AT91_PIOB 6 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <AT91_PIOB 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <AT91_PIOB 10 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <AT91_PIOB 7 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <AT91_PIOB 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <AT91_PIOB 11 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index de571d9..899a7cf 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -355,6 +355,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOB 6 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOB 7 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOC 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <AT91_PIOB 16 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <AT91_PIOB 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <AT91_PIOB 0 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <AT91_PIOB 2 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <AT91_PIOB 3 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <AT91_PIOB 1 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <AT91_PIOB 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index d9cf51a..ff63811 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -324,6 +324,44 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOB 28 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOE 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOE 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOB 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOE 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOE 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOB 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index f0091af..faec17d 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -344,6 +344,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOD 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOD 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOC 10 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOD 20 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOD 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOD 22 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOD 30 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOD 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOA 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <AT91_PIOA 0 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <AT91_PIOA 3 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <AT91_PIOD 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <AT91_PIOA 1 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <AT91_PIOA 4 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <AT91_PIOD 7 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <AT91_PIOA 2 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <AT91_PIOA 5 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <AT91_PIOD 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index d12da33..3166e1d 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -285,6 +285,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOA 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOA 22 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOA 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <AT91_PIOC 4 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <AT91_PIOC 7 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <AT91_PIOC 2 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <AT91_PIOC 5 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <AT91_PIOC 3 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <AT91_PIOC 6 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 5635064..e77106e 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -414,6 +414,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <AT91_PIOA 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <AT91_PIOA 22 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <AT91_PIOA 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <AT91_PIOC 4 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <AT91_PIOC 7 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <AT91_PIOC 2 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <AT91_PIOC 5 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <AT91_PIOC 3 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <AT91_PIOC 6 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-- 
1.8.0

