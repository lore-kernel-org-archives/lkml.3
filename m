Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143Ab3GSTBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:01:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:64359 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760944Ab3GSTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,703,1367996400"; 
   d="scan'208";a="270697009"
Date: Fri, 19 Jul 2013 12:01:27 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: mistakes in code vs. maintainer flow mistakes (was: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130719190127.GA12990@xanatos>
References: <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <20130718103907.GC23558@gmail.com>
 <20130718160754.GC5440@xanatos>
 <20130719092256.GC25784@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719092256.GC25784@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:22:56AM +0200, Ingo Molnar wrote:
> 
> * Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> 
> > On Thu, Jul 18, 2013 at 12:39:07PM +0200, Ingo Molnar wrote:
> > > 
> > > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > > > On Mon, Jul 15, 2013 at 1:41 PM, Sarah Sharp
> > > > <sarah.a.sharp@linux.intel.com> wrote:
> > > > >
> > > > > Oh, FFS, I just called out on private email for "playing the victim
> > > > > card".  I will repeat: this is not just about me, or other minorities.
> > > > > I should not have to ask for professional behavior on the mailing lists.
> > > > > Professional behavior should be the default.
> > > > 
> > > 
> > > > [...]
> > > > 
> > > > Because if you want me to "act professional", I can tell you that I'm 
> > > > not interested. I'm sitting in my home office wearign a bathrobe. The 
> > > > same way I'm not going to start wearing ties, I'm *also* not going to 
> > > > buy into the fake politeness, the lying, the office politics and 
> > > > backstabbing, the passive aggressiveness, and the buzzwords. Because 
> > > > THAT is what "acting professionally" results in: people resort to all 
> > > > kinds of really nasty things because they are forced to act out their 
> > > > normal urges in unnatural ways.
> > > 
> > > Sarah, that's a pretty potent argument by Linus, that "acting 
> > > professionally" risks replacing a raw but honest culture with a
> > > polished but dishonest culture - which is harmful to developing
> > > good technology.
> > > 
> > > That's a valid concern. What's your reply to that argument?
> > 
> > I don't feel the need to comment, because I feel it's a straw man 
> > argument.  I feel that way because I disagree with the definition of 
> > professionalism that people have been pushing.
> 
> I hope you won't take this as a sign of disrespect, but it's hard to keep 
> up with your somewhat fluid opinion about what exactly you find 
> objectionable :-/

The good news is you're confused because I've been influenced by some of
the arguments people have made on this thread.  As a result, my
viewpoints may have changed subtly, and I've given up arguing other
points because it's clear people are clinging to certain behaviors, and
I'm not going to change their mind about them.

I apologize for causing confusion, and I will attempt to restate my
current opinion.

There are essential three types of "attacks" that are being discussed on
this thread:

1. Personal attacks
2. Attacks against people's behaviors
3. Attacks against code

People, in general, agree that #3 (attacks on code) is fine.  Most kernel
developers will attempt to be civil when giving code review, and I don't
see an issue with telling someone politely that their code needs to be
fixed.

Many developers have stated they feel it's OK to flame someone that
continues to push bad code over and over without taking the maintainer's
feedback into account.  My issue is that maintainers should try simply
saying, "No, this is bad code, and I WILL NOT take it" before flaming the
individual.  Anything else is simply the maintainer venting their
frustration at the submitter in a public forum.  This could be constituted
as a personal attack, depending on what language is used in the flame
email.

So, #3 (attacks against code) may be appropriate community behavior, but
it's up to the maintainer to decide what language is appropriate, and how
many times they want to be nice before they start to flame someone.

I believe that most kernel developers agree that #1 (personal attacks)
aren't appropriate, but they disagree about what constitutes a personal
attack.  Several kernel developers have expressed that they think #2
(attacks against people's behavior) is socially acceptable, when it comes
infrequently from Linus.

I think the key here is "from Linus".  Research has shown that verbal
abuse and bullying rarely comes from subordinates criticizing people in
power.  The book "No Assholes Rule" cites research that shows only 1% of
subordinates bully their superiors.  That's because people (like me) who
are not in a position of power face intense push back from the community
and personal harassment from jerks on the internet when they question or
cuss at someone in a position of power.  But, it's perfectly socially
acceptable for Linus to cuss out a person below him in the kernel tree
hierarchy.

Do you see the power dynamics issue here?  No one in the community is
willing to call out Linus when he tells Mauro to SHUT THE FUCK UP, which
is a personal attack.  Several people in the community have jumped at
criticizing my use of the word fuck in sentences that are not personal
attacks.  I.e. "If you give a flying fuck about diversity, the kernel
community members should avoid verbal abuse."

There's a severe double standard here.  Let's talk about this elephant in
the room, rather than sweeping it under the rug.


There's a very very fine line between personal attacks and attacks
pointing out people's bad behavior.  In my opinion, developers need to
be very respectful when giving negative feedback on a person's behavior,
in order to make sure the attack isn't perceived as a personal attack.

"Respect" means different things to different people.  Here's a list of
potentially disrespectful behaviors:

 * cussing
 * belittling statements
 * demeaning sarcasm
 * telling someone to SHUT THE FUCK UP
 * overuse of ALL CAPS to prove a point
 * encouraging suicide (telling someone to go kill themselves)
 * hysteria (inappropriate over-reaction to a bad situation)
 * name calling (calling someone stupid, a moron, etc)
 * insulting someone's technical skills
 * making people feel inferior
 * rewriting someone's code and submitting it without credit to them
 * ...and not apologizing for these behaviors when someone proves you
   are wrong about the situation, or over-reacting.

When these behaviors are combined with giving negative feedback on
someone's behavior, some developers may perceive the email as a personal
attack.  That's why I advocate minimizing these behaviors in
communications between Linus and his lieutenants about their bad
behavior as maintainers.


> Early in the thread you claimed it's about politeness:
> 
> > Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> >
> > [...] I've seen you be polite, and explain to clueless maintainers why 
> > there's no way you can revert their merge that caused regressions, and 
> > ask them to fit it without resorting to tearing them down emotionally:
> >
> >   http://marc.info/?l=linux-kernel&m=136130347127908&w=2
> >
> > You just don't want to take the time to be polite to everyone.  Don't 
> > give me the "I'm not polite" card.  Go write some documentation about 
> > what's acceptable for stable.
> 
> But now you claim something else, it's OK to be impolite, it's just not OK 
> to do XYZ ... and it's unclear to me what you mean under XYZ exactly. 

I changed my stated viewpoint, because I'm clearly not going to get
anyone to change their mind about cussing on the mailing list, or
attempting to be civil to people who send crap code.  I can't change any
hearts or minds there, so my focus in the most recent threads has been
on whether we can agree that personal attacks and attacking a person's
behavior is not acceptable.

> Right now you say XYZ is "disrespect":
> 
> > To me, being "professional" means treating each other with respect.  I 
> > can show emotion, express displeasure, be direct, and still show respect 
> > for my fellow developers.
> 
> But what is there to respect about a colossal maintainer f*ck-up, which is 
> inextricably tied to the person? Do you really think if Linus replaced 
> this:
> 
>  "  Ingo, this is just so mind-boggingly STUPID, how did you even f*cking 
>     THINK of doing something like that??  "

Let's see, this includes:
 * name calling
 * insults about your intelligence
 * ALL CAPS

> 
> with a respectful and still truthful statement:
> 
>  "
>    Ingo, I fully respect you [*] but this is just mind-boggingly
>    STUPID, how did you even f*cking THINK of doing something like that??
> 
>    [*] Unless you keep doing such sh*t too many times, of course. Then I
>        won't respect you anymore and will ignore your patches. You are not 
>        my friend, you are a top level maintainer in a meritocracy. There's 
>        a way both up and down.
>  "
> 
> then I would not feel just as bad about it all?

If Linus feels that he needs to use name calling and insults in order to
get his point heard, I would appreciate if he prefaced his statements
with "I respect you, but seriously..."

I think the issue here is that Linus' lieutenants *know* Linus trusts
and respects him, and most of them don't need that prefix to his
emails.  That leads people to look at Linus' email to Mauro, and say
things like, "Linus is just expressing his disappointment that his
maintainer violated his trust by refusing to fix a regression."

https://lkml.org/lkml/2012/12/23/75

The problem is, without the prefix of "I respect you" or "Your pull
requests are normally flawless", outsiders to our community don't
understand the context.  They don't see this as an "I trust you, but you
fucked up" email.  They see this as a verbally abusive message from
Linus.

Perhaps what might help here is a kernel organizational chart.  A graph
of who sends pull requests to Linus, and their subsystem maintainers.
For example, in the USB "branch" there would be:

				Linus Torvalds
			(Linux kernel release engineer)
					|
					|
				Greg Kroah-Hartman
				      (USB)
					|
					|
			-------------------------------------------------
			|		|		|		|
			|		|		|		|
		Sarah Sharp		|		|	   Oliver Neukum
	(USB3 and USB core)		|		|	(USB NCM and auto-suspend)
					|		|
				Alan Stern		|
			(EHCI/UHCI/OHCI and USB core)	|
							|
							|
						Felipe Balbi
					(USB3 plat and USB gadget)

The org chart would help outsiders understand that "this random flame
email" is between two people with a trust link.  If an outsider sees an
email blast from Linus to Greg, they will understand this is a "I trust
you as one of my top lieutenants, and as a maintainer, you fucked up."

There's a couple more benefits from an org chart that would be worth
discussing.

An org chart would be helpful for people submitting patches for the first
time.  If someone submits a patch to a USB driver, they'll know they
really should be listening to feedback from Greg, Alan, Felipe, Oliver,
and me.  If J. Random developer is whinging about coding style issues that
checkpatch didn't catch, the submitter will know that they should take
their feedback with a grain of salt.

(This brings up the issue that there should be a place in the org chart
for trusted reviewers, in the case where they aren't a maintainer of code,
but they do have pull in that corner of the kernel community.)

The org chart is also helpful for showing the "bus factor" of different
parts of the kernel.  If Greg gets hit by a bus, he has four sub-sub
maintainers who could possibly take over maintainership of USB.  Other
kernel subsystems don't have sub-sub maintainers, or even backup
maintainers that could take over if the subsystem maintainer had a family
emergency during the merge window.  An org chart would make those
subsystems that aren't deep enough pretty obvious.

Perhaps which maintainer is next in line should be made explicit.  We have
had people die in the kernel community (like David Brownell), and we
should have a plan for who is the backup maintainer, should the worst
happen.  Greg worked with Alan to ensure that the EHCI driver would
continue to be maintained, and I suspect Alan would be Greg's choice for
USB subsystem maintainership if Greg should kick the bucket.  However, if
Greg wasn't there to ask Alan to be a maintainer for all of USB, or the
four sub-sub maintainers fought amongst themselves for control of the USB
maintainership, then that would cause a lot of unnecessary community
strife.

We could have people's photos attached to their names, so that it's easier
for people who are new the community to find people at conferences, and
know who they're talking to.

Basically, there are a lot of potential positive outcomes of making an org
chart.  Does anyone have any objections to someone making one?

> ... and now you want to 'shut down' the discussion. With all due respect, 
> you started it, you have put out various heavy accusations here and 
> elsewhere, so you might as well take responsibility for it and let the 
> discussion be brought to a conclusion, wherever that may take us, compared 
> to your initial view?

Linus expressed that we should be doing our jobs as kernel maintainers,
rather than "talking around the water cooler" about this issue:

http://lkml.org/lkml/2013/7/18/426

I'm not trying to shut down this discussion.  But please, let's continue
this discussion at KS, away from the court of public opinion.  I would
love for this email to serve as a final summary of my opinion.  We can
use this email to start a conversation at KS, and we can argue our
hearts out there about the various points.

Just please, let me do my job as a kernel maintainer, and please stop
replying to this conversation.  I can only write so many long emails a
day without it cutting into my time for writing code and debugging USB
issues.

Move on, agree to disagree, and let's discuss this at KS.

Sarah Sharp
