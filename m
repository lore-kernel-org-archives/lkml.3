Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3JVRHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:07:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46935 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3JVRHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:07:34 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH 1/4] ARM: dts: i.MX53: Add alternate pinmux option for i2c_3
Date: Tue, 22 Oct 2013 19:07:20 +0200
Message-Id: <1382461643-16790-2-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 4307e80..55e83d1 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -599,6 +599,13 @@
 							MX53_PAD_GPIO_5__I2C3_SCL 0xc0000000
 						>;
 					};
+
+					pinctrl_i2c3_2: i2c3grp-2 {
+						fsl,pins = <
+							MX53_PAD_GPIO_3__I2C3_SCL	0xc0000000
+							MX53_PAD_GPIO_6__I2C3_SDA	0xc0000000
+						>;
+					};
 				};
 
 				ipu_disp0 {
-- 
1.7.10.4

