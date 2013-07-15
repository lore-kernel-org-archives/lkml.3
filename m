Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3GOTxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:53:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:10735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab3GOTxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:53:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,671,1367996400"; 
   d="scan'208";a="370694733"
Date: Mon, 15 Jul 2013 12:53:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130715195316.GF15531@xanatos>
References: <20130715155202.GC29526@xanatos>
 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 12:07:56PM -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 11:46 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > Bullshit.  I've seen you be polite, and explain to clueless maintainers
> > why there's no way you can revert their merge that caused regressions,
> > and ask them to fit it without resorting to tearing them down
> > emotionally:
> 
> Oh, I'll be polite when it's called for.
> 
> But when people who know better send me crap, I'll curse at them.
> 
> I suspect you'll notice me cursing *way* more at top developers than
> random people on the list. I expect more from them, and conversely
> I'll be a lot more upset when they do something that I really think
> was not great.
> 
> For example, my latest cursing explosion was for the x86 maintainers,
> and it comes from the fact that I *know* they know to do better. The
> x86 tip pulls have generally been through way more testing than most
> other pulls I get (not just compiling, but even booting randconfigs
> etc). So when an x86 pull request comes in that clearly missed that
> expected level of quality, I go to town.

Good lord.  So anyone that is one of your "top maintainers" could be
exposed to your verbal abuse just because they "should have known
better"?

You know what the definition of an abuser is?  Someone that seeks out
victims that they know will "just take it" and keep the abuse "between
the two of them".  They pick victims that won't fight back or report the
abuse.

> Similarly, you will see fireworks if some long-term maintainer makes
> excuses for breaking user space etc. That will make me go into
> incoherent rages.
> 
> The "polite Linus" example that you point to? That was a maintainer
> asking for direction for when things went wrong and *before* sending
> me something dubious. Of course I'm polite then.
> 
> Sarah, I don't have Tourettes syndrome. You seem to think that my
> cursing is uncontrolled and random. I argue that it has causes. Big
> difference.

It does not matter if your cursing fits have causes.  The fact is that
if you misjudge someone's emotional state for the day, you yelling at
them is not productive.

In karate, or any other sport, if your opponent is motionless on the
floor, you stop.  You can't see the person you're emailing.  You can't
see if the first conversation-disabling blow has completely knocked them
out.  You can't see if you've misjudged their mental strength for the
day and completely wiped out their ability to use their brain to correct
the technical mistake you're trying to get them to fix.

Ask them to fix their mistake.  If they protest, then lay into them.  If
you *know* they don't take verbal abuse well, don't.

Let's get this personal baggage out of the way right now, before anyone
else brings it up:

I've been through verbal abuse before.  I won't take that shit from you,
or any of the other Linux kernel developers.  Tell me, politely, what I
have done wrong, and I will fix it.  You don't need to SHOUT, call me
names, or tell me to SHUT THE FUCK UP!

I'm not the only one that won't take verbal abuse.  Stop abusing your
developers.

Sarah Sharp
