Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3IRMPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:00 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50373 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3IRMOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:14:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/41] ARM: ux500: Supply the DMA clock lookup to the DBX500 DT
Date: Wed, 18 Sep 2013 13:14:02 +0100
Message-Id: <1379506478-16625-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 2c64c85..0bb8ed7 100644
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
1.8.1.2

