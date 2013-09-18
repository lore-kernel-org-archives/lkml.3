Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3IRMWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:22:32 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34103 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IRMPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/41] ARM: ux500: Supply the TWD Timer clock lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:15 +0100
Message-Id: <1379506478-16625-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 9adc4e5..5c3ff94 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -71,6 +71,8 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xa0410600 0x20>;
 			interrupts = <1 13 0x304>; /* IRQ level high per-CPU */
+
+			clocks = <&smp_twd_clk>;
 		};
 
 		rtc@80154000 {
-- 
1.8.1.2

