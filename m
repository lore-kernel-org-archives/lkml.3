Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaGKKKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:10:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaGKKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:10:41 -0400
Date: Fri, 11 Jul 2014 03:10:12 -0700
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-be11e6d86081aa6328eaa4fe6dd14ccf39a023c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
In-Reply-To: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
References: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] Documentation: Docbook:
  Fix files location change of kernel/[hr]timer.c
Git-Commit-ID: be11e6d86081aa6328eaa4fe6dd14ccf39a023c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be11e6d86081aa6328eaa4fe6dd14ccf39a023c8
Gitweb:     http://git.kernel.org/tip/be11e6d86081aa6328eaa4fe6dd14ccf39a023c8
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Fri, 11 Jul 2014 03:43:50 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Jul 2014 22:21:06 +0200

Documentation: Docbook: Fix files location change of kernel/[hr]timer.c

make xmldocs failed because of file location change
from kernel/[hr]timer.c to kernel/time/[hr]timer.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: john.stultz@linaro.org
Cc: rdunlap@infradead.org
Link: http://lkml.kernel.org/r/1405017830-31194-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/device-drivers.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cc63f30..6e06ebd 100644
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
