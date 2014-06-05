Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaFEBA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:00:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12151 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782AbaFEBA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:00:27 -0400
Date: Wed, 4 Jun 2014 21:00:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604210016.4766adba@gandalf.local.home>
In-Reply-To: <20140605002012.GA10446@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
	<20140605002012.GA10446@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 08:20:12 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> On Wed, Jun 04, 2014 at 12:26:12PM -0400, Steven Rostedt wrote:
> > On Wed, 4 Jun 2014 16:09:21 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Steven,
> > > 
> > > After merging the ftrace tree, today's linux-next build (x86_64 allmodconfig)
> > > produced this warning:
> > > 
> > > kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
> > > kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
> > >   u64 seedsq;
> > >       ^
> > > 
> > > Introduced by commit 81dc9f0ef21e ("tracing: Add tracepoint benchmark tracepoint").
> > 
> > Hmm, I don't know why my tests missed this. I do a allmodconfig looking
> > for new warning messages too. Oh, but I do need to add this config to my
> > regular testing config :-/
> > 
> > I'm surprised Wu's bot didn't report it either.
> 
> Steven, it was reported, here is the email archive:
> 
> https://lists.01.org/pipermail/kbuild-all/2014-May/004749.html

Was I Cc'd? I don't have that in my inbox, nor do I see it in any of my
spam filters.

-- Steve
