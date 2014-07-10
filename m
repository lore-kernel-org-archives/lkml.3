Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaGJSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:44:34 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37958 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaGJSo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:44:27 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: Docbook: Fix files location change of kernel/[hr]timer.c in device-drivers.tmpl
Date: Fri, 11 Jul 2014 03:43:50 +0900
Message-Id: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.1.537.g81e776d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make xmldocs failed because of file location change
from kernel/[hr]timer.c to kernel/time/[hr]timer.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/device-drivers.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index dd3f278..f213058 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -54,7 +54,7 @@
 !Ikernel/sched/cpupri.c
 !Ikernel/sched/fair.c
 !Iinclude/linux/completion.h
-!Ekernel/timer.c
+!Ekernel/time/timer.c
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
@@ -63,7 +63,7 @@
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
 !Iinclude/linux/hrtimer.h
-!Ekernel/hrtimer.c
+!Ekernel/time/hrtimer.c
      </sect1>
      <sect1><title>Workqueues and Kevents</title>
 !Ekernel/workqueue.c
-- 
2.0.1.537.g81e776d

