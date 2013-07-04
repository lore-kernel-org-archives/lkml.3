Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3GDHT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:63266 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3GDHTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:25 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/4] arm: atmel: sama5: add definition for usart base address
Date: Thu,  4 Jul 2013 15:16:39 +0800
Message-Id: <1372922202-28606-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add definition for usart base address

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/mach-at91/include/mach/sama5d3.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/mach-at91/include/mach/sama5d3.h b/arch/arm/mach-at91/include/mach/sama5d3.h
index 6dc81ee..31096a8 100644
--- a/arch/arm/mach-at91/include/mach/sama5d3.h
+++ b/arch/arm/mach-at91/include/mach/sama5d3.h
@@ -65,6 +65,14 @@
 #define SAMA5D3_ID_IRQ0		47	/* Advanced Interrupt Controller (IRQ0) */
 
 /*
+ * User Peripheral physical base addresses.
+ */
+#define SAMA5D3_BASE_USART0	0xf001c000
+#define SAMA5D3_BASE_USART1	0xf0020000
+#define SAMA5D3_BASE_USART2	0xf8020000
+#define SAMA5D3_BASE_USART3	0xf8024000
+
+/*
  * Internal Memory
  */
 #define SAMA5D3_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-- 
1.7.9.5

