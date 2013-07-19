Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab3GSOCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:02:23 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47706 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760631Ab3GSN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 12/22] ARM: ux500: Remove '0x's from OMAP2420 H4 DTS file
Date: Fri, 19 Jul 2013 14:58:43 +0100
Message-Id: <1374242333-6852-12-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/omap2420-h4.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap2420-h4.dts b/arch/arm/boot/dts/omap2420-h4.dts
index 224c08f..34cdecb 100644
--- a/arch/arm/boot/dts/omap2420-h4.dts
+++ b/arch/arm/boot/dts/omap2420-h4.dts
@@ -50,15 +50,15 @@
 			label = "bootloader";
 			reg = <0 0x20000>;
 		};
-		partition@0x20000 {
+		partition@20000 {
 			label = "params";
 			reg = <0x20000 0x20000>;
 		};
-		partition@0x40000 {
+		partition@40000 {
 			label = "kernel";
 			reg = <0x40000 0x200000>;
 		};
-		partition@0x240000 {
+		partition@240000 {
 			label = "file-system";
 			reg = <0x240000 0x3dc0000>;
 		};
-- 
1.8.1.2

