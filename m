Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab3GSKDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:03:50 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48758 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760045Ab3GSKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:03:48 -0400
Date: Fri, 19 Jul 2013 12:03:42 +0200
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
Subject: Re: mistakes in code vs. maintainer flow mistakes (was: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130719100342.GA26334@gmail.com>
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


* Ingo Molnar <mingo@kernel.org> wrote:

> [...]
> 
> Mistakes in patches and code happen all the time. Linus rarely if ever 
> flamed me for _that_ - sh*t happens.
> 
> What he flames me for, and what you (with all due respect) still don't 
> seem to understand, are _META_ mistakes. Top level maintainer level 
> mistakes. Bad patterns of maintainer behavior that really should not 
> occur because they could affect many patches in the future, such as:
> 
>  - trying to argue regressions away - i.e. not 'shutting up' in time, 
>    being a meta hindrance to problem resolution
> 
>  - doing a sloppy Git flow, repeatedly
> 
>  - not testing adequately, especially when the pull request occurs at a 
>    critical time (such as a couple of hours before -rc1)
> 
>  - [ and many other meta mistakes ]
> 
> None of those arguments are about code and still I fully expect Linus to 
> pin those on me if he notices a meta bug in my behavior and finds it 
> dangerous.

And note that whenever I or a fellow -tip maintainer got such an unhappy 
complaint from Linus in the past couple of years our response wasn't just 
to fix some broken code.

Our response was to fix broken top level maintainer behavior, by applying 
'meta fixes':

  - changing our Git workflow

  - adding more scripting to catch bad commits

  - changing our flow of sending pull requests, adding fail-safes

  - trying to think more neutrally about bug reports to avoid punishing 
    the messenger and to avoid arguing regressions away

  - hardening our review process

  - making sure at least one -tip maintainer watches lkml for bugreports

  - tightening our controls to avoid missed patches

  - thinking about the timing of pull requests

  - etc., etc.

(And there's an even larger body of 'meta fixes' we applied without being 
prodded by Linus.)

On the outside such incidents look like as if Linus flamed 'the person' in 
a disrespectful way.

What Linus _really_ flamed us for in 95% of the cases was the meta 
process, the 'meta code' of Linux, which is not actual source code but 
mostly a social construct, informal patterns of human behavior - and those 
are inextricably embedded in the person.

And because the 'meta fixes' too are often of social nature, what you see 
when reading lkml is just a unidirectional stream of complaints from 
Linus. You typically don't see patch notifications of changed behavior. 
Nor do you see top level maintainers 'speaking up against Linus' very 
often: these are bugreports from Linus and we simply fix them, there's not 
much to speak up against.

Linus is very laissez-faire about maintainence, so whenever he _does_ 
erupt at us (at a clip of ~10,000 commits per cycle that do go in without 
any complaint from Linus) it's justified in a large percentage of cases.

So despite the outside appearance this is not top level Linux maintainers 
being oppressed by Linus or suffering from some sort of Stockholm Syndrome
:-)

We are just as stubborn as Linus and do speak up against Linus when needed 
- it just rarely is necessary - in great part because Linus flames in 
public and takes care he is upset for a good reason so he does not have to 
walk back on his flame. Public embarrassment cuts both ways.

When Linus's complaint is unjustified top level maintainers _do_ speak up 
- see Thomas Gleixner's recent example, which resulted in Linus 
apologizing. (It's a rare occurance and we've archived all the emails for 
the history books.)

Thanks,

	Ingo
