Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaFEI3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:29:36 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58155 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEI3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:29:34 -0400
Date: Thu, 5 Jun 2014 10:29:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605082929.GE4926@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
 <20140604172220.GI13930@laptop.programming.kicks-ass.net>
 <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
 <20140605081915.GD4926@gmail.com>
 <alpine.DEB.2.10.1406051020570.23174@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406051020570.23174@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 5 Jun 2014, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Wed, Jun 4, 2014 at 10:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > I _think_ tip/locking/core is empty and you could pull that into your
> > > > tree without getting tons of extra weird stuff, but if you prefer a tree
> > > > based on your git tree I'll have to do some manual stuff but that is
> > > > certainly possible.
> > > 
> > > I'd actually prefer against something like the v3.15-rc8 tag, just so
> > > that the tree is otherwise "pristine".
> > > 
> > > > Also, this 'obviously' does not have the normal tip build 
> > > > coverage, because I usually rely on the tip build robots to do 
> > > > that. But it does build and run for all my local machines.
> > > 
> > > It would be great to have Davidlohr go over it too, and if 
> > > possible have it run through the build robots. [...]
> > 
> > The build/boot robots found breakage and that is why its first 
> > iteration was removed, I didn't have fundamental objections.
> 
> I'll queue Peters lot up and we let Davidlohr and Fengguang lose on 
> it. I run it through my own machinery, so that should work out. ok?

I'll queue them - there's only 5 locking patches pending from PeterZ:

 #
 # <= locking/core
 #
 davidlohr_bueso-rwsem-support_optimistic_spinning.patch
 davidlohr_bueso-rwsem-fix_warnings_for_config_rwsem_generic_spinlock.patch
 rwsem-akpm.patch
 qrwlock1.patch
 qrwlock2.patch

and I first delayed them two weeks ago because there was breakage, and 
then earlier this week because the merge window started - there's no 
'huge queue' really.

Anyway, I too agree that we can merge them.

Thanks,

	Ingo
