Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3GRJcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:32:25 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42448 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3GRJcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:32:21 -0400
Date: Thu, 18 Jul 2013 11:32:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: open conflicts vs. hidden conflicts  (was: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130718093217.GA23558@gmail.com>
References: <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130717181440.GA16955@gmail.com>
 <20130718084258.37477f76@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718084258.37477f76@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* NeilBrown <neilb@suse.de> wrote:

> On Wed, 17 Jul 2013 20:14:40 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>  
> > 1)
> > 
> > Your notion that conflicts and insults somehow hurt group cooperation 
> > is wrong. It is a scientific fact that open conflict _helps_ 
> > cooperation while hidden conflict hurts it.
> 
> I don't think anyone is seriously suggesting that open conflict is a bad 
> thing are they?

In my experience the request to "act professionally" essentially results 
in conflict avoidance and in hidden conflicts with a lot of covert 
violence.

Expecting others to suppress emotions in technically justified situations, 
to match the somewhat prudish cultural U.S. taboos of avoiding four letter 
words and gardrobe malfunction at any cost [while violence in TV and 
carrying guns around children are A-O.K.] results in that in practice.

This kills the central claim IMO, that honest, colorful, "unprofessional" 
language is somehow bad because it's hurtful.

In fact an overt flame against me is much nicer than hidden conflict 
because it's out in the open, the person emitting the flame is 
_responsible_ for the central validity of his flame.

The real choice in large scale technological development is not between 
pain and no pain, but between episodes of fast, visible pain combined with 
responsibility, or slow, creeping, long lasting pain inflicted by parties 
hidden and not really responsible and not really aware.

Why is it that some of our best, most productive developers and 
maintainers (Linus, Al Viro, Peter Zijlstra to name a few) are all known 
to be very honest and very direct in their communications, using sometimes 
colorful language if they are unhappy?

I think Steve Jobs understood that very well too.

And how is it consistent that on one hand we tell Chinese and Japanese 
kernel developers to learn to deal with the western directness of lkml 
(i.e. we declare that frank, technically correct directness and expression 
of emotions is more valuable than politeness), but then tell 
Swedish/Finnish/Russian/Dutch/German kernel developers to tone it down 
(i.e. we kind of declare the exact opposite)?

I will be the first one in the line to fight against true abuses:

 - lying
 - generating unjustified, non-technical conflict
 - showing difficulty in conflict resolution
 - outright acts of malice

A colorful Linus complaint against a top level maintainer is neither of 
these in the vast majority of cases, and it can in fact be argued to be 
technically, scientifically productive.

The suggested solution, to 'act professionally' will not avoid either of 
these abuses - in fact it makes hidden violence easier not just because it 
forces people to suppress emotions, but also because abusers cannot be 
called upon.

All in one, I just don't see the pro-PC arguments are consistent or even 
valid, I think the burden of proof is on the 'act professionally' crowd.

> I don't object to reminding everyone that conflict can be healthy and 
> valuable, but is seems to miss the main point of this discussion(*).
> 
> > 
> > 2)
> > 
> > Your notion that insults are harmful because they 'hurt' is misleading 
> > to such a level that it's almost wrong.
> > 
> > Insults do hurt of course, but that argument misses the full context: 
> > in real life the typical substitute for an avoided open conflict is 
> > not singing kumbaya around the camp fire, but _hidden_ conflict.
> 
> Open conflict != insults.

Open conflict allows for escallation of communications.

Firstly, if I messed up in a big honking way then why shouldn't Linus be 
allowed to say:

  "Argh, what the f*ck is going on here Ingo??"

Why should he hide his feelings about it and formulate in a milder way:

  "What is going on here Ingo?"

?

Maybe I'll be deluded into thinking that Linus is not really upset about 
it. The conflict is already present and there's no undoing of it. I messed 
up and Linus got upset - justifiably in the vast majority in cases. Why 
should he hide that information from me? I might not take the conflict 
seriously enough and I might repeat the mistake.

Development of large software projects is about people working together - 
hiding feelings is definitely not helpful. It takes passion to do a good 
job - and that passion has two sides to it, depending on whether good 
things or bad things happened.

Now I'm sure there's cases where Linus was wrong, although it's pretty 
rare in practice as far as I can tell, and when it happens it's not like
I couldn't defend myself. The fact that I'm still around demonstrates that 
Linus is not grudge holder.

> Certainly there is an overlap, but it is quite possible to engage in 
> open conflict without being deliberately insulting.  The appropriate 
> alternate to insults is not "hidden conflict" but rather "civil 
> bluntness".

So, the danger is the following: the moment you expect some person to act 
out of his regular, technically justified patterns of communication and 
expect him to suppress emotions you are expecting him to suppress 
conflicts in essence.

I realize that this is not what you 'want' to happen, but it is what 
_happens_ in practice.

I've seen that in several corporate environments I have worked in the 
past: hidden conflicts are abound and 'act professionally' not only 
weakens conflict resolution but is a _conduit_ for subtle, hidden 
violence.

Yes, sometimes you can get lucky in small startups, small OSS projects or 
individual kernel subsystems where everyone is really on the same page, 
where there's perfect awareness of all things technical, where there's a 
perfect match and people rhyme with each other.

The Linux kernel is not such a small startup anymore. Work reaches Linus 
in bursts of 3 months, and activity is not micro-managed. There's no 
universal awareness so larger conflicts are preprogrammed into this model, 
and I think it's better to be honest and direct early on, instead of 
letting people go in the wrong direction for extended periods of time. 

It's still a lot of fun, but it cannot possibly be a conflict-free zone 
IMO, without us growing a much larger brain.

> An extremely good rule of thumb for when you are communicating 
> emotionally is to make "I" statements.
> 
>   I don't give a #&*%$ if it fixes a bug - it introduces a @*#$$ regression
>   and that @#$*%@ is not acceptable. Ever.
> 
> is, in my mind, perfectly acceptable. [...]

While I obviously find it acceptable too, that's just a cultural 
preference that cannot be converted into some sort of generic "it is 
universally acceptable" form.

[ For example if you inject that above sentence into a Japanese corporate
  email communication and make it pass from CEO to a lower subordinate 
  then you could easily see a suicide as a result. ]

What matters is the cultural context - and sure as hell Linus has always 
communicated without suppressing his emotions too much.

As the person who started this project he's certainly entitled to setting 
the initial boundaries of the communication culture. I think it's people 
coming in that have to convince him that changing that is beneficial. What 
you cannot do is to blanket claim that 'acting professionally' is some 
magically good thing everyone knows to be beneficial.

> [...]  Saying
> 
>   You've $%^@$% done it again.
> 
> is not helpful.

Well, unless it's the second messed up pull request that day. (I managed 
to do that once in a merge window, a couple of years ago, and boy was 
Linus unhappy.)

But I really don't think Linus gratuitously insults people in an 
unprovoked way. If people keep clinging to indefensible, refuted positions 
then maybe Linus will eventually question their general mental health very 
directly, but at that point that's really just stating an inconvenient 
fact...

> http://en.wikipedia.org/wiki/I-message
> 
> (*) One of the amusing things about this whole discussion is that 
> different people seem that have very different ideas about what the core 
> issue really is.

There was never really a 'core issue' that I've seen stated clearly by the 
anti-colorful-language side, just confused suggestions resulting out of 
cultural bias or resulting out of being unaware of the many substitute 
forms of hidden violence that can thrive in politically correct email 
communications.

Thanks,

	Ingo
