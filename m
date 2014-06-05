Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaFEBEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:04:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:50585 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaFEBD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:03:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,976,1392192000"; 
   d="scan'208";a="542651905"
Date: Thu, 5 Jun 2014 09:03:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140605010353.GA13193@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
 <20140604122612.366e2874@gandalf.local.home>
 <20140605002012.GA10446@localhost>
 <20140604210016.4766adba@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604210016.4766adba@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:00:16PM -0400, Steven Rostedt wrote:
> On Thu, 5 Jun 2014 08:20:12 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > On Wed, Jun 04, 2014 at 12:26:12PM -0400, Steven Rostedt wrote:
> > > On Wed, 4 Jun 2014 16:09:21 +1000
> > > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > Hi Steven,
> > > > 
> > > > After merging the ftrace tree, today's linux-next build (x86_64 allmodconfig)
> > > > produced this warning:
> > > > 
> > > > kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
> > > > kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
> > > >   u64 seedsq;
> > > >       ^
> > > > 
> > > > Introduced by commit 81dc9f0ef21e ("tracing: Add tracepoint benchmark tracepoint").
> > > 
> > > Hmm, I don't know why my tests missed this. I do a allmodconfig looking
> > > for new warning messages too. Oh, but I do need to add this config to my
> > > regular testing config :-/
> > > 
> > > I'm surprised Wu's bot didn't report it either.
> > 
> > Steven, it was reported, here is the email archive:
> > 
> > https://lists.01.org/pipermail/kbuild-all/2014-May/004749.html
> 
> Was I Cc'd? I don't have that in my inbox, nor do I see it in any of my
> spam filters.

Yes, here is the email message:

        Date: Sat, 31 May 2014 02:16:43 +0800
        From: kbuild test robot <fengguang.wu@intel.com>
==>     To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
        CC: kbuild-all@01.org
        Subject: [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
        User-Agent: Heirloom mailx 12.5 6/20/10

        tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
        head:   4c27e756bc019ec1c11232893af036fdae720a97
        commit: 81dc9f0ef21e40114cc895894c7acf3055f6d1fb [29/32] tracing: Add tracepoint benchmark tracepoint
        config: make ARCH=x86_64 allmodconfig

        All warnings:

           kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
        >> kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
             u64 seedsq;                                                                             
                 ^
Thanks,
Fengguang
