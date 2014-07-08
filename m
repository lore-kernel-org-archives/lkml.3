Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGHGBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:01:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43491 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHGBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:01:12 -0400
Message-ID: <53BB890B.2050106@gmail.com>
Date: Tue, 08 Jul 2014 14:00:43 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: peterz@infradead.org, mingo@kernel.org, tim.c.chen@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, lauraa@codeaurora.org,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/include/asm/Kbuild: Add generic "serial.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related error (with allmodconfig under score):

    CC [M]  drivers/staging/speakup/speakup_acntpc.o
  In file included from drivers/staging/speakup/speakup_acntpc.c:33:0:
  drivers/staging/speakup/serialio.h:7:24: fatal error: asm/serial.h: No such file or directory
   #include <asm/serial.h>
                          ^
  compilation terminated.
  make[3]: *** [drivers/staging/speakup/speakup_acntpc.o] Error 1
  make[2]: *** [drivers/staging/speakup] Error 2
  make[1]: *** [drivers/staging] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index bfb31569..108a225 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -10,5 +10,6 @@ generic-y += mcs_spinlock.h
 generic-y += pci.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += xor.h
-- 
1.9.2.459.g68773ac
