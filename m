Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3GSOBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:01:53 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61995 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603Ab3GSN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 14/22] ARM: ux500: Remove '0x's from OMAP3 IGEP0030 DTS file
Date: Fri, 19 Jul 2013 14:58:45 +0100
Message-Id: <1374242333-6852-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benoît Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/omap3-igep0030.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-igep0030.dts b/arch/arm/boot/dts/omap3-igep0030.dts
index 644d0538..f628200 100644
--- a/arch/arm/boot/dts/omap3-igep0030.dts
+++ b/arch/arm/boot/dts/omap3-igep0030.dts
@@ -74,19 +74,19 @@
 			label = "SPL";
 			reg = <0 0x100000>;
 		};
-		partition@0x80000 {
+		partition@80000 {
 			label = "U-Boot";
 			reg = <0x100000 0x180000>;
 		};
-		partition@0x1c0000 {
+		partition@1c0000 {
 			label = "Environment";
 			reg = <0x280000 0x100000>;
 		};
-		partition@0x280000 {
+		partition@280000 {
 			label = "Kernel";
 			reg = <0x380000 0x300000>;
 		};
-		partition@0x780000 {
+		partition@780000 {
 			label = "Filesystem";
 			reg = <0x680000 0x1f980000>;
 		};
-- 
1.8.1.2

