Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaFEBWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:22:17 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:50719 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaFEBWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:22:16 -0400
Message-ID: <1401931331.13877.31.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [GIT PULL] locking tree changes for v3.16
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>
Date: Wed, 04 Jun 2014 18:22:11 -0700
In-Reply-To: <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
References: <20140603114821.GA23711@gmail.com>
	 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
	 <20140604103003.GE11096@twins.programming.kicks-ass.net>
	 <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
	 <20140604172220.GI13930@laptop.programming.kicks-ass.net>
	 <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 14:22 -0700, Linus Torvalds wrote:
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
> have it run through the build robots.

Fortunately Andrew had put it in -next for the past few weeks, and so
far so good. fwiw I've gone through the code again and it is exactly the
same as what I originally sent. 

