Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab3GaJtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:49:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759295Ab3GaJtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:49:19 -0400
Date: Wed, 31 Jul 2013 10:49:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA
 node
Message-ID: <20130731094914.GN2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-17-git-send-email-mgorman@suse.de>
 <20130717105423.GC17211@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130717105423.GC17211@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:54:23PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 04:20:18PM +0100, Mel Gorman wrote:
> > +static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
> 
> And this

> -- which suggests you always build with cgroups enabled?

Yes, the test kernel configuration is one taken from an opensuse kernel
with a bunch of unnecessary drivers removed.

> I generally
> try and disable all that nonsense when building new stuff, the scheduler is a
> 'lot' simpler that way. Once that works make it 'interesting' again.
> 

Understood. I'll disable CONFIG_CGROUPS in the next round of testing which
will be based against 3.11-rc3 once I plough this set of feedback.

Thanks.

-- 
Mel Gorman
SUSE Labs
