Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3JER3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab3JER3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:29:38 -0400
Date: Sat, 5 Oct 2013 19:22:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] rcusync: validations + dtor + exclusive
Message-ID: <20131005172234.GB18191@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004193203.GV15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004193203.GV15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> shall I pick them up and stuff them through tip
> with the rest of the lot?

This would be great, thanks.

> > 4-5 should be ignored without the explicit ack. Peter seems to
> > dislike the exclusive mode. I disagree but I am not going to argue.
> > (well, at least right now ;)
>
> Lets have another few rounds of email on that one; maybe I'll get used
> to it :-)

OK ;) I'll send v2 anyway.

Oleg.

