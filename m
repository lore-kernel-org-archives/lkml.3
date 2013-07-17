Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3GQD2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:28:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:44830 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab3GQD2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,682,1367996400"; 
   d="scan'208";a="371434161"
Message-ID: <1374031686.12825.143.camel@envy.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 16 Jul 2013 20:28:06 -0700
In-Reply-To: <CA+55aFw9E4mORqJaC+5n_dy8GgiQN6QRZh3-2GH99sedrYoEkA@mail.gmail.com>
References: <20130715155202.GC29526@xanatos>
	 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	 <20130715174659.GC15531@xanatos>
	 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu>
	 <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
	 <8738rf14zl.fsf@rustcorp.com.au> <20130716210856.GF4994@xanatos>
	 <878v16yp57.fsf@rustcorp.com.au>
	 <CA+55aFw9E4mORqJaC+5n_dy8GgiQN6QRZh3-2GH99sedrYoEkA@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 18:37 -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 6:02 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >>
> >> "Mauro, SHUT THE FUCK UP!"
> >
> > This one crosses the line.  There's no non-offensive way to tell a geek
> > "you are wrong", but this isn't even trying.  Bad Linus!
> 
> You know what? Not my proudest moment. I was really upset.

This goes a long way to resolving the stated issues in my opinion. Of
the three issues raised, Linus has either adequately justified himself
or conceded. This wasn't meant to be Linus on trial was it? :-)

I'm sure we could dig up a thousand more references of "bad" behavior
from others on LKML. Before we do let's first make sure the recipient is
not being "resistant to education" (a phrase I've picked up from Thomas
Gleixner and like very much) or has somehow provoked things. Ted Ts'o
will recall fondly all the pigs in guinea *smirk*.

I enjoy a good rant as much as anyone, but I recognize personal attacks
can be very harmful to the individual and possibly (difficult to prove)
the quality of the project. This is especially true when coming from
someone that is held in very high regard, such as Linus and the other
maintainers.

I think the one tangible TODO that has come out of this is to DOCUMENT
expectations. Paul Gortmaker has already submitted a netdev FAQ which I
have reviewed and David Miller approved of. I have committed to review
stable_kernel_rules. It appears there is also call to have Linus'
expectations of the maintainers documented. This would also be good for
everyone to read to better understand the responses they receive from
maintainers and why things are the way they are.

With that done, I think some tolerance in both directions would improve
things here. And as a last resort, we speak up when someone is under
attack.

"Whoa Nelly, calm down, don't forget your meds. Seriously though, that
(is not acceptable code|violates a core policy), see the following
documentation." This adds some burden on the broader audience to point
people at the docs, because even RTFM has to get annoying to repeat too
often.

And with that, I'll sign out of this thread unless anyone wants to
discuss documentation - but those should probably happen on LKML (or
maybe KS as some have suggested).

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


