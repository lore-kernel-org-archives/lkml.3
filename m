Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbbALVYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:24:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58016 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751955AbbALVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:24:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/6] ARM: at91: sama5d4: remove useless call to at91_init_sram
Date: Mon, 12 Jan 2015 22:23:43 +0100
Message-Id: <1421097825-396-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/sama5d4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index 7638509639f4..fa127fb79221 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -56,7 +56,6 @@ static struct map_desc at91_io_desc[] __initdata = {
 static void __init sama5d4_map_io(void)
 {
 	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
-	at91_init_sram(0, SAMA5D4_NS_SRAM_BASE, SAMA5D4_NS_SRAM_SIZE);
 }
 
 AT91_SOC_START(sama5d4)
-- 
2.1.0

