Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3GVKxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:53:02 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62307 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3GVKw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:52:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Christian Daudt <csd@broadcom.com>
Subject: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 BRT DTS file
Date: Mon, 22 Jul 2013 11:52:24 +0100
Message-Id: <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Christian Daudt <csd@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/bcm11351-brt.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 67ec524..fdace5d 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -27,18 +27,18 @@
 		status = "okay";
 	};
 
-	sdio0: sdio@0x3f180000 {
+	sdio0: sdio@3f180000 {
 		max-frequency = <48000000>;
 		status = "okay";
 	};
 
-	sdio1: sdio@0x3f190000 {
+	sdio1: sdio@3f190000 {
 		non-removable;
 		max-frequency = <48000000>;
 		status = "okay";
 	};
 
-	sdio3: sdio@0x3f1b0000 {
+	sdio3: sdio@3f1b0000 {
 		max-frequency = <48000000>;
 		status = "okay";
 	};
-- 
1.8.1.2

