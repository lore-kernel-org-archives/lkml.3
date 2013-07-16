Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab3GPVJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:09:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:33653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3GPVJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,679,1367996400"; 
   d="scan'208";a="346642476"
Date: Tue, 16 Jul 2013 14:08:56 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130716210856.GF4994@xanatos>
References: <20130715155202.GC29526@xanatos>
 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <20130715191727.GC10157@1wt.eu>
 <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
 <8738rf14zl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738rf14zl.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 02:22:14PM +0930, Rusty Russell wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > On Mon, Jul 15, 2013 at 12:17 PM, Willy Tarreau <w@1wt.eu> wrote:
> >>
> >> BTW, I was amazed that you managed to get him have a much softer tone inr
> >> his last e-mail, you probably found a weakness here in his management
> >> process :-)
> >
> > Hey, I _like_ arguing, and "cursing" and "arguing" are actually not at
> > all the same thing.
> >
> > And I really don't tend to curse unless people are doing something
> > stupid and annoying. If people have concerns and questions that I feel
> > are valid, I'm more than happy to talk about it.
> >
> > I curse when there isn't any argument. The cursing happens for the
> > "you're so f*cking wrong that it's not even worth trying to make
> > logical arguments about it, because you have no possible excuse" case.
> >
> > .. and sometimes people surprise me and come back with a valid excuse
> > after all. "My whole family died in a tragic freak accident and my
> > pony got cancer, and I was distracted".
> >
> > And then I might even tell them I'm sorry.
> >
> > No. Not really.
> 
> You have to be harsh with code: People mistake politeness for
> uncertainty.  Whenever I said 'I prefer if you XYZ' some proportion
> didn't realize I meant 'Don't argue unless you have new facts: do XYZ or
> go away.'  This wastes my time, so I started being explicit.
> 
> But be gentle with people.  You've already called their baby ugly.

Rusty hit the nail on the head here.  I want everyone (including Linus)
to be harsh with code but gentle with people.

I personally don't care if emails are peppered with a little cussing.
You can see I've included some words like "fuck" in my emails too.
However, I object to how the cursing is *directed*.

In the x86 email [1], you could argue that Linus' tone was pretty
grumpy, maybe even abrasive.  However, he was criticizing *code* when he
cursed:


"This piece-of-shit commit is marked for stable, but you clearly never
even test-compiled it, did you?"

"I made the mistake of doing multiple merges back-to-back with the
intention of not doing a full allmodconfig build in between them, and
now I have to undo them all because this pull request was full of
unbelievable shit."

"And why the hell was this marked for stable even *IF* it hadn't been
complete and utter tripe? It even has a comment in the commit message
about how this probably doesn't matter."


Linus is complaining about code here, and the effects of merging bad
code on his own tree.  I personally have no qualms with this type of
harsh email, because it focuses on the code, not the person.

I do, however, object when the verbal abuse shifts from being directed
at code to being directed at *people*.  For example, Linus chose to
curse at Mauro [2] and Rafael [3], rather than their code:


"Mauro, SHUT THE FUCK UP!"

"How long have you been a maintainer? And you *still* haven't learnt the
first rule of kernel maintenance?"

"Shut up, Mauro. And I don't _ever_ want to hear that kind of obvious
garbage and idiocy from a kernel maintainer again. Seriously."

"The fact that you then try to make *excuses* for breaking user space,
and blaming some external program that *used* to work, is just
shameful. It's not how we work."

"Fix your f*cking "compliance tool", because it is obviously broken.
And fix your approach to kernel programming."

"Seriously. Why do I even have to mention this? Why do I have to
explain this to somebody pretty much *every* f*cking merge window?"

"And btw, the *reason* for that rule becoming such a hard rule was
pretty much exactly suspend/resume and ACPI. Exactly because we used
to have those infinite "let's fix one thing and break another" dances.
So you should be well acquainted with the rule, and I'm surprised to
hear that kind of utter garbage from you in particular."


The personally directed verbal abuse is what I'm complaining about here.
Linus goes from 0 to 11 at the drop of an "I don't think this is a
regression" comment, and publicly ridicules his top maintainers.

This is not right.  This is not a community that people want to be a
part of, except for a few top-tier maintainers who have "tough skins".
No one should have to be the focus of a fire hose of personal verbal
abuse.

We're adults, not high schoolers.  We can figure out how to deliver
harsh technical criticism without resorting to name calling, cussing at
people, or personal attacks.

If a maintainer is not doing their job, Linus should send them a private
harsh email, and a public email that simply says, "I'm reverting this
pull request because of X.  If this continues through the next merge
window, this maintainer will need to train a replacement."  Don't
publicly tear them to pieces because they made a simple mistake.


The definition of insanity is repeating the same thing, over and over,
expecting the result to be different.  Linus keeps repeating the same
mantras over and over to maintainers that forget rules like, "No
regressions."

Why aren't we trying different tactics?  Why aren't we improving our
documentation so maintainers don't have to repeat themselves?

Sarah Sharp

[1] https://lkml.org/lkml/2013/7/13/132
[2] http://marc.info/?l=linux-kernel&m=135628421403144&w=2
[3] http://marc.info/?l=linux-acpi&m=136157944603147&w=2
