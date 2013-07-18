Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3GRAmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:42:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:39475 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3GRAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:42:29 -0400
Date: Thu, 18 Jul 2013 02:42:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
In-Reply-To: <20130715195316.GF15531@xanatos>
Message-ID: <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com> <20130715195316.GF15531@xanatos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Sarah Sharp wrote:
> On Mon, Jul 15, 2013 at 12:07:56PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 11:46 AM, Sarah Sharp
> > <sarah.a.sharp@linux.intel.com> wrote:
> > >
> > > Bullshit.  I've seen you be polite, and explain to clueless maintainers
> > > why there's no way you can revert their merge that caused regressions,
> > > and ask them to fit it without resorting to tearing them down
> > > emotionally:
> > 
> > Oh, I'll be polite when it's called for.
> > 
> > But when people who know better send me crap, I'll curse at them.
> > 
> > I suspect you'll notice me cursing *way* more at top developers than
> > random people on the list. I expect more from them, and conversely
> > I'll be a lot more upset when they do something that I really think
> > was not great.
> > 
> > For example, my latest cursing explosion was for the x86 maintainers,
> > and it comes from the fact that I *know* they know to do better. The
> > x86 tip pulls have generally been through way more testing than most
> > other pulls I get (not just compiling, but even booting randconfigs
> > etc). So when an x86 pull request comes in that clearly missed that
> > expected level of quality, I go to town.
> >
> Good lord.  So anyone that is one of your "top maintainers" could be
> exposed to your verbal abuse just because they "should have known
> better"?

I'm one of the "victims" of Linus' latest "verbal abuse". :)
 
Just for the record. I got grilled by Linus several times over the
last years and I can't remember a single instance where it was
unjustified. When I see such a mail in my inbox, I know that I fucked
up royally and all I do is to figure out what I broke this time and
fix it. I don't give a rat's ass about his "abusive" language. See
below.

> exposed to your verbal abuse just because they "should have known
> better"?

You know what "should have known better" stands for?

    It stands for violating trust.

Linus simply has to trusts his top level maintainers, because he
cannot review, audit and check 10k patches which flow into his tree
every merge window himself.

So if he finds out that someone who has his ultimate trust sends him a
pile of crap, he tells that person in his own unmisunderstandable way
that he's not amused.

> You know what the definition of an abuser is?  Someone that seeks out
> victims that they know will "just take it" and keep the abuse "between
> the two of them".  They pick victims that won't fight back or report the
> abuse.

IOW, I'm a typical victim of abuse.

Let me clarify that.

The person who gets away with picking me for this kind of abuse has
not been born yet. And Linus knows very well, that he gets the full
pack back from me (in some different form of "abusive language") if he
yelled at me for no reason. It's documented out there including his
apologies.

So if you talk about abuse, then you need an abuser and a victim. So
your argumentation falls flat because there is no victim.

I do not care about his swear words and rants at all, because I know
that it makes him feel better.

     That's a cultural thing.

Where I grew up it's part of the culture to explode, let off steam and
then go and have a beer together. I strongly believe this prevents
gastric ulcer and keeps you honest. Linus and I have this kind of
relationship. We respect each other, we trust each other and when one
side fucks up we yell at each other and then meet at the bar for a
drink.

Linus did NOT abuse me in his latest rant. He simply told me in a very
strong language that he's grumpy because I violated his trust. And
that's legitimate. It's also legitimate to do that in public because
it documents that the top level maintainers are not impeccable. And it
sets a clear expectation bar for those who want to become maintainers
of any level.

Aside of that I completely agree with Linus, that this policital
correctness crusades are merily creating more subtle and hard to fight
forms of real abuse.

I observe that every other day in big corporates, which have written
down code of conducts and a gazillion of rules for interaction; they
just foster dishonesty and other fallacies.

I really prefer the honest slap from Linus than dealing with people
who signed and "comply" to some code of conduct and stab you in your
back wherever they can.

If you can point me to a single instance of Linus "abusing" someone
who is not one of his trusted persons, who really should be able to
deal with that, or someone who did not provoke him to go into rant
mode, then I'm all on your side.

Aside of that, I agree that Linus could achieve the same effect by
using a different (more palatable to you) language, but that's a
different story.


Thanks,

	tglx
