Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaIPSoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:44:06 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:36998 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbaIPSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:44:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMOAHuEGFRXQAMM/2dsb2JhbABggw2BKrQRBQFvmxiBFBcBeYRgI4EaN4hCAbw6hXyIa2QdhDUFnQqVRYIbgUU7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 1/1 linux-next] m68k/coldfire: remove second asm/mcfclk.h inclusion in m54xx.c
Date: Tue, 16 Sep 2014 20:43:33 +0200
Message-Id: <1410893014-32665-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/mcfclk.h was included twice.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/m68k/coldfire/m54xx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m68k/coldfire/m54xx.c b/arch/m68k/coldfire/m54xx.c
index eec7f71..075aaab 100644
--- a/arch/m68k/coldfire/m54xx.c
+++ b/arch/m68k/coldfire/m54xx.c
@@ -23,7 +23,6 @@
 #include <asm/mcfuart.h>
 #include <asm/mcfclk.h>
 #include <asm/m54xxgpt.h>
-#include <asm/mcfclk.h>
 #ifdef CONFIG_MMU
 #include <asm/mmu_context.h>
 #endif
-- 
2.1.0

