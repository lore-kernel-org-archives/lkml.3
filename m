Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaF0S33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaF0S32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:29:28 -0400
Date: Fri, 27 Jun 2014 19:01:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] tracing/uprobes fixes
Message-ID: <20140627170116.GA18298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It took me several hours to realize that the strange bug I hit was
caused by the change I have nacked in the past ;)

But it appears that I should take the blame. I was cc'ed, but I missed
that email or forgot to reply, so another attempt to push this "trivial"
change was successful.

I think that 1/4 should go to stable. 2-4 are "while at it" fixes.

Oleg.

 kernel/events/uprobes.c     |    6 ++--
 kernel/trace/trace_uprobe.c |   46 +++++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 22 deletions(-)

