Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3JHISg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:18:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3JHISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:18:32 -0400
Date: Tue, 8 Oct 2013 10:18:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131008081802.GM3081@twins.programming.kicks-ass.net>
References: <20131002145655.361606532@infradead.org>
 <20131002150518.675931976@infradead.org>
 <20131002154901.GA13389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002154901.GA13389@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 05:49:01PM +0200, Oleg Nesterov wrote:
> On 10/02, Peter Zijlstra wrote:
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> 
> Thanks! I was writing the patch, and I chose almost the same naming ;)
> 
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> In fact I'd like to add my sob to 1/3 and 3/3 as well.

I think the rules for SOB are that you either have to write or pass the
patch along in an aggregate work; you did neither -- although I much
value your contributions.

Can I make that a reviewed-by for both instead?
