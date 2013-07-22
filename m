Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3GVKyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:54:03 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33808 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab3GVKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:53:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 18/22] ARM: dts: Remove '0x's from OMAP5 DTS file
Date: Mon, 22 Jul 2013 11:52:37 +0100
Message-Id: <1374490361-25769-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/omap5.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index e643620..be58604 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -604,7 +604,7 @@
 			ti,hwmods = "wd_timer2";
 		};
 
-		emif1: emif@0x4c000000 {
+		emif1: emif@4c000000 {
 			compatible	= "ti,emif-4d5";
 			ti,hwmods	= "emif1";
 			phy-type	= <2>; /* DDR PHY type: Intelli PHY */
@@ -615,7 +615,7 @@
 			hw-caps-temp-alert;
 		};
 
-		emif2: emif@0x4d000000 {
+		emif2: emif@4d000000 {
 			compatible	= "ti,emif-4d5";
 			ti,hwmods	= "emif2";
 			phy-type	= <2>; /* DDR PHY type: Intelli PHY */
-- 
1.8.1.2

