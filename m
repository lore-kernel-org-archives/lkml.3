Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbbANLoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:44:09 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50811 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbANLoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:44:07 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, matthias.bgg@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, howard.chen@linaro.org
Subject: [PATCH 1/2] ARM: mediatek: Low-level-debug for mt6592
Date: Wed, 14 Jan 2015 12:35:55 +0100
Message-Id: <1421235356-6631-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the description of the low-level-debug port. SoC mt8127 and
mt6592 have the same uart port and the same mapping. We just change the
description to add low-level-debug to mt6592.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5ddd490..385f2d1 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -973,7 +973,7 @@ choice
 		  for Mediatek mt6589 based platforms on UART0.
 
 	config DEBUG_MT8127_UART0
-		bool "Mediatek mt8127 UART0"
+		bool "Mediatek mt8127/mt6592 UART0"
 		depends on ARCH_MEDIATEK
 		select DEBUG_UART_8250
 		help
-- 
1.9.1

