Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967944Ab3E3Ib7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:31:59 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34280 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967930Ab3E3Ib1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:31:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Reduce PRCMU reg-names to shorter form for u8540 DT
Date: Thu, 30 May 2013 09:31:15 +0100
Message-Id: <1369902675-5170-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some discussion and deliberation we have decided to only use the
short form of the PRCMU register names i.e. not mention the peripheral
in which the registers reside.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ccu8540.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index af4487f..12f0bc2 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -23,7 +23,7 @@
 	soc {
 		prcmu@80157000 {
 			reg = <0x80157000 0x2000>, <0x801b0000 0x8000>, <0x801b8000 0x3000>;
-			reg-names = "prcmu", "prcmu-tcpm-per4", "prcmu-tcdm-per4";
+			reg-names = "prcmu", "prcmu-tcpm", "prcmu-tcdm";
 		};
 
 		uart@80120000 {
-- 
1.7.10.4

