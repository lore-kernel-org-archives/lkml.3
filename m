Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3GOOXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:23:03 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:34791 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3GOOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:23:00 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/5] ARM: dts: imx23-evk: enable Low Resolution ADC
Date: Mon, 15 Jul 2013 11:22:38 -0300
Message-Id: <1373898160-8460-3-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.XM23 has a internal Low Resolution ADC; this enables the support
for this device.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 arch/arm/boot/dts/imx23-evk.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index dc3ab45..185c7c0 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -90,6 +90,11 @@
 		};
 
 		apbx@80040000 {
+			lradc@80050000 {
+				status = "okay";
+				fsl,lradc-touchscreen-wires = <4>;
+			};
+
 			pwm: pwm@80064000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pwm2_pins_a>;
-- 
1.8.3.2

