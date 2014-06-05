Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaFEWfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:35:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47762 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFEWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:35:18 -0400
X-AuditID: 85900ec0-cff26b9000001514-cd-5390f0a3d58f
Subject: [PATCH ftrace/core 0/3] ftrace: Fix three small bugs
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 06 Jun 2014 07:35:15 +0900
Message-ID: <20140605223515.32311.71203.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I found three small bugs for current ftrace/core, so I fixed those.
Would you apply these patches?

Thanks!

---

Yoshihiro YUNOMAE (3):
      trace/event: Return error if ftrace_trace_arrays is empty list
      trace/kprobes: Avoid self tests if tracing is disabled on boot up
      trace: Fix memory leak when new instance creation failed


 kernel/trace/trace.c        |   23 ++++++++++++++---------
 kernel/trace/trace.h        |    3 +++
 kernel/trace/trace_events.c |   13 +++++++++++++
 kernel/trace/trace_kprobe.c |    3 +++
 4 files changed, 33 insertions(+), 9 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
