Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab3GSN7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:59:17 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50827 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab3GSN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Christian Daudt <csd@broadcom.com>
Subject: [PATCH 05/22] ARM: ux500: Remove '0x's from BCM11351 BRT DTS file
Date: Fri, 19 Jul 2013 14:58:36 +0100
Message-Id: <1374242333-6852-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
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

