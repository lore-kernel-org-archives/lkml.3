Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaAQJJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:09:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57531 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaAQJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:09:07 -0500
Date: Fri, 17 Jan 2014 10:08:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption checks
Message-ID: <20140117090856.GE11314@laptop.programming.kicks-ass.net>
References: <20140116235751.084728c8@gandalf.local.home>
 <20140116211214.581197e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116211214.581197e5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:12:14PM -0800, Andrew Morton wrote:
> On Thu, 16 Jan 2014 23:57:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > When PROVE_LOCKING and PREEMPT is configured, the preempt state
> > tracking is active. Testing this out, I added a module that did the
> > following:
> 
> So I assume your kernel at least has no instances of this bug, so we
> don't need the patch ;) It *is* a fairly daft thing to do.

Yeah, its exceedingly daft, but I do run into it every so often. Say
once a year or so.

Also, its usually not really a problem on 'normal' kernels, but it
absolutely blows on -rt.
