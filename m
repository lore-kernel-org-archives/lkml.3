Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaFEBdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:33:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:63972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaFEBdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:33:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,977,1392192000"; 
   d="scan'208";a="542659599"
Date: Thu, 5 Jun 2014 09:33:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140605013300.GA13341@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
 <20140604122612.366e2874@gandalf.local.home>
 <20140605002012.GA10446@localhost>
 <20140604210016.4766adba@gandalf.local.home>
 <20140605010353.GA13193@localhost>
 <20140604211202.0eb5d147@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604211202.0eb5d147@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:12:02PM -0400, Steven Rostedt wrote:
> On Thu, 5 Jun 2014 09:03:53 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> > > Was I Cc'd? I don't have that in my inbox, nor do I see it in any of my
> > > spam filters.
> >
> > Yes, here is the email message:
> >
> >         Date: Sat, 31 May 2014 02:16:43 +0800
> >         From: kbuild test robot <fengguang.wu@intel.com>
> > ==>     To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> Hmm, I wonder where it ended up? I do have a pretty complex procmailrc
> file, but I even checked the procmail log file, and it doesn't show it.
>
> I don't think my email provider dropped it, as I have all the spam
> filtering turned off and do my own filtering. Although, they may have
> added something behind my back. Wouldn't be the first time.
>
> Are you sure that got sent?

I have no supporting log to check whether the emails are actually sent
to you.  All I have is the list of emails that were sent, and these
emails do have the TO: field to you.

> Can you check if your bots have triggered anything else for me. Because
> your bots have been surprisingly quiet lately. I just took that as me
> getting better at not pushing crap.

Here are the recent emails sent to you:

 439   F May 10 To Steven Rostedt (4440:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:108:27: warning: 'removed_ops' defined but not used
 446   F May 10 To Steven Rostedt (3531:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:5358:12: error: 'struct ftrace_ops' has no member named 'trampoline'
1207   F May 31 To Steven Rostedt (  43:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
1210   F May 31 To Steven Rostedt (  29:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:84:3: warning: comparison of distinct pointer types lacks a cast

> I may add a bad commit to one of my branches and see if I get a
> response from you just to test it out. I really hope we can fix this
> because I've gotten someone dependent on your reports. :-/

Yes we need to fix it. The same lost email issue has happened for
someone else, which was fixed by changing the email address. I can
conveniently redirect reports to any other email addresses you have.

Thanks,
Fengguang

>
> -- Steve
>
>
> >         CC: kbuild-all@01.org
> >         Subject: [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
> >         User-Agent: Heirloom mailx 12.5 6/20/10
> >
> >         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
> >         head:   4c27e756bc019ec1c11232893af036fdae720a97
> >         commit: 81dc9f0ef21e40114cc895894c7acf3055f6d1fb [29/32] tracing: Add tracepoint benchmark tracepoint
> >         config: make ARCH=x86_64 allmodconfig
> >
> >         All warnings:
> >
> >            kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
> >         >> kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
> >              u64 seedsq;
> >                  ^
> > Thanks,
> > Fengguang
