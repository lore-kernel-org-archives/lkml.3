Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaFEJYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:24:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49273 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaFEJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:24:42 -0400
Date: Thu, 5 Jun 2014 11:24:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605092437.GA4453@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605092130.GC6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605092130.GC6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 05, 2014 at 10:17:42AM +0200, Ingo Molnar wrote:
> > 
> > Right now I'm somewhat 'missing' because I fell ill right when the 
> > merge window began :-/ But I merged all your pending bits shortly 
> > before the merge window started. During the merge window itself I 
> > try not to merge fresh patches.
> 
> Yeah, no problem that, it just shows we need to better arrange 
> things for when you're not available.
> 
> My/our quilt workflow works really good for me when you're there, 
> but its obviously somewhat broken without you. We just need to work 
> out a (better) fallback case.

Agreed.

> The timing was just somewhat unfortunate.

Yeah, and another part of the problem was that I reported the breakage 
in private which really made it harder for others to see why there's a 
delay.

Thanks,

	Ingo
