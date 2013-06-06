Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab3FFMXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:23:47 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50146 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411Ab3FFMR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/33] ARM: ux500: Add TWD (fixed-factor) clock node to DBx500 Device Tree
Date: Thu,  6 Jun 2013 13:17:03 +0100
Message-Id: <1370521041-32318-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index edb53c63..2027929 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -61,6 +61,10 @@
 			rtc_clk: rtc32k-clock {
 				#clock-cells = <0>;
 			};
+
+			smp_twd_clk: smp-twd-clock {
+				#clock-cells = <0>;
+			};
 		};
 
 		timer@a0410600 {
-- 
1.7.10.4

