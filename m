Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3FDIwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3FDIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:52:34 -0400
Date: Tue, 4 Jun 2013 10:51:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130604085159.GA1103@krava.brq.redhat.com>
References: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
 <20130603122223.GA1999@gmail.com>
 <20130603194101.GB31107@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603194101.GB31107@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:41:21PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 03, 2013 at 02:22:23PM +0200, Ingo Molnar wrote:
> > 
> > * Alexander Gordeev <agordeev@redhat.com> wrote:

SNIP

> How about we define finegrained context on top of perf events themselves?
> Like we could tell perf to count a task's instructions only after
> tracepoint:irq_entry is hit and stop counting when tracepoint:irq_exit.
> 
> This way we can define any kind of fine grained context, not just irqs. We
> are not short on tracepoints, software events, breakpoints, kprobes, uprobes
> to play Legos there.

agreed, we could do the same as Alex did plus we'd have
the generic interface to meassure any place

> 
> I had a branch with a working draft of that:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>   	perf/custom-ctx-v2-pre
> 
> Frederic Weisbecker (5):
>       perf: Starter and stopper events
>       perf: New enable_on_starter attribute
>       perf: Support for starter and stopper in tools
>       perf: New --enable-on-starter option
>       perf: Add TODOs for event defined context
> 
> It needs quite some improvements, (some are listed in the TODO on the last commit)
> especially in both the kernel and user interfaces.
> 
> Jiri had some nice ideas about it.

yep, one of them is to to get back to this soon ;-)

jirka
