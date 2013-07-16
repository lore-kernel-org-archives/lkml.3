Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3GPM4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:56:37 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61038 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3GPM4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:56:36 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/4] ARM: dts: imx23-evk: enable USB PHY and controller
Date: Tue, 16 Jul 2013 09:56:12 -0300
Message-Id: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX23EVK board provides a USB port so the USB PHY and controller
need to be enabled for it to be usable.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
Changes in v2: None

 arch/arm/boot/dts/imx23-evk.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index da0588a..dc3ab45 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -107,6 +107,16 @@
 				pinctrl-0 = <&duart_pins_a>;
 				status = "okay";
 			};
+
+			usbphy0: usbphy@8007c000 {
+				status = "okay";
+			};
+		};
+	};
+
+	ahb@80080000 {
+		usb0: usb@80080000 {
+			status = "okay";
 		};
 	};
 
-- 
1.8.3.2

