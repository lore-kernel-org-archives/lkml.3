Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3ILULA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:11:00 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:59995 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3ILUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:10:58 -0400
Date: Thu, 12 Sep 2013 22:10:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912201054.GB32644@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 12, 2013 at 11:03 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > When I compiled "perf" at the same time as doing a big kernel compile,
> > the kernel compile failed
> 
> Oops. That may actually have been me being a bit *too* eager with a 
> "make allmodconfig" build. I can't reproduce it, and I'm starting to 
> suspect that I instead had two kernel compiles going, not one kernel 
> compile and a tools/perf/ compile.

Btw., building perf in parallel to an ongoing kernel compile is something 
I do almost daily, and I never saw problems due to that. A perf build is 
not supposed to cause any side effect on the kernel build and vice versa.

So in general it should just work.

>   "Yo Dawg, I heard you like kernel compiles, so I put a kernel compile 
> in your kernel compile so that you can compile the kernel while you 
> compile the kernel".

Heh, accidental dual kernel builds within the same kernel tree is 
something I have a _lot_ of involuntary experience with, and I usually 
recognize the error message patterns straight away ;-)

As a kernel hacker one learns useful skills all the time!

Thanks,

	Ingo
