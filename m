Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab3GSJXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:23:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43755 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:23:01 -0400
Date: Fri, 19 Jul 2013 11:22:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: mistakes in code vs. maintainer flow mistakes (was: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130719092256.GC25784@gmail.com>
References: <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <20130718103907.GC23558@gmail.com>
 <20130718160754.GC5440@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718160754.GC5440@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> On Thu, Jul 18, 2013 at 12:39:07PM +0200, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Mon, Jul 15, 2013 at 1:41 PM, Sarah Sharp
> > > <sarah.a.sharp@linux.intel.com> wrote:
> > > >
> > > > Oh, FFS, I just called out on private email for "playing the victim
> > > > card".  I will repeat: this is not just about me, or other minorities.
> > > > I should not have to ask for professional behavior on the mailing lists.
> > > > Professional behavior should be the default.
> > > 
> > 
> > > [...]
> > > 
> > > Because if you want me to "act professional", I can tell you that I'm 
> > > not interested. I'm sitting in my home office wearign a bathrobe. The 
> > > same way I'm not going to start wearing ties, I'm *also* not going to 
> > > buy into the fake politeness, the lying, the office politics and 
> > > backstabbing, the passive aggressiveness, and the buzzwords. Because 
> > > THAT is what "acting professionally" results in: people resort to all 
> > > kinds of really nasty things because they are forced to act out their 
> > > normal urges in unnatural ways.
> > 
> > Sarah, that's a pretty potent argument by Linus, that "acting 
> > professionally" risks replacing a raw but honest culture with a
> > polished but dishonest culture - which is harmful to developing
> > good technology.
> > 
> > That's a valid concern. What's your reply to that argument?
> 
> I don't feel the need to comment, because I feel it's a straw man 
> argument.  I feel that way because I disagree with the definition of 
> professionalism that people have been pushing.

I hope you won't take this as a sign of disrespect, but it's hard to keep 
up with your somewhat fluid opinion about what exactly you find 
objectionable :-/

Early in the thread you claimed it's about politeness:

> Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
>
> [...] I've seen you be polite, and explain to clueless maintainers why 
> there's no way you can revert their merge that caused regressions, and 
> ask them to fit it without resorting to tearing them down emotionally:
>
>   http://marc.info/?l=linux-kernel&m=136130347127908&w=2
>
> You just don't want to take the time to be polite to everyone.  Don't 
> give me the "I'm not polite" card.  Go write some documentation about 
> what's acceptable for stable.

But now you claim something else, it's OK to be impolite, it's just not OK 
to do XYZ ... and it's unclear to me what you mean under XYZ exactly. 
Right now you say XYZ is "disrespect":

> To me, being "professional" means treating each other with respect.  I 
> can show emotion, express displeasure, be direct, and still show respect 
> for my fellow developers.

But what is there to respect about a colossal maintainer f*ck-up, which is 
inextricably tied to the person? Do you really think if Linus replaced 
this:

 "  Ingo, this is just so mind-boggingly STUPID, how did you even f*cking 
    THINK of doing something like that??  "

with a respectful and still truthful statement:

 "
   Ingo, I fully respect you [*] but this is just mind-boggingly
   STUPID, how did you even f*cking THINK of doing something like that??

   [*] Unless you keep doing such sh*t too many times, of course. Then I
       won't respect you anymore and will ignore your patches. You are not 
       my friend, you are a top level maintainer in a meritocracy. There's 
       a way both up and down.
 "

then I would not feel just as bad about it all?

> For example, I find the following statement to be both direct and 
> respectful, because it's criticizing code, not the person:
> 
> "This code is SHIT!  It adds new warnings and it's marked for stable 
> when it's clearly *crap code* that's not a bug fix.  I'm going to revert 
> this merge, and I expect a fix from you IMMEDIATELY."
> 
> The following statement is not respectful, because it targets the 
> person:
> 
> "Seriously, Maintainer.  Why are you pushing this kind of *crap* code to 
> me again?  Why the hell did you mark it for stable when it's clearly not 
> a bug fix?  Did you even try to f*cking compile this?"

Well, but often it's the action of the maintainer that what was wrong, not 
the patch primarily.

Mistakes in patches and code happen all the time. Linus rarely if ever 
flamed me for _that_ - sh*t happens.

What he flames me for, and what you (with all due respect) still don't 
seem to understand, are _META_ mistakes. Top level maintainer level 
mistakes. Bad patterns of maintainer behavior that really should not occur 
because they could affect many patches in the future, such as:

 - trying to argue regressions away - i.e. not 'shutting up' in time, 
   being a meta hindrance to problem resolution

 - doing a sloppy Git flow, repeatedly

 - not testing adequately, especially when the pull request occurs at a 
   critical time (such as a couple of hours before -rc1)

 - [ and many other meta mistakes ]

None of those arguments are about code and still I fully expect Linus to 
pin those on me if he notices a meta bug in my behavior and finds it 
dangerous.

> I would appreciate it if people would replace the word "professional" 
> with "respectful" in this thread.  It means something different to me 
> than other people, and respect is much closer to what I'm looking for.
> 
> I would appreciate it if kernel developers would show respect for each 
> other, while focusing on criticizing code.  As Rusty said, be gentle 
> with people.  You've called their baby ugly.

But Linus doesn't really criticise mistakes in code primarily when he 
flames top level maintainers!

Read the very examples you dug out of the lkml archives, the Linus "worst 
of" list. Sure, some bad code is almost always part of a specific 
incident, but primarily he criticises the maintainer flow, and that is 
fundamentally tied to the _person_.

_That_ is why it might look to you as if the person was attacked, because 
indeed the actions of the top level maintainer were wrong and are 
criticised.

... and now you want to 'shut down' the discussion. With all due respect, 
you started it, you have put out various heavy accusations here and 
elsewhere, so you might as well take responsibility for it and let the 
discussion be brought to a conclusion, wherever that may take us, compared 
to your initial view?

Thanks,

	Ingo
