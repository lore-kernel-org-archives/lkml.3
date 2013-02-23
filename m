Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3BWQ2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:28:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab3BWQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:28:51 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 0/2] cputime: Fixes
Date: Sat, 23 Feb 2013 17:28:43 +0100
Message-Id: <1361636925-22288-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a couple of non-regression fixes on top of Linus tree.

Thanks.

Frederic Weisbecker (1):
  cputime: Use local_clock() for full dynticks cputime accounting

Li Zhong (1):
  cputime: fix compiler warning caused by timeval_to_cputime()

 include/asm-generic/cputime_nsecs.h |    2 +-
 kernel/sched/cputime.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.5.4

