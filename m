Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3ETBHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:07:52 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:23867 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754967Ab3ETBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:07:51 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <nicolas.ferre@atmel.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to "MT_MEMORY_SO"
Date: Mon, 20 May 2013 09:06:19 +0800
Message-ID: <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index e2f4bdd..d68be6c 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -80,7 +80,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 
 	desc->pfn = __phys_to_pfn(base);
 	desc->length = length;
-	desc->type = MT_DEVICE;
+	desc->type = MT_MEMORY_SO;
 
 	pr_info("AT91: sram at 0x%lx of 0x%x mapped at 0x%lx\n",
 		base, length, desc->virtual);
-- 
1.7.9.5

