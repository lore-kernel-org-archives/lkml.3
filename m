Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaK0QH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:07:59 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:54501 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaK0QH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:07:57 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 03/11] ARM: at91: switch configuration option to SOC_AT91RM9200
Date: Thu, 27 Nov 2014 17:06:31 +0100
Message-ID: <388c466bdae899f52d55baa02c83b352f4c95c41.1417103399.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the ARCH_AT91RM9200 is removed because being !DT, we use
the SOC_AT91RM9200 variant. This option can certainly be removed
once the ST driver is reworked a bit.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index db8e756a15a8..826e50b63d7e 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -224,7 +224,7 @@ config AT91_TIMER_HZ
        int "Kernel HZ (jiffies per second)"
        range 32 1024
        depends on ARCH_AT91
-       default "128" if ARCH_AT91RM9200
+       default "128" if SOC_AT91RM9200
        default "100"
        help
 	  On AT91rm9200 chips where you're using a system clock derived
-- 
2.1.3

