Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3KSFPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:15:17 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58644 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KSFPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:15:11 -0500
Message-ID: <528AF461.4020502@gmail.com>
Date: Tue, 19 Nov 2013 13:17:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: include: asm: add "vga.h" in Kbuild
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include generic "vga.h", or can not pass compiling with
allmodconfig, the related error:

    CC [M]  drivers/gpu/drm/drm_irq.o
  In file included from include/linux/vgaarb.h:34:0,
                   from drivers/gpu/drm/drm_irq.c:42:
  include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory

Also move "preempt.h" upper to match sort order.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/include/asm/Kbuild |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 67c3450..424e28e 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -31,6 +31,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
 generic-y += scatterlist.h
@@ -52,5 +53,5 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
+generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
-- 
1.7.7.6
