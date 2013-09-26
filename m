Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3IZJbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:31:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59179 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3IZJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:31:44 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tools/perf: remove unused MANIFEST
Date: Thu, 26 Sep 2013 14:54:40 +0530
Message-Id: <1380187480-7575-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.299.gb3e7d24.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 This file was last touched 7 months ago. A lot seems to have changed
 since then. Time to get rid of it?

 tools/perf/MANIFEST | 32 --------------------------------
 1 file changed, 32 deletions(-)
 delete mode 100644 tools/perf/MANIFEST

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
deleted file mode 100644
index 025de79..0000000
--- a/tools/perf/MANIFEST
+++ /dev/null
@@ -1,32 +0,0 @@
-tools/perf
-tools/scripts
-tools/lib/traceevent
-tools/lib/lk
-include/linux/const.h
-include/linux/perf_event.h
-include/linux/rbtree.h
-include/linux/list.h
-include/linux/hash.h
-include/linux/stringify.h
-lib/rbtree.c
-include/linux/swab.h
-arch/*/include/asm/unistd*.h
-arch/*/include/asm/perf_regs.h
-arch/*/include/uapi/asm/unistd*.h
-arch/*/include/uapi/asm/perf_regs.h
-arch/*/lib/memcpy*.S
-arch/*/lib/memset*.S
-include/linux/poison.h
-include/linux/magic.h
-include/linux/hw_breakpoint.h
-include/linux/rbtree_augmented.h
-include/uapi/linux/perf_event.h
-include/uapi/linux/const.h
-include/uapi/linux/swab.h
-include/uapi/linux/hw_breakpoint.h
-arch/x86/include/asm/svm.h
-arch/x86/include/asm/vmx.h
-arch/x86/include/asm/kvm_host.h
-arch/x86/include/uapi/asm/svm.h
-arch/x86/include/uapi/asm/vmx.h
-arch/x86/include/uapi/asm/kvm.h
-- 
1.8.4.299.gb3e7d24.dirty

