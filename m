Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3IRMPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:41 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35195 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3IRMPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 41/41] ARM: ux500: Fix trivial whitespace/tabbing issue
Date: Wed, 18 Sep 2013 13:14:38 +0100
Message-Id: <1379506478-16625-42-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 0d2d5d0..e93b54c 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -308,7 +308,7 @@
 					     <22 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "IRQ_HOTMON_LOW", "IRQ_HOTMON_HIGH";
 				status = "disabled";
-			 };
+			};
 
 			db8500-prcmu-regulators {
 				compatible = "stericsson,db8500-prcmu-regulator";
-- 
1.8.1.2

