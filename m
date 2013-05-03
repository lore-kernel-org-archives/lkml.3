Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3ECOde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50541 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3ECOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/63] ARM: ux500: Pass DMA memcpy channels though Device Tree
Date: Fri,  3 May 2013 15:31:52 +0100
Message-Id: <1367591569-32197-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's now possible to configure memcpy channels dynamically with DT.
We're providing them despite the fact that they're the same as the
hard-coded channels, as they will be removed once the u8500 platform
goes DT-only.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 838214c..c693428 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -218,6 +218,7 @@
 			interrupts = <0 25 0x4>;
 
 			#dma-cells = <3>;
+			memcpy-channels = <56 57 58 59 60>;
 		};
 
 		prcmu: prcmu@80157000 {
-- 
1.7.10.4

