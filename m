Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaK0QIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:08:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:54596 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaK0QIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:08:45 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 05/11] ARM: at91: always USE_OF from now on
Date: Thu, 27 Nov 2014 17:06:33 +0100
Message-ID: <37d9512335b5e41fbac498536faa9b2790703e19.1417103399.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we always use Device Tree now, we can add the configuration here.
Also remove the condition for PINCTRL_AT91.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5ccc68d..28f320589aa7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -376,7 +376,8 @@ config ARCH_AT91
 	select IRQ_DOMAIN
 	select NEED_MACH_IO_H if PCCARD
 	select PINCTRL
-	select PINCTRL_AT91 if USE_OF
+	select PINCTRL_AT91
+	select USE_OF
 	help
 	  This enables support for systems based on Atmel
 	  AT91RM9200 and AT91SAM9* processors.
-- 
2.1.3

