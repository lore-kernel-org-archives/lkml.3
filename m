Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330Ab3EXKGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:06:02 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:43216 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760011Ab3EXKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:06:00 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] ARM: at91/dt: add pinctrl definition for at91 tc blocks
Date: Fri, 24 May 2013 12:05:56 +0200
Message-Id: <1369389956-30466-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 4336684966775796943
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch adds pinctrl configs for at91 Timer Conter blocks.
These pin configs will be referenced by "atmel,tcb-pwm" devices to
setup pins as PWM output.

Best Regards,

Boris

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi  |   76 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi |   76 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi |   38 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |   76 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |   76 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |   76 ++++++++++++++++++++++++++++++++++++
 6 files changed, 418 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 5d3ed5a..a90ec44 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -391,6 +391,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <0 13 0x2 0x0>;	/* PA13 periph B */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <0 14 0x2 0x0>;	/* PA14 periph B */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <0 15 0x2 0x0>;	/* PA15 periph B */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <0 17 0x2 0x0>;	/* PA17 periph B */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <0 19 0x2 0x0>;	/* PA19 periph B */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <0 21 0x2 0x0>;	/* PA21 periph B */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <0 18 0x2 0x0>;	/* PA18 periph B */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <0 20 0x2 0x0>;	/* PA20 periph B */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <0 22 0x2 0x0>;	/* PA22 periph B */
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <0 27 0x2 0x0>;	/* PA27 periph B */
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <0 28 0x2 0x0>;	/* PA28 periph B */
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <0 29 0x2 0x0>;	/* PA29 periph B */
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <1 6 0x2 0x0>;	/* PB6 periph B */
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <1 8 0x2 0x0>;	/* PB8 periph B */
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <1 10 0x2 0x0>;	/* PB10 periph B */
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <1 7 0x2 0x0>;	/* PB7 periph B */
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <1 9 0x2 0x0>;	/* PB9 periph B */
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <1 11 0x2 0x0>;	/* PB11 periph B */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 70b5ccb..b2665b1 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -340,6 +340,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <0 25 0x1 0x0>;	/* PA25 periph A */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <1 6 0x2 0x0>;	/* PB6 periph B */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <1 7 0x2 0x0>;	/* PB7 periph B */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <0 26 0x1 0x0>;	/* PA26 periph A */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <0 27 0x1 0x0>;	/* PA27 periph A */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <0 28 0x1 0x0>;	/* PA28 periph A */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <2 9 0x2 0x0>;	/* PC9 periph B */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <2 7 0x1 0x0>;	/* PC7 periph A */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <2 6 0x1 0x0>;	/* PC6 periph A */
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <1 16 0x2 0x0>;	/* PB16 periph B */
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <1 17 0x2 0x0>;	/* PB17 periph B */
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <2 22 0x2 0x0>;	/* PC22 periph B */
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <1 0 0x2 0x0>;	/* PB0 periph B */
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <1 2 0x2 0x0>;	/* PB2 periph B */
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <1 3 0x2 0x0>;	/* PB3 periph B */
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <1 1 0x2 0x0>;	/* PB1 periph B */
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <1 18 0x2 0x0>;	/* PB18 periph B */
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <1 19 0x2 0x0>;	/* PB19 periph B */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 94b58ab..82d2609 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -321,6 +321,44 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <1 28 0x2 0x0>;	/* PB28 periph B */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <2 28 0x2 0x0>;	/* PC28 periph B */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <0 15 0x1 0x0>;	/* PA15 periph A */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <4 18 0x2 0x0>;	/* PE18 periph B */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <4 8 0x2 0x0>;	/* PE8 periph B */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <1 17 0x2 0x0>;	/* PB17 periph B */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <4 19 0x2 0x0>;	/* PE19 periph B */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <4 9 0x2 0x0>;	/* PE9 periph B */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <1 18 0x2 0x0>;	/* PB18 periph B */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index bf18a73..6ae0089 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -341,6 +341,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <3 23 0x1 0x0>;	/* PD23 periph A */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <3 29 0x1 0x0>;	/* PD29 periph A */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <2 10 0x2 0x0>;	/* PC10 periph B */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <3 20 0x1 0x0>;	/* PD20 periph A */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <3 21 0x1 0x0>;	/* PD21 periph A */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <3 22 0x1 0x0>;	/* PD22 periph A */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <3 30 0x1 0x0>;	/* PD30 periph A */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <3 31 0x1 0x0>;	/* PD31 periph A */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <0 26 0x2 0x0>;	/* PA26 periph B */
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <0 0 0x2 0x0>;	/* PA0 periph B */
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <0 3 0x2 0x0>;	/* PA3 periph B */
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <3 9 0x2 0x0>;	/* PD9 periph B */
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <0 1 0x2 0x0>;	/* PA1 periph B */
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <0 4 0x2 0x0>;	/* PA4 periph B */
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <3 7 0x2 0x0>;	/* PD7 periph B */
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <0 2 0x2 0x0>;	/* PA2 periph B */
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <0 5 0x2 0x0>;	/* PA5 periph B */
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <3 8 0x2 0x0>;	/* PD8 periph B */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 3de8e6d..c3ba293 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -282,6 +282,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <0 24 0x1 0x0>;	/* PA24 periph A */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <0 25 0x1 0x0>;	/* PA25 periph A */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <0 26 0x1 0x0>;	/* PA26 periph A */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <0 21 0x1 0x0>;	/* PA21 periph A */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <0 22 0x1 0x0>;	/* PA22 periph A */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <0 23 0x1 0x0>;	/* PA23 periph A */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <0 27 0x1 0x0>;	/* PA27 periph A */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <0 28 0x1 0x0>;	/* PA28 periph A */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <0 29 0x1 0x0>;	/* PA29 periph A */
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <2 4 0x3 0x0>;	/* PC4 periph C */
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <2 7 0x3 0x0>;	/* PC7 periph C */
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <2 14 0x3 0x0>;	/* PC14 periph C */
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <2 2 0x3 0x0>;	/* PC2 periph C */
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <2 5 0x3 0x0>;	/* PC5 periph C */
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <2 12 0x3 0x0>;	/* PC12 periph C */
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <2 3 0x3 0x0>;	/* PC3 periph C */
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <2 6 0x3 0x0>;	/* PC6 periph C */
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <2 13 0x3 0x0>;	/* PC13 periph C */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 1145ac3..bee58c6 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -411,6 +411,82 @@
 					};
 				};
 
