Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3GOSqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:46:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:5225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3GOSqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="345992525"
Date: Mon, 15 Jul 2013 11:46:42 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130715184642.GE15531@xanatos>
References: <20130715155202.GC29526@xanatos>
 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:17:06AM -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 11:04 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > However, I am serious about this.  Linus, you're one of the worst
> > offenders when it comes to verbally abusing people and publicly tearing
> > their emotions apart.
> 
> Yes. And I do it partly (mostly) because it's who I am, and partly
> because I honestly despise being subtle or "nice".
> 
> The fact is, people need to know what my position on things are. And I
> can't just say "please don't do that", because people won't listen. I
> say "On the internet, nobody can hear you being subtle", and I mean
> it.
> 
> And I definitely am not willing to string people along, either. I've
> had that happen too - not telling people clearly enough that I don't
> like their approach, they go on to re-architect something, and get
> really upset when I am then not willing to take their work.

You can tell developers in no uncertain terms that you're not willing to
take their work *without* verbally tearing them apart.  You're Linus
Torvalds, for crying out loud!  I simple, "No, that's a bad idea, stop
working on this RIGHT now," is more than enough from you.  If it's not,
well, those people are just dense and can probably put up with stronger
language.

> Sarah, first off, I don't have that many tools at hand. Secondly, I
> simply don't believe in being polite or politically correct.

Bullshit.  I've seen you be polite, and explain to clueless maintainers
why there's no way you can revert their merge that caused regressions,
and ask them to fit it without resorting to tearing them down
emotionally:

http://marc.info/?l=linux-kernel&m=136130347127908&w=2

You just don't want to take the time to be polite to everyone.  Don't
give me the "I'm not polite" card.  Go write some documentation about
what's acceptable for stable.  While you're at it, write some more
documentation about why it's impossible for you to revert merges, so
maintainers know not to send you crap, or piss away time trying to argue
with you that they don't need to fix regressions.  When maintainers
challenge you, point them to it, and say, "Fix this now."

If they protest, then you can bring out the big threats and say, "If you
don't fix this, I won't pull from you the next merge window.  Go find a
backup maintainer that can handle your tree, and train them for the next
release.  You may need to hand over your maintainership to them."

If the maintainer doesn't have sub-maintainers that could take over,
that's a problem we need to fix *before* things like this happen.  We
should discuss which kernel subsystems don't have backups at KS.

There are other tools at hand.  You just don't use them.

> And you can point at all those cultural factors where some cultures
> are not happy with confrontation (and feel free to make it about
> gender too - I think that's almost entirely cultural too). And please
> bring up "cultural sensitivity" while at it. And I'll give you back
> that same "cultural sensitivity". Please be sensitive to _my_ culture
> too.
> 
> Google "management by perkele".
> 
> Do you really want to oppress a minority? Because Finns are a minority
> compared to almost any other country. If you want to talk cultural
> sensitivity, I'll join you. But my culture includes cursing.

Did I mention minorities here at all?  Nope.  My only comment was that I
wasn't going to be a "nice girl" anymore, which is a comment about my
personality, not about the discussion at hand.

*No one* deserves to be yelled at IN ALL CAPS in email, or publicly
ridiculed.  It doesn't matter if they are a minority or not.

You are in a position of power.  Stop verbally abusing your developers.

> And some of the above is written tonge-in-cheek, but all of it is also
> serious. I really fundamentally believe that being honest and open
> about your emotions about core/process is good. And because it's damn
> hard to read people over email, I think you need to be *more* honest
> and *more* open over email. I'm generally nicer in person. Not always.

*Snort*.  Perhaps we haven't interacted very often, but I have never
seen you be nice in person at KS.  Well, there was that one time you
came to me and very quietly explained you had a problem with your USB
3.0 ports, but you came off as "scared to talk to a girl kernel
developer" more than "I'm trying to be polite".

> And yes, I'll happily be part of the discussion at the KS. But I think
> you also need to be aware that your "high horse" isn't necessarily all
> that high.

Dude, I'm not on a horse here.  I'm not asking you to change your
communication styles in order to help minorities.  I'm not some crazy
feminist ranting about cooties on Google+.

I'm trying to improve the kernel mailing lists for all developers.  We
can give negative technical feedback without verbal abuse.

Sarah Sharp
