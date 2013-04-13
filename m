Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3DMOTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3DMOTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:19:30 -0400
Date: Sat, 13 Apr 2013 16:02:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH 0/1] uprobes/perf: Avoid perf_trace_buf_prepare/submit if
	->perf_events is empty
Message-ID: <20130413140234.GA32273@redhat.com>
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com> <516692BF.6070904@hitachi.com> <20130411115921.GA27492@redhat.com> <1365801588.9609.95.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365801588.9609.95.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Steven Rostedt wrote:
>
> On Thu, 2013-04-11 at 13:59 +0200, Oleg Nesterov wrote:
>
> > > If so, we can do same thing also on trace_events.
> > > (perf_trace_##call in include/trace/ftrace.h)
> >
> > Yes, yes, this is not kprobe-specific. It seems that more users of
> > perf_trace_buf_submit() could be changed the same way.
> >
>
> Oleg,
>
> Can you make the necessary changes elsewhere? I talked with Frederic on
> IRC and he's a bit busy with other work. But he did say he would review
> changes that you make.

Sure, will be happy to do.

But can I change uprobes/perf first? I have a lot more pending changes in
trace_uprobe.c which I am going to ask to pull, I'd like to add this simple
patch to "oleg/misc uprobes/core" if I have your ack.

Oleg.

