Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047Ab3DDQ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:27:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:46447 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762931Ab3DDQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:27:44 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>
CC: <jhovold@gmail.com>, Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding
Date: Thu, 4 Apr 2013 18:27:42 +0200
Message-ID: <1365092862-3479-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <515D7A4F.90707@interlog.com>
References: <515D7A4F.90707@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
[nicolas.ferre@atmel.com: fix rts/cts for usart3]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> #3.8+
---
Hi,

v2: - add commit message
    - correct rts/cts for usart3
    - add stable tag

 arch/arm/boot/dts/at91sam9260.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 367a604..3e2adfb 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -158,8 +158,8 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<2 6 0x1 0x1	/* PB6 periph A with pullup */
-							 2 7 0x1 0x0>;	/* PB7 periph A */
+							<1 6 0x1 0x1	/* PB6 periph A with pullup */
+							 1 7 0x1 0x0>;	/* PB7 periph A */
 					};
 
 					pinctrl_usart1_rts: usart1_rts-0 {
@@ -194,18 +194,18 @@
 				usart3 {
 					pinctrl_usart3: usart3-0 {
 						atmel,pins =
-							<2 10 0x1 0x1	/* PB10 periph A with pullup */
-							 2 11 0x1 0x0>;	/* PB11 periph A */
+							<1 10 0x1 0x1	/* PB10 periph A with pullup */
+							 1 11 0x1 0x0>;	/* PB11 periph A */
 					};
 
 					pinctrl_usart3_rts: usart3_rts-0 {
 						atmel,pins =
-							<3 8 0x2 0x0>;	/* PB8 periph B */
+							<2 8 0x2 0x0>;	/* PC8 periph B */
 					};
 
 					pinctrl_usart3_cts: usart3_cts-0 {
 						atmel,pins =
-							<3 10 0x2 0x0>;	/* PB10 periph B */
+							<2 10 0x2 0x0>;	/* PC10 periph B */
 					};
 				};
 
@@ -220,8 +220,8 @@
 				uart1 {
 					pinctrl_uart1: uart1-0 {
 						atmel,pins =
-							<2 12 0x1 0x1	/* PB12 periph A with pullup */
-							 2 13 0x1 0x0>;	/* PB13 periph A */
+							<1 12 0x1 0x1	/* PB12 periph A with pullup */
+							 1 13 0x1 0x0>;	/* PB13 periph A */
 					};
 				};
 
-- 
1.8.0

