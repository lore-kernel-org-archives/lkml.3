Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab3GPTCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab3GPTCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:02:48 -0400
Date: Tue, 16 Jul 2013 20:56:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] tracing: fix open/delete fixes
Message-ID: <20130716185658.GA21167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Completely untested and _incomplete_. This ignores instance_delete()
and ftrace_event_format_fops, at least.

But I am not going to even try to finish this series unless you tell
me that you agree with this approach.

I have no idea what else could I miss. I probably understand no more
than 1% of this code, I won't be surprized if this can't work.

To remind, we also need other changes we are discussing.

Oleg.

 kernel/trace/trace.h               |    4 +-
 kernel/trace/trace_events.c        |  126 ++++++++++++++++--------------------
 kernel/trace/trace_events_filter.c |   21 ++----
 3 files changed, 66 insertions(+), 85 deletions(-)

