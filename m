Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422961Ab3DFNsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:48:06 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:56655 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422925Ab3DFNsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:48:04 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: linux@arm.linux.org.uk, shawn.guo@linaro.org, fabio.estevam@freescale.com,
        otavio@ossystems.com.br, marex@denx.de,
        maxime.ripard@free-electrons.com, f.koliqi@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH] ARM: dts: imx23-olinuxino: mark sdcard cd as broken
Date: Sat,  6 Apr 2013 10:42:10 -0300
Message-Id: <1365255730-6299-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imx23-olinuxino sdcard doesn't have card detect.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 arch/arm/boot/dts/imx23-olinuxino.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts b/arch/arm/boot/dts/imx23-olinuxino.dts
index a43141a..d4cc9f8 100644
--- a/arch/arm/boot/dts/imx23-olinuxino.dts
+++ b/arch/arm/boot/dts/imx23-olinuxino.dts
@@ -29,6 +29,7 @@
 				pinctrl-names = "default";
 				pinctrl-0 = <&mmc0_4bit_pins_a &mmc0_pins_fixup>;
 				bus-width = <4>;
+				broken-cd;
 				status = "okay";
 			};
 
-- 
1.7.10

