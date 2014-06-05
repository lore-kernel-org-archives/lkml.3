Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFEITW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:19:22 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54869 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFEITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:19:20 -0400
Date: Thu, 5 Jun 2014 10:19:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605081915.GD4926@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
 <20140604172220.GI13930@laptop.programming.kicks-ass.net>
 <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jun 4, 2014 at 10:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I _think_ tip/locking/core is empty and you could pull that into your
> > tree without getting tons of extra weird stuff, but if you prefer a tree
> > based on your git tree I'll have to do some manual stuff but that is
> > certainly possible.
> 
> I'd actually prefer against something like the v3.15-rc8 tag, just so
> that the tree is otherwise "pristine".
> 
> > Also, this 'obviously' does not have the normal tip build coverage,
> > because I usually rely on the tip build robots to do that. But it does
> > build and run for all my local machines.
> 
> It would be great to have Davidlohr go over it too, and if possible
> have it run through the build robots. [...]

The build/boot robots found breakage and that is why its first 
iteration was removed, I didn't have fundamental objections.

Thanks,

	Ingo
