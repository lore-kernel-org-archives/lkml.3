Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406AbaDITz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:55:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58066 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933342AbaDITz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:55:26 -0400
X-Sasl-enc: QB/Sw4CLxoX95d/R3VrIeVuPk6/NEfiucsxCXl0Xf2zj 1397073323
Date: Wed, 9 Apr 2014 12:57:55 -0700
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
Message-ID: <20140409195755.GA12513@kroah.com>
References: <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
 <20140407185658.GK11096@twins.programming.kicks-ass.net>
 <20140408122128.GC13658@twins.programming.kicks-ass.net>
 <53450F7E.7040904@canonical.com>
 <20140409094515.GR11096@twins.programming.kicks-ass.net>
 <20140409142447.GD13658@twins.programming.kicks-ass.net>
 <CA+55aFzBw0i2nmOGOKzjS_b_7M1Gha2OFEe9rXOO4c+s-2HTkg@mail.gmail.com>
 <20140409191931.GB10748@kroah.com>
 <20140409193845.GB26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409193845.GB26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:38:45PM +0200, Peter Zijlstra wrote:
> On Wed, Apr 09, 2014 at 12:19:31PM -0700, Greg KH wrote:
> > On Wed, Apr 09, 2014 at 07:36:23AM -0700, Linus Torvalds wrote:
> > > On Wed, Apr 9, 2014 at 7:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > I'm not entirely clear on how acceptable it is to propose a different
> > > > patch for -stable than what we have upstream.
> > > 
> > > It's not all that common, but it certainly happens.
> > > 
> > > It's fine, as long as it mentions the commits that fix it upstream.
> > > And as long as it's well tested, of course.
> > 
> > I agree, I can take this as long as you say it's correct and tested...
> 
> As far as I understand the issue the patch is indeed correct and I have
> 3 independent people who confirm their previously reported issues are
> now cured (as testified by the Tested-by tags).
> 
> There has also been confirmation that upstream does no longer suffer the
> problem.

Thanks for that, I'll queue it up in a bit.

greg k-h
