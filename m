Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaKLQGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:06:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaKLQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:06:17 -0500
Date: Wed, 12 Nov 2014 17:06:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112160603.GM29390@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
 <20141112125158.GB21343@twins.programming.kicks-ass.net>
 <20141112155843.GA24803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112155843.GA24803@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:58:44PM +0100, Stanislaw Gruszka wrote:
> v1 -> v2: post Peter version
> 
> Peter, if you want post your patch by yourself please do so (you can
> add me with Reported-and-tested-by: tag then). I'm posting this in case
> you don't want to write the changelog :-)

Ah, but did you verify? That test case didn't trigger for me (I let it
run for several minutes before I got bored and shot it).

I think I might split this in two patches, the one killing the
task_delta_exec() and the other doing this. But I can do that if you can
confirm this all does indeed work.
