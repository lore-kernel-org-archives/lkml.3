Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaGLUB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:01:28 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54039 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaGLUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:01:26 -0400
Message-ID: <53C19428.9040008@gmail.com>
Date: Sat, 12 Jul 2014 16:01:44 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/1] doc: fix docbook generation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/timer.c and kernel/hrtimer.c have moved to kernel/time directory. This
causes docbook generation to fail. The following commit fixes it by updating the
references.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
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
1.9.1