+				tcb0 {
+					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
+						atmel,pins = <0 24 0x1 0x0>;	/* PA24 periph A */
+					};
+
+					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
+						atmel,pins = <0 25 0x1 0x0>;	/* PA25 periph A */
+					};
+
+					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
+						atmel,pins = <0 26 0x1 0x0>;	/* PA26 periph A */
+					};
+
+					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
+						atmel,pins = <0 21 0x1 0x0>;	/* PA21 periph A */
+					};
+
+					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
+						atmel,pins = <0 22 0x1 0x0>;	/* PA22 periph A */
+					};
+
+					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
+						atmel,pins = <0 23 0x1 0x0>;	/* PA23 periph A */
+					};
+
+					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
+						atmel,pins = <0 27 0x1 0x0>;	/* PA27 periph A */
+					};
+
+					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
+						atmel,pins = <0 28 0x1 0x0>;	/* PA28 periph A */
+					};
+
+					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
+						atmel,pins = <0 29 0x1 0x0>;	/* PA29 periph A */
+					};
+				};
+
+				tcb1 {
+					pinctrl_tcb1_tclk0: tcb1_tclk0-0 {
+						atmel,pins = <2 4 0x3 0x0>;	/* PC4 periph C */
+					};
+
+					pinctrl_tcb1_tclk1: tcb1_tclk1-0 {
+						atmel,pins = <2 7 0x3 0x0>;	/* PC7 periph C */
+					};
+
+					pinctrl_tcb1_tclk2: tcb1_tclk2-0 {
+						atmel,pins = <2 14 0x3 0x0>;	/* PC14 periph C */
+					};
+
+					pinctrl_tcb1_tioa0: tcb1_tioa0-0 {
+						atmel,pins = <2 2 0x3 0x0>;	/* PC2 periph C */
+					};
+
+					pinctrl_tcb1_tioa1: tcb1_tioa1-0 {
+						atmel,pins = <2 5 0x3 0x0>;	/* PC5 periph C */
+					};
+
+					pinctrl_tcb1_tioa2: tcb1_tioa2-0 {
+						atmel,pins = <2 12 0x3 0x0>;	/* PC12 periph C */
+					};
+
+					pinctrl_tcb1_tiob0: tcb1_tiob0-0 {
+						atmel,pins = <2 3 0x3 0x0>;	/* PC3 periph C */
+					};
+
+					pinctrl_tcb1_tiob1: tcb1_tiob1-0 {
+						atmel,pins = <2 6 0x3 0x0>;	/* PC6 periph C */
+					};
+
+					pinctrl_tcb1_tiob2: tcb1_tiob2-0 {
+						atmel,pins = <2 13 0x3 0x0>;	/* PC13 periph C */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-- 
1.7.9.5

