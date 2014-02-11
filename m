Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaBKP1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:27:47 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48779 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaBKP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:27:44 -0500
Date: Tue, 11 Feb 2014 10:27:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org
Subject: Re: lockdep: strange %s#5 lock name
Message-ID: <20140211152741.GA24490@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211110036.GT9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:00:36PM +0100, Peter Zijlstra wrote:
> > Looks good to me.  Can you please post the patch with SOB?
> 
> ---
> Subject: workqueue: Fix workqueue lockdep name
> 
> Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
> process_one_work(). It turns out that commit b196be89cdc14 forgot to
> change the lockdep_init_map() when it changed the @lock_name argument
> from a string to a format.
> 
> Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf fmt and args for name")
> Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Applied to wq/for-3.14-fixes.

Thanks!

-- 
tejun
