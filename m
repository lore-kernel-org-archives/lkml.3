Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572Ab3GSN7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:59:52 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55542 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3GSN7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 22/22] ARM: ux500: Remove '0x's from Spear 320 DTS file
Date: Fri, 19 Jul 2013 14:58:53 +0100
Message-Id: <1374242333-6852-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/spear320.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear320.dtsi b/arch/arm/boot/dts/spear320.dtsi
index ffea342..a82d76e5 100644
--- a/arch/arm/boot/dts/spear320.dtsi
+++ b/arch/arm/boot/dts/spear320.dtsi
@@ -55,7 +55,7 @@
 			status = "disabled";
 		};
 
-		shirq: interrupt-controller@0xb3000000 {
+		shirq: interrupt-controller@b3000000 {
 			compatible = "st,spear320-shirq";
 			reg = <0xb3000000 0x1000>;
 			interrupts = <30 28 29 1>;
-- 
1.8.1.2

