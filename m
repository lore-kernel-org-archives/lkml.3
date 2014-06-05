Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaFECof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:44:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:26551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaFECod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,977,1392192000"; 
   d="scan'208";a="542680596"
Date: Thu, 5 Jun 2014 10:44:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140605024430.GB20455@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
 <20140604122612.366e2874@gandalf.local.home>
 <20140605002012.GA10446@localhost>
 <20140604210016.4766adba@gandalf.local.home>
 <20140605010353.GA13193@localhost>
 <20140604211202.0eb5d147@gandalf.local.home>
 <20140605013300.GA13341@localhost>
 <20140604213932.5a48112d@gandalf.local.home>
 <20140605021457.GA19061@localhost>
 <20140604223817.54b05cfc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604223817.54b05cfc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:38:17PM -0400, Steven Rostedt wrote:
> On Thu, 5 Jun 2014 10:14:57 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Jun 04, 2014 at 09:39:32PM -0400, Steven Rostedt wrote:
> > > On Thu, 5 Jun 2014 09:33:00 +0800
> > > Fengguang Wu <fengguang.wu@intel.com> wrote:
> > > 
> > > 
> > > > Here are the recent emails sent to you:
> > > > 
> > > >  439   F May 10 To Steven Rostedt (4440:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:108:27: warning: 'removed_ops' defined but not used
> > > >  446   F May 10 To Steven Rostedt (3531:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:5358:12: error: 'struct ftrace_ops' has no member named 'trampoline'
> > > > 1207   F May 31 To Steven Rostedt (  43:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
> > > > 1210   F May 31 To Steven Rostedt (  29:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:84:3: warning: comparison of distinct pointer types lacks a cast
> > > 
> > > I don't have any of those :-(
> > 
> BTW, can you give me the links to those errors. I'd like to fix them.

Sure. Search "ftrace" in this page, and you'll get all the 4 reports:

https://lists.01.org/pipermail/kbuild-all/2014-May/date.html

Thanks,
Fengguang
