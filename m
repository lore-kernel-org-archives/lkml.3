Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3JHPij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:38:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41144 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3JHPih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:38:37 -0400
Date: Tue, 8 Oct 2013 17:38:23 +0200
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
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131008153823.GC13848@laptop.programming.kicks-ass.net>
References: <20131008102505.404025673@infradead.org>
 <20131008152730.GA16558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008152730.GA16558@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:27:30PM +0200, Oleg Nesterov wrote:
> On 10/08, Peter Zijlstra wrote:
> >
> >  - Added Reviewed-by for Oleg to patches 1,3 -- please holler if you disagree!
> 
> Thanks ;)
> 
> And of course, feel free to add my sob to 4/6, although this doesn't
> matter.

Thanks, done!
