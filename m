Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaBPLf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 06:35:58 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55736 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBPLf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:35:56 -0500
Message-ID: <5300A2A6.3010801@gmail.com>
Date: Sun, 16 Feb 2014 19:36:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        tim.c.chen@linux.intel.com, liuj97@gmail.com,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: avr32: include: asm: Kbuild: add generic "vga.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add generic "vga.h", or can not pass building for allmodconfig,
the related error:

    CC [M]  drivers/gpu/drm/drm_irq.o
  In file included from include/linux/vgaarb.h:34,
                   from drivers/gpu/drm/drm_irq.c:42:
  include/video/vga.h:22:21: error: asm/vga.h: No such file or directory


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/avr32/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 8b398ff..00a0f3c 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -19,4 +19,5 @@ generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += topology.h
 generic-y += trace_clock.h
+generic-y += vga.h
 generic-y += xor.h
-- 
1.7.11.7
