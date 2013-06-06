Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab3FFM0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:26:54 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39666 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FFMRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/33] ARM: ux500: Supply the DMA clock lookup to the DBX500 DT
Date: Thu,  6 Jun 2013 13:16:51 +0100
Message-Id: <1370521041-32318-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index a635f7f..c5f187b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -229,6 +229,8 @@
 
 			#dma-cells = <3>;
 			memcpy-channels = <56 57 58 59 60>;
+
+			clocks = <&prcmu_clk PRCMU_DMACLK>;
 		};
 
 		prcmu: prcmu@80157000 {
-- 
1.7.10.4

