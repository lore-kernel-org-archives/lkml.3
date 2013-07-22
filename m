Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3GVK4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:56:39 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:50920 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab3GVKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:53:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 13/22] ARM: dts: Remove '0x's from OMAP3 IGEP0020 DTS file
Date: Mon, 22 Jul 2013 11:52:32 +0100
Message-Id: <1374490361-25769-13-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/omap3-igep0020.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-igep0020.dts b/arch/arm/boot/dts/omap3-igep0020.dts
index e8c4828..f7a8122 100644
--- a/arch/arm/boot/dts/omap3-igep0020.dts
+++ b/arch/arm/boot/dts/omap3-igep0020.dts
@@ -99,19 +99,19 @@
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

