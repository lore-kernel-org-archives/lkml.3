Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3IRMPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:08 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64435 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3IRMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/41] ARM: ux500: Supply the RTC clock lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:13 +0100
Message-Id: <1379506478-16625-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 77ea36f..81cdfcf 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -73,6 +73,9 @@
 			compatible = "arm,rtc-pl031", "arm,primecell";
 			reg = <0x80154000 0x1000>;
 			interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&rtc_clk>;
+			clock-names = "apb_pclk";
 		};
 
 		gpio0: gpio@8012e000 {
-- 
1.8.1.2

