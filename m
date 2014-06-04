Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFDVfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:35:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:41385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaFDVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:35:23 -0400
Date: Wed, 4 Jun 2014 23:35:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>
Subject: Re: [GIT PULL] locking tree changes for v3.16
In-Reply-To: <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406042327270.18296@nanos>
References: <20140603114821.GA23711@gmail.com> <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net> <20140604103003.GE11096@twins.programming.kicks-ass.net> <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
 <20140604172220.GI13930@laptop.programming.kicks-ass.net> <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Linus Torvalds wrote:

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
> have it run through the build robots. I'll pull it tomorrow or Friday
> if everything looks fine, and then we'll hopefully have this issue
> mostly closed.

Send it my way. I gitify it and run it through my own test machinery

Thanks,

	tglx
