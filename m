Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3AXLNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:13:12 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:34203 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3AXLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:53 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 55/71] ARC: perf support (software counters only)
Date: Thu, 24 Jan 2013 16:36:19 +0530
Message-ID: <1359025589-22277-36-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                  |    3 +++
 arch/arc/include/asm/perf_event.h |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/perf_event.h

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 69a939af..03183f6 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -25,16 +25,19 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_IRQ_WORK
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MEMBLOCK
 	select HAVE_MOD_ARCH_SPECIFIC if ARC_DW2_UNWIND
 	select HAVE_OPROFILE
+	select HAVE_PERF_EVENTS
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
 	select OF
 	select OF_EARLY_FLATTREE
+	select PERF_USE_VMALLOC
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/arc/include/asm/perf_event.h b/arch/arc/include/asm/perf_event.h
new file mode 100644
index 0000000..115ad96
--- /dev/null
+++ b/arch/arc/include/asm/perf_event.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_PERF_EVENT_H
+#define __ASM_PERF_EVENT_H
+
+#endif /* __ASM_PERF_EVENT_H */
-- 
1.7.4.1

