Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaFJQYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:24:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57629 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFJQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:24:20 -0400
Date: Tue, 10 Jun 2014 18:24:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 6/6] nohz: Use IPI implicit full barrier against
 rq->nr_running r/w
Message-ID: <20140610162415.GC1951@localhost.localdomain>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-7-git-send-email-fweisbec@gmail.com>
 <20140610154813.GE3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610154813.GE3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 05:48:13PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 05:15:09PM +0200, Frederic Weisbecker wrote:
> > +       /*
> > +	* More than one running task need preemption.
> > +	* nr_running update is assumed to be visible
> > +	* after IPI is sent from wakers.
> > +	*/
> 
> That looks like whitespace damage.

Ah, $EDITOR failed again while showing off. I'll fix that for the pull request.

Thanks.
