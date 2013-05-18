Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab3ERCc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:32:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3ERCQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:44 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=MUSVw9rQ_KIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CHxnmOSzaDcA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=6zb38KopAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=WwgC8nHKvroA:10 a=JTMqrY5UvyEA:10 a=D-PNlr3aaKoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021642.493437474@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [ 004/136 ] ARM: u300: fix ages old copy/paste bug
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0004-ARM-u300-fix-ages-old-copy-paste-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 0259d9eb30d003af305626db2d8332805696e60d ]

The UART1 is on the fast AHB bridge, not on the slow bus.

Cc: stable@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-u300/include/mach/u300-regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-u300/include/mach/u300-regs.h b/arch/arm/mach-u300/include/mach/u300-regs.h
index 65f87c5..cacb2af 100644
--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -101,7 +101,7 @@
 
 #ifdef CONFIG_MACH_U300_BS335
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 #endif
 
 /*
-- 
1.7.10.4


