Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3GVKxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:53:38 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:58499 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab3GVKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:53:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 16/22] ARM: dts: Remove '0x's from OMAP3430 SDP DTS file
Date: Mon, 22 Jul 2013 11:52:35 +0100
Message-Id: <1374490361-25769-16-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/omap3430-sdp.dts | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
index e2249bc..281914e 100644
--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -84,15 +84,15 @@
 			label = "bootloader-nor";
 			reg = <0 0x40000>;
 		};
-		partition@0x40000 {
+		partition@40000 {
 			label = "params-nor";
 			reg = <0x40000 0x40000>;
 		};
-		partition@0x80000 {
+		partition@80000 {
 			label = "kernel-nor";
 			reg = <0x80000 0x200000>;
 		};
-		partition@0x280000 {
+		partition@280000 {
 			label = "filesystem-nor";
 			reg = <0x240000 0x7d80000>;
 		};
@@ -125,19 +125,19 @@
 			label = "xloader-nand";
 			reg = <0 0x80000>;
 		};
-		partition@0x80000 {
+		partition@80000 {
 			label = "bootloader-nand";
 			reg = <0x80000 0x140000>;
 		};
-		partition@0x1c0000 {
+		partition@1c0000 {
 			label = "params-nand";
 			reg = <0x1c0000 0xc0000>;
 		};
-		partition@0x280000 {
+		partition@280000 {
 			label = "kernel-nand";
 			reg = <0x280000 0x500000>;
 		};
-		partition@0x780000 {
+		partition@780000 {
 			label = "filesystem-nand";
 			reg = <0x780000 0x7880000>;
 		};
@@ -170,19 +170,19 @@
 			label = "xloader-onenand";
 			reg = <0 0x80000>;
 		};
-		partition@0x80000 {
+		partition@80000 {
 			label = "bootloader-onenand";
 			reg = <0x80000 0x40000>;
 		};
-		partition@0xc0000 {
+		partition@c0000 {
 			label = "params-onenand";
 			reg = <0xc0000 0x20000>;
 		};
-		partition@0xe0000 {
+		partition@e0000 {
 			label = "kernel-onenand";
 			reg = <0xe0000 0x200000>;
 		};
-		partition@0x2e0000 {
+		partition@2e0000 {
 			label = "filesystem-onenand";
 			reg = <0x2e0000 0xfd20000>;
 		};
-- 
1.8.1.2

