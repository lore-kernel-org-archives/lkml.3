Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3GOOXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:23:07 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:49446 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3GOOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:23:04 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Fadil Berisha <f.koliqi@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/5] ARM: dts: imx23-olinuxino: enable Low Resolution ADC
Date: Mon, 15 Jul 2013 11:22:39 -0300
Message-Id: <1373898160-8460-4-git-send-email-otavio@ossystems.com.br>
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
 arch/arm/boot/dts/imx23-olinuxino.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts b/arch/arm/boot/dts/imx23-olinuxino.dts
index d107c4a..fc766ae 100644
--- a/arch/arm/boot/dts/imx23-olinuxino.dts
+++ b/arch/arm/boot/dts/imx23-olinuxino.dts
@@ -69,6 +69,10 @@
 		};
 
 		apbx@80040000 {
+			lradc@80050000 {
+				status = "okay";
+			};
+
 			duart: serial@80070000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&duart_pins_a>;
-- 
1.8.3.2

