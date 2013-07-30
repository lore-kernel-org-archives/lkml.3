Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3G3JQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:16:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50321 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab3G3JP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:15:58 -0400
Date: Tue, 30 Jul 2013 14:45:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/10] Improve numa scheduling by consolidating tasks
Message-ID: <20130730091542.GA28656@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
 <20130730081755.GF3008@twins.programming.kicks-ass.net>
 <20130730082001.GG3008@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130730082001.GG3008@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073009-0320-0000-0000-000000786B32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-07-30 10:20:01]:

> On Tue, Jul 30, 2013 at 10:17:55AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 30, 2013 at 01:18:15PM +0530, Srikar Dronamraju wrote:
> > > Here is an approach that looks to consolidate workloads across nodes.
> > > This results in much improved performance. Again I would assume this work
> > > is complementary to Mel's work with numa faulting.
> > 
> > I highly dislike the use of task weights here. It seems completely
> > unrelated to the problem at hand.
> 
> I also don't particularly like the fact that it's purely process based.
> The faults information we have gives much richer task relations.
> 

Peter, 

Can you please suggest workloads that I could try which might showcase
why you hate pure process based approach?

I know numa02_SMT does regress with my patches but I think its most
my implementation fault and not a approach issue.

-- 
Thanks and Regards
Srikar Dronamraju

