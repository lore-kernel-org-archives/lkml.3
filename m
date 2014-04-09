Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbaDITRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:17:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52183 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933342AbaDITRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:17:04 -0400
X-Sasl-enc: mHXGZbql4k7kqUfoBZuwo4VFkdS6OJ1n93m53T+0CgQm 1397071019
Date: Wed, 9 Apr 2014 12:19:31 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Michele Ballabio <barra_cuda@katamail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -stable] x86,preempt: Fix preemption for i386
Message-ID: <20140409191931.GB10748@kroah.com>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
 <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
 <20140407185658.GK11096@twins.programming.kicks-ass.net>
 <20140408122128.GC13658@twins.programming.kicks-ass.net>
 <53450F7E.7040904@canonical.com>
 <20140409094515.GR11096@twins.programming.kicks-ass.net>
 <20140409142447.GD13658@twins.programming.kicks-ass.net>
 <CA+55aFzBw0i2nmOGOKzjS_b_7M1Gha2OFEe9rXOO4c+s-2HTkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzBw0i2nmOGOKzjS_b_7M1Gha2OFEe9rXOO4c+s-2HTkg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 07:36:23AM -0700, Linus Torvalds wrote:
> On Wed, Apr 9, 2014 at 7:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I'm not entirely clear on how acceptable it is to propose a different
> > patch for -stable than what we have upstream.
> 
> It's not all that common, but it certainly happens.
> 
> It's fine, as long as it mentions the commits that fix it upstream.
> And as long as it's well tested, of course.

I agree, I can take this as long as you say it's correct and tested...

thanks,

greg k-h
