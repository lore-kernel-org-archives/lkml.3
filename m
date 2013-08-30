Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3H3PuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:50:06 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:58247 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3H3PuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:50:04 -0400
Date: Fri, 30 Aug 2013 17:49:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130830154957.GA10875@somewhere>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
 <20130826175012.GA25202@redhat.com>
 <20130826141814.54dcaa89@gandalf.local.home>
 <20130826182907.GB25202@redhat.com>
 <20130826150304.090a1025@gandalf.local.home>
 <20130827121629.GE10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827121629.GE10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:16:29PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 26, 2013 at 03:03:04PM -0400, Steven Rostedt wrote:
> > > Is there some path through sys_perf_open_event that might be
> > > missing a capability check perhaps ?
> > > 
> > 
> > That's a question for Ingo, Peter or Jiri.
> 
> Its not something I've looked at recently, git blames Jiri and fweisbec
> for most of that code.
> 
> Permission checks appear to live in
> kernel/trace/trace_event_perf.c:perf_trace_event_perm().

Well, it also depends on sysctl kernel.perf_event_paranoid settings.
