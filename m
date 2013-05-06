Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3EFVSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:18:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3EFUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:45:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 006/115] ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding
Date: Mon,  6 May 2013 13:44:02 -0700
Message-Id: <20130506203056.238913401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit f10491fff07dcced77f8ab1b3bc1f8e18715bfb9 upstream.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
[nicolas.ferre@atmel.com: fix rts/cts for usart3]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9260.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
 


