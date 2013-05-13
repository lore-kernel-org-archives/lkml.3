Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3EMMBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:01:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56566 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3EMMBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:10 -0400
X-AuditID: 85900ec0-d4ccab900000151e-a0-5190d603b056
Subject: [PATCH 0/3][BUGFIX] tracing/kprobe: memory barrier related bugfixes
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Mon, 13 May 2013 20:58:25 +0900
Message-ID: <20130513115824.6545.47677.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are three patches for fixing rcu memory barrier related issue
and sparse warnings, which I was made on previous series.

---

Masami Hiramatsu (3):
      [BUGFIX] tracing/kprobes: Use rcu_dereference_raw for tp->files
      [CLEANUP/SPARSE] tracing/kprobes: Fix a sparse warning for incorrect type in assignment
      [CLEANUP/SPARSE] tracing/kprobes: Make print_*probe_event static


 kernel/trace/trace_kprobe.c |   53 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

-- 
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
IT Management Research Dept. and Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
