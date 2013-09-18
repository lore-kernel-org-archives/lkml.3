Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3IRMPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:10 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49644 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3IRMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/41] ARM: ux500: Add RTC (fixed-frequency) clock node to DBx500 Device Tree
Date: Wed, 18 Sep 2013 13:14:12 +0100
Message-Id: <1379506478-16625-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 8857dd1..77ea36f 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -57,6 +57,10 @@
 			prcc_kclk: prcc-kernel-clock {
 				#clock-cells = <2>;
 			};
+
+			rtc_clk: rtc32k-clock {
+				#clock-cells = <0>;
+			};
 		};
 
 		timer@a0410600 {
-- 
1.8.1.2

