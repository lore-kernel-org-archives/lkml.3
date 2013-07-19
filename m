Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab3GSN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:59:46 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51431 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697Ab3GSN7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 20/22] ARM: ux500: Remove '0x's from Spear 300 DTS file
Date: Fri, 19 Jul 2013 14:58:51 +0100
Message-Id: <1374242333-6852-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/spear300.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear300.dtsi b/arch/arm/boot/dts/spear300.dtsi
index f79b3df..8970a4a 100644
--- a/arch/arm/boot/dts/spear300.dtsi
+++ b/arch/arm/boot/dts/spear300.dtsi
@@ -52,7 +52,7 @@
 			status = "disabled";
 		};
 
-		shirq: interrupt-controller@0x50000000 {
+		shirq: interrupt-controller@50000000 {
 			compatible = "st,spear300-shirq";
 			reg = <0x50000000 0x1000>;
 			interrupts = <28>;
-- 
1.8.1.2

