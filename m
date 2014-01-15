Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaAOK1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:27:47 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36908 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaAOK1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:27:46 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] at91: dt: sam9263: fixed compatibility string for the I2C
Date: Wed, 15 Jan 2014 11:24:46 +0100
Message-Id: <1389781486-29670-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index c8fa9b9..7d6dd09 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -523,7 +523,7 @@
 			};
 
 			i2c0: i2c@fff88000 {
-				compatible = "atmel,at91sam9263-i2c";
+				compatible = "atmel,at91sam9260-i2c";
 				reg = <0xfff88000 0x100>;
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
-- 
1.8.5.2

