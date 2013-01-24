Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3AXKwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:52:40 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:42439 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3AXKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:52:32 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 01/71] ARC: Generic Headers
Date: Thu, 24 Jan 2013 16:20:15 +0530
Message-ID: <1359024639-21915-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/Kbuild        |   58 ++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/asm-offsets.h |    9 +++++
 2 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/Kbuild
 create mode 100644 arch/arc/include/asm/asm-offsets.h

diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
new file mode 100644
index 0000000..a90a3c6
--- /dev/null
+++ b/arch/arc/include/asm/Kbuild
@@ -0,0 +1,58 @@
+include include/asm-generic/Kbuild.asm
+
+# 7-Oct-12: Jeremy Bennett <jeremy.bennett@embecosm.com>. Some of these
+# headers, beyond those specified in the generic set are needed by user code.
+
+header-y += page.h
+header-y += cachectl.h
+
+generic-y += auxvec.h
+generic-y += bugs.h
+generic-y += bitsperlong.h
+generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += fb.h
+generic-y += ftrace.h
+generic-y += hardirq.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += mman.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += stat.h
+generic-y += statfs.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += trace_clock.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += unaligned.h
+generic-y += user.h
+generic-y += vga.h
+generic-y += xor.h
diff --git a/arch/arc/include/asm/asm-offsets.h b/arch/arc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..dad1876
--- /dev/null
+++ b/arch/arc/include/asm/asm-offsets.h
@@ -0,0 +1,9 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <generated/asm-offsets.h>
-- 
1.7.4.1

