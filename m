Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3GRNXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:23:42 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38931 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab3GRNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:23:40 -0400
Date: Thu, 18 Jul 2013 09:23:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: CAI Qian <caiqian@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130718132327.GB30405@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	CAI Qian <caiqian@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>,
	Darren Hart <dvhart@linux.intel.com>
References: <20130715155202.GC29526@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
 <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
 <1374119254.6458.220.camel@gandalf.local.home>
 <305037674.2433057.1374120078349.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305037674.2433057.1374120078349.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:01:18AM -0400, CAI Qian wrote:
> > > Could victim be someone else in the future since it is an example that
> > > people may follow?

Is Nik Wallenda an abuser because he walked across the Grand Canyon on
a tightrope without a safety net, and that's an example that other
people might follow (and fail at)?  Seriously, the argument that
someone are responsible for the actions and decisions of others is a
pretty weak one.

> > > http://en.wikipedia.org/wiki/Silvio_Berlusconi_underage_prostitution_charges
> > > It called "abuse of office" or abuse of the power.
> > 
> > Wow! You are now comparing Linus to a Prime Minister that has paid
> > underage prostitutes for sex?
> I apologize that this leads to misunderstanding. It was just happened to
> read the news that underage child does not feel like she is a victim
> either while the law still think that is an abuse.

Please show us the law which states that the language a coach might
use to his team players is "abuse".

And I think one of the big differences here is that there is a
gargantuan power differential between the Italian Prime Minister and
an underage prostitute.  The power differential between Linus and his
top subsystem maintainers?  Not so much.  Linus does not have hiring
and firing power over us, and since he works at a non-profit which
doesn't have stock options or a profit sharing agreement, he may be
making less money than compared to some of his top lieutenants.

So I'd suggest that people who are flinging around words like "abuse"
stop.  It's not helping your case, because it's not an accurate
description of what's going on.  Even if you believe that it really is
abuse, from a tactical point of view, do you think telling subsystem
maintainers (who have maintained that they do not feel personally
attack, and do not feel abused), that they are too stupid to realize
that they are really hapless victims is likely to make them listen to
your point of view?

There are much stronger arguments that can be made for more "civility".

Regards,

						- Ted
