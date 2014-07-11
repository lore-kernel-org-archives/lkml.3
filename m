Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaGKQNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:13:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaGKQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:44 -0400
Date: Fri, 11 Jul 2014 18:13:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove soon to be dead email address
Message-ID: <20140711161341.GF12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And once with lkml added  :/

--
Subject: Remove soon to be dead email address

My Red Hat email address will soon cease to be; remove it from the
tree in order to save the interweb some bounces.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/blackfin/kernel/perf_event.c | 2 +-
 arch/sh/kernel/perf_event.c       | 2 +-
 arch/sparc/kernel/perf_event.c    | 2 +-
 arch/tile/kernel/perf_event.c     | 2 +-
 arch/x86/kernel/cpu/perf_event.c  | 2 +-
 arch/x86/kernel/cpu/perf_event.h  | 2 +-
 arch/x86/kernel/irq_work.c        | 2 +-
 include/asm-generic/tlb.h         | 2 +-
 include/linux/jump_label.h        | 4 ++--
 include/linux/lockdep.h           | 2 +-
 include/linux/proportions.h       | 2 +-
 include/linux/uprobes.h           | 2 +-
 kernel/events/callchain.c         | 2 +-
 kernel/events/core.c              | 2 +-
 kernel/events/ring_buffer.c       | 2 +-
 kernel/events/uprobes.c           | 2 +-
 kernel/irq_work.c                 | 2 +-
 kernel/jump_label.c               | 4 ++--
 kernel/locking/lockdep.c          | 2 +-
 kernel/locking/lockdep_proc.c     | 2 +-
 kernel/sched/clock.c              | 2 +-
 kernel/sched/fair.c               | 2 +-
 kernel/trace/trace_event_perf.c   | 2 +-
 lib/btree.c                       | 2 +-
 lib/proportions.c                 | 2 +-
 mm/page-writeback.c               | 2 +-
 26 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/blackfin/kernel/perf_event.c b/arch/blackfin/kernel/perf_event.c
index ea2032013cc2..894e3b105f1a 100644
--- a/arch/blackfin/kernel/perf_event.c
+++ b/arch/blackfin/kernel/perf_event.c
@@ -14,7 +14,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *
  * ppc:
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7cfd7f153966..4dca18347ee9 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -10,7 +10,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *
  * ppc:
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 8efd33753ad3..6747497b808e 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -9,7 +9,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  */
 
 #include <linux/perf_event.h>
diff --git a/arch/tile/kernel/perf_event.c b/arch/tile/kernel/perf_event.c
index 2bf6c9c135c1..32b574ad320c 100644
--- a/arch/tile/kernel/perf_event.c
+++ b/arch/tile/kernel/perf_event.c
@@ -21,7 +21,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *  Copyright (C) 2009 Google, Inc., Stephane Eranian
  */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff8a4f6..d3cebeade390 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *  Copyright (C) 2009 Google, Inc., Stephane Eranian
  *
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bdd974b..3c6ff1f96eda 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -5,7 +5,7 @@
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *  Copyright (C) 2009 Google, Inc., Stephane Eranian
  *
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3ab4e0..ead79667c5d9 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -1,7 +1,7 @@
 /*
  * x86 specific code for irq_work
  *
- * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra
  */
 
 #include <linux/kernel.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 5672d7ea1fa0..2c3e76b9e58c 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -5,7 +5,7 @@
  * Copyright 2001 Red Hat, Inc.
  * Based on code from mm/memory.c Copyright Linus Torvalds and others.
  *
- * Copyright 2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright 2011 Red Hat, Inc., Peter Zijlstra
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 784304b222b3..3a4afd2888d2 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -4,8 +4,8 @@
 /*
  * Jump label support
  *
- * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
- * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
+ * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra
  *
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support the result
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f920d7..50f697b43f89 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -2,7 +2,7 @@
  * Runtime locking correctness validator
  *
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * see Documentation/lockdep-design.txt for more details.
  */
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index 26a8a4ed9b07..fd25589ae36d 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -1,7 +1,7 @@
 /*
  * FLoating proportions
  *
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * This file contains the public data structure and API definitions.
  */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 4f844c6b03ee..f1e3e9154855 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -21,7 +21,7 @@
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
- * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra
  */
 
 #include <linux/errno.h>
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 97b67df8fbfe..7f0db83e5d17 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
- *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra
  *  Copyright  �  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57e91905fe8d..18814f25ee34 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
- *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra
  *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1d2..d41e436da8b5 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
- *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra
  *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6f3254e8c137..4713f659c076 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -19,7 +19,7 @@
  * Authors:
  *	Srikar Dronamraju
  *	Jim Keniston
- * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra
  */
 
 #include <linux/kernel.h>
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index e6bcbe756663..b19ddf8652b8 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra
  *
  * Provides a framework for enqueueing and running callbacks from hardirq
  * context. The enqueueing is NMI-safe.
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 9019f15deab2..624bf39f8bed 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -1,8 +1,8 @@
 /*
  * jump label support
  *
- * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
- * Copyright (C) 2011 Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2009 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
+ * Copyright (C) 2011 Red Hat, Inc., Peter Zijlstra
  *
  */
 #include <linux/memory.h>
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e4339b46d..b94dc3d56ad1 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6,7 +6,7 @@
  * Started by Ingo Molnar:
  *
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * this code maps all the lock dependencies as they occur in a live kernel
  * and will warn about the following classes of locking bugs:
diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index ef43ac4bafb5..dd81653ebd3a 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -6,7 +6,7 @@
  * Started by Ingo Molnar:
  *
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * Code for /proc/lockdep and /proc/lockdep_stats:
  *
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 3ef6451e972e..da6140f25328 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -1,7 +1,7 @@
 /*
  * sched_clock for unstable cpu clocks
  *
- *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra
  *
  *  Updates and enhancements:
  *    Copyright (C) 2008 Red Hat, Inc. Steven Rostedt <srostedt@redhat.com>
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 923fe32db6b3..5ddba1fb9e07 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -17,7 +17,7 @@
  *  Copyright (C) 2007, Thomas Gleixner <tglx@linutronix.de>
  *
  *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  */
 
 #include <linux/latencytop.h>
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb407b44..c4aed32c4ced 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -1,7 +1,7 @@
 /*
  * trace event based perf event profiling/tracing
  *
- * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra
  * Copyright (C) 2009-2010 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
diff --git a/lib/btree.c b/lib/btree.c
index 4264871ea1a0..f93a945274af 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -5,7 +5,7 @@
  *
  * Copyright (c) 2007-2008 Joern Engel <joern@logfs.org>
  * Bits and pieces stolen from Peter Zijlstra's code, which is
- * Copyright 2007, Red Hat Inc. Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright 2007, Red Hat Inc. Peter Zijlstra
  * GPLv2
  *
  * see http://programming.kicks-ass.net/kernel-patches/vma_lookup/btree.patch
diff --git a/lib/proportions.c b/lib/proportions.c
index 05df84801b56..aab81c5cd256 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -1,7 +1,7 @@
 /*
  * Floating proportions
  *
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * Description:
  *
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 518e2c3f4c75..66bfe5d73716 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2,7 +2,7 @@
  * mm/page-writeback.c
  *
  * Copyright (C) 2002, Linus Torvalds.
- * Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ * Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra
  *
  * Contains functions related to writing back dirty pages at the
  * address_space level.
