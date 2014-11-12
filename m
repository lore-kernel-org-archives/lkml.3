Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaKLRMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:12:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaKLRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:12:54 -0500
Date: Wed, 12 Nov 2014 18:12:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112171241.GK10476@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
 <20141112125158.GB21343@twins.programming.kicks-ass.net>
 <20141112155843.GA24803@redhat.com>
 <20141112160603.GM29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112160603.GM29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:06:03PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 12, 2014 at 04:58:44PM +0100, Stanislaw Gruszka wrote:
> > v1 -> v2: post Peter version
> > 
> > Peter, if you want post your patch by yourself please do so (you can
> > add me with Reported-and-tested-by: tag then). I'm posting this in case
> > you don't want to write the changelog :-)
> 
> Ah, but did you verify? That test case didn't trigger for me (I let it
> run for several minutes before I got bored and shot it).
> 
> I think I might split this in two patches, the one killing the
> task_delta_exec() and the other doing this. But I can do that if you can
> confirm this all does indeed work.

The below should include the two patches; I'll let WU's robot crawl the
thing and post when nothing funny happens.

https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/log/?h=sched/urgent
