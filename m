Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaFECq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:46:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:35249 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751309AbaFECq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:46:28 -0400
Date: Wed, 4 Jun 2014 22:46:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604224620.279e290c@gandalf.local.home>
In-Reply-To: <20140605021457.GA19061@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
	<20140605002012.GA10446@localhost>
	<20140604210016.4766adba@gandalf.local.home>
	<20140605010353.GA13193@localhost>
	<20140604211202.0eb5d147@gandalf.local.home>
	<20140605013300.GA13341@localhost>
	<20140604213932.5a48112d@gandalf.local.home>
	<20140605021457.GA19061@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 10:14:57 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> On Wed, Jun 04, 2014 at 09:39:32PM -0400, Steven Rostedt wrote:
> > On Thu, 5 Jun 2014 09:33:00 +0800
> > Fengguang Wu <fengguang.wu@intel.com> wrote:
> > 
> > 
> > > Here are the recent emails sent to you:
> > > 
> > >  439   F May 10 To Steven Rostedt (4440:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:108:27: warning: 'removed_ops' defined but not used
> > >  446   F May 10 To Steven Rostedt (3531:1) [trace:ftrace/next-3.17 29/29] kernel/trace/ftrace.c:5358:12: error: 'struct ftrace_ops' has no member named 'trampoline'
> > > 1207   F May 31 To Steven Rostedt (  43:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
> > > 1210   F May 31 To Steven Rostedt (  29:0) [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:84:3: warning: comparison of distinct pointer types lacks a cast
> > 
> > I don't have any of those :-(

BTW, this is the last report I received from your build bot. Anything
after that has gone into limbo.

From: kbuild test robot <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, kbuild-all@01.org
Subject: [drm-intel:for-linux-next 342/342] drivers/gpu/drm/i915/./i915_trace.h:246:22: error: 'dev' undeclared
Date: Wed, 19 Mar 2014 10:12:41 +0800
User-Agent: Heirloom mailx 12.5 6/20/10
Message-ID: <5328fd19.A1aXhOyyvL3I2gl3%fengguang.wu@intel.com>

I noticed that there was no "Red Hat" in that one.

-- Steve

