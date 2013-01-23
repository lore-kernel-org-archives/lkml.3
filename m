Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3AWJwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:52:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34667 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3AWJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:49:10 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/9] ARM: at91/at91sam9x5 DTS: correct wrong PIO BANK values on u(s)arts
Date: Wed, 23 Jan 2013 10:48:49 +0100
Message-ID: <c89cec3a4037f4aebf948d0f9c984c4823478c66.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358934163.git.nicolas.ferre@atmel.com>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

The PIN_BANK 3 is for PDxx pins, not PCxx pins.
And PIN_BANK 1 is for PBxx, not PIN_BANK 0.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 3a47cf9..e9c4290 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -154,12 +154,12 @@
 
 					pinctrl_usart1_rts: usart1_rts-0 {
 						atmel,pins =
-							<3 27 0x3 0x0>;	/* PC27 periph C */
+							<2 27 0x3 0x0>;	/* PC27 periph C */
 					};
 
 					pinctrl_usart1_cts: usart1_cts-0 {
 						atmel,pins =
-							<3 28 0x3 0x0>;	/* PC28 periph C */
+							<2 28 0x3 0x0>;	/* PC28 periph C */
 					};
 				};
 
@@ -172,46 +172,46 @@
 
 					pinctrl_uart2_rts: uart2_rts-0 {
 						atmel,pins =
-							<0 0 0x2 0x0>;	/* PB0 periph B */
+							<1 0 0x2 0x0>;	/* PB0 periph B */
 					};
 
 					pinctrl_uart2_cts: uart2_cts-0 {
 						atmel,pins =
-							<0 1 0x2 0x0>;	/* PB1 periph B */
+							<1 1 0x2 0x0>;	/* PB1 periph B */
 					};
 				};
 
 				usart3 {
 					pinctrl_uart3: usart3-0 {
 						atmel,pins =
-							<3 23 0x2 0x1	/* PC22 periph B with pullup */
-							 3 23 0x2 0x0>;	/* PC23 periph B */
+							<2 23 0x2 0x1	/* PC22 periph B with pullup */
+							 2 23 0x2 0x0>;	/* PC23 periph B */
 					};
 
 					pinctrl_usart3_rts: usart3_rts-0 {
 						atmel,pins =
-							<3 24 0x2 0x0>;	/* PC24 periph B */
+							<2 24 0x2 0x0>;	/* PC24 periph B */
 					};
 
 					pinctrl_usart3_cts: usart3_cts-0 {
 						atmel,pins =
-							<3 25 0x2 0x0>;	/* PC25 periph B */
+							<2 25 0x2 0x0>;	/* PC25 periph B */
 					};
 				};
 
 				uart0 {
 					pinctrl_uart0: uart0-0 {
 						atmel,pins =
-							<3 8 0x3 0x0	/* PC8 periph C */
-							 3 9 0x3 0x1>;	/* PC9 periph C with pullup */
+							<2 8 0x3 0x0	/* PC8 periph C */
+							 2 9 0x3 0x1>;	/* PC9 periph C with pullup */
 					};
 				};
 
 				uart1 {
 					pinctrl_uart1: uart1-0 {
 						atmel,pins =
-							<3 16 0x3 0x0	/* PC16 periph C */
-							 3 17 0x3 0x1>;	/* PC17 periph C with pullup */
+							<2 16 0x3 0x0	/* PC16 periph C */
+							 2 17 0x3 0x1>;	/* PC17 periph C with pullup */
 					};
 				};
 
-- 
1.8.0

