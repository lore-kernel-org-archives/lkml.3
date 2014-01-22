Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaAVLoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:44:46 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:55727 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbaAVLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:44:45 -0500
Date: Wed, 22 Jan 2014 12:44:43 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bisected] qemu hangs on current git
Message-ID: <20140122114443.GA389@x4>
References: <20140121215119.GA389@x4>
 <20140122085035.GA390@x4>
 <20140122093755.GA388@x4>
 <20140122102435.GH31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122102435.GH31570@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 11:24 +0100, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 10:37:55AM +0100, Markus Trippelsdorf wrote:
> > git bisect points to:
> > 
> > commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Wed Nov 20 12:22:37 2013 +0100
> > 
> >     sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> > 
> 
> No idea why kvm would go funny on that, real hardware runs fine.
> 
> You're running a !PREEMPT kernel, right? Does the below make any
> difference?

Yes: CONFIG_PREEMPT_VOLUNTARY=y 
And yes, your patch fixes the issue.
Thanks.

-- 
Markus
