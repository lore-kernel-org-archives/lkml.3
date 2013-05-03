Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763147Ab3ECRBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:01:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47100 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3ECRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:01:39 -0400
Date: Fri, 3 May 2013 19:00:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
Message-ID: <20130503170007.GA30733@dyad.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.083340271@chello.nl>
 <20130503143507.GP19487@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503143507.GP19487@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 07:35:07AM -0700, Andi Kleen wrote:
> On Fri, May 03, 2013 at 02:11:23PM +0200, Peter Zijlstra wrote:
> > Errata BV98 states that all MEM_*_RETIRED events corrupt the counter
> > value of the SMT sibling's counters. Blacklist these events
> 
> I disagree with this patch. This is just overkill and not needed
> at all.

Then give me a patch that both completely describes the problem and ensures
isolation so that no counters get corrupted (and isn't too invasive).

So far you've failed on both counts.


