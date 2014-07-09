Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaGIPhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:37:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754057AbaGIPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:19 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 05/34] ARM: at91: move at91rm9200 SoC to the CCF
Date: Wed,  9 Jul 2014 17:06:33 +0200
Message-Id: <1404918422-7562-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the selection of AT91_USE_OLD_CLK when selecting at91rm9200
SoC support. This will automatically enable COMMON_CLK_AT91 option and add
support for at91 common clk implementation.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 45b55e0f0db6..c818136a74b8 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -113,7 +113,6 @@ config SOC_AT91RM9200
 	select HAVE_AT91_DBGU0
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
-	select AT91_USE_OLD_CLK
 	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9260
-- 
1.9.1

