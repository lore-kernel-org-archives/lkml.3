Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3GAImB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:42:01 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54591 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3GAIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:13 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 07/13] ARM: AT91: DTS: sam9x5ek: enable SSC
Date: Mon,  1 Jul 2013 10:39:32 +0200
Message-Id: <1372667978-4718-8-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the SSC needed for the WM8731 codec

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 77e4073..4f3584c 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -95,6 +95,10 @@
 			watchdog@fffffe40 {
 				status = "okay";
 			};
+
+			ssc0: ssc@f0010000 {
+				status = "okay";
+			};
 		};
 
 		usb0: ohci@00600000 {
-- 
1.7.10.4

