Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaK0QJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:09:11 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:54628 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaK0QJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:09:09 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 06/11] ARM: at91/trivial: update Kconfig comment to mention SAMA5
Date: Thu, 27 Nov 2014 17:06:34 +0100
Message-ID: <6250565cabb0034e3de4e8591b4da096c28609f6.1417103399.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cortex-A5 SAMA5 processors were not listed, add this in the AT91 comment.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 28f320589aa7..92dbde801d9c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -380,7 +380,7 @@ config ARCH_AT91
 	select USE_OF
 	help
 	  This enables support for systems based on Atmel
-	  AT91RM9200 and AT91SAM9* processors.
+	  AT91RM9200, AT91SAM9 and SAMA5 processors.
 
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x/EP731x-based"
-- 
2.1.3

