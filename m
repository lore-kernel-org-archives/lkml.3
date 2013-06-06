Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab3FFLVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:21:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61797 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab3FFLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:21:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/4] ARM: ux500: Fix trivial whitespace/tabbing issue
Date: Thu,  6 Jun 2013 12:21:15 +0100
Message-Id: <1370517676-10909-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index ed5655d..13ebe20 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -297,7 +297,7 @@
 					     <22 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "IRQ_HOTMON_LOW", "IRQ_HOTMON_HIGH";
 				status = "disabled";
-			 };
+			};
 
 			db8500-prcmu-regulators {
 				compatible = "stericsson,db8500-prcmu-regulator";
-- 
1.7.10.4

