Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3GOReJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:34:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:26037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab3GOReF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="345957455"
Message-ID: <1373909635.3475.173.camel@envy.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Darren Hart <dvhart@linux.intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Mon, 15 Jul 2013 10:33:55 -0700
In-Reply-To: <20130715155202.GC29526@xanatos>
References: <20130715155202.GC29526@xanatos>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 08:52 -0700, Sarah Sharp wrote:
> On Fri, 12 Jul 2013 18:17:08 +0200, Ingo Molnar <mingo@kernel.org> wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Fri, Jul 12, 2013 at 8:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > >
> > > > I tend to hold things off after -rc4 because you scare me more than Greg
> > > > does ;-)
> > > 
> > > Have you guys *seen* Greg? The guy is a freakish giant. He *should*
> > > scare you. He might squish you without ever even noticing.
> > 
> > Greg might be a giant and he might squish people without ever even 
> > noticing, but that's just a grave, deadly physical threat no real kernel 
> > hacker ever feels threatened by. (Not much can hurt us deep in our dark 
> > basements after all, except maybe earthquakes, gamma ray eruptions and Mom 
> > trying to clean up around the computers.)
> > 
> > So Greg, if you want it all to change, create some _real_ threat: be frank 
> > with contributors and sometimes swear a bit. That will cut your mailqueue 
> > in half, promise!
> 
> On Fri, 12 Jul 2013 08:22:27 -0700, Linus wrote:
> > Greg, the reason you get a lot of stable patches seems to be that you
> > make it easy to act as a door-mat. Clearly at least some people say "I
> > know this patch isn't important enough to send to Linus, but I know Greg
> > will silently accept it after the fact, so I'll just wait and mark it
> > for stable".
> >
> > You may need to learn to shout at people.
> 
> Seriously, guys?  Is this what we need in order to get improve -stable?
> Linus Torvalds is advocating for physical intimidation and violence.
> Ingo Molnar and Linus are advocating for verbal abuse.
> 
> Not *fucking* cool.  Violence, whether it be physical intimidation,
> verbal threats or verbal abuse is not acceptable.  Keep it professional
> on the mailing lists.
>
> Let's discuss this at Kernel Summit where we can at least yell at each
> other in person.  Yeah, just try yelling at me about this.  I'll roar
> right back, louder, for all the people who lose their voice when they
> get yelled at by top maintainers.  I won't be the nice girl anymore.
> 
> Sarah Sharp


Having sent Greg an inappropriate device support patch (for stable)
right smack dab in the middle of this thread, what I can say as a
developer who tends to have to work all over the place in the kernel,
is that deriving the rules is still difficult (as Guenter Roeck has
alluded to in his posts here).

Greg's response to me was direct, informative, and maybe just a little
bit shame-inducing "You know better than that." I know Greg well enough
not to take that personally and I can see him saying that with a smile
on his face, so no complaints there. However, the truth is, I didn't
know better because despite having read the docs, it wasn't clear to
me. Part of the reason there is the language used wasn't clear to me,
specifically "New device IDs and quirks are also accepted". I took
quirks to mean augmenting existing drivers to handle new devices with
subtle changes when in fact it meant something more along the lines of
a couple of lines to add device IDs and existing quirks to a new
device. Greg provided me with example commit IDs which met that
requirement (and perhaps such examples should be added to the docs).

I believe we could improve that documentation to help clarify the
requirements to people that don't work with it everyday. I have offered
to have a look and see what would have made it more clear to me, and I
will do that.

I do believe our processes are becoming a bit fragmented. While every
maintainer certainly needs some autonomy to be able to define how
people work with them in order to maximize their efficiency, the
difference (or lack thereof) between -RC4 and stable wasn't clear to
me, and couldn't be deduced from stable_kernel_rules. Guenter mentioned
some tribal-knowledge associated with /net rules (which I had just
unwittingly violated in the patch mentioned above). I wonder if we
could somehow merge policies where possible, and document those that
should be different in a place where people are likely to find them -
perhaps associated with get_maintainer.pl since anyone submitting
patches should be checking that output anyway.

In summary, better consolidated documentation using language that is
clear to non-subsystem-experts and less tribal knowledge. If people
don't read the documentation that we put in front of their nose....
well, then I suppose we can scold them a bit.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

