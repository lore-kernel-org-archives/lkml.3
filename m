Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3LBIbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:31:50 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:34513 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3LBIbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:31:47 -0500
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] arm: at91: sama5d3: enable qt1070 as a wakeup source
Date: Mon,  2 Dec 2013 16:29:48 +0800
Message-Id: <1385972988-20157-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable qt1070 keyboard as a wakeup source on sama5d3xek board.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/sama5d3xdm.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
index 1c296d6..f9bdde5 100644
--- a/arch/arm/boot/dts/sama5d3xdm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
@@ -18,6 +18,7 @@
 					interrupts = <31 0x0>;
 					pinctrl-names = "default";
 					pinctrl-0 = <&pinctrl_qt1070_irq>;
+					wakeup-source;
 				};
 			};
 
-- 
1.7.9.5

