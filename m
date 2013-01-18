Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3ARMgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:36:38 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:61770 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab3ARMfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:35:20 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 61/76] ARC: perf support (software counters only)
Date: Fri, 18 Jan 2013 17:55:15 +0530
Message-ID: <1358511930-7424-62-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
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
index b954387..0f21a1c 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -26,15 +26,18 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_IRQ_WORK
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MOD_ARCH_SPECIFIC if ARC_DW2_UNWIND
 	select HAVE_OPROFILE
+	select HAVE_PERF_EVENTS
 	select HOTPLUG if !INITRAMFS_SOURCE=""
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
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

