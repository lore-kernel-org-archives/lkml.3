Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab3D3DRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:17:30 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63626 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3D3DR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:17:28 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 0/7] posix-cpu-timers fixlet
Date: Mon, 29 Apr 2013 23:17:08 -0400
Message-Id: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glibc's posix timer testcase found a lot of bugs in posix timer code. This series, hopefully,
fixes all of them. All patches are independent each other logically.


[PATCH 1/7] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
[PATCH 2/7] posix-cpu-timers: fix acounting delta_exec twice
[PATCH 3/7] posix-cpu-timers: fix wrong timer initialization
[PATCH 4/7] posix-cpu-timers: timer functions must use timer time instead of clock time
[PATCH 5/7] posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
[PATCH 6/7] sched: task_sched_runtime introduce micro optimization
[PATCH 7/7] posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}
