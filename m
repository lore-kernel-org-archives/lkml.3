Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3GRDrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:47:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3GRDrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:47:36 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=8pif782wAAAA:8 a=WvReu7qsAAAA:8 a=sGiUFW_jAAAA:8 a=Yk0LXWlqWQjVu4L9nkQA:9 a=QEXdDO2ut3YA:10 a=1sPhbhFeNFkA:10 a=PYa3-Kt2IoYX8qBM:21 a=IVrkdwzQ_SMAROSZ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374119254.6458.220.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: CAI Qian <caiqian@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Date: Wed, 17 Jul 2013 23:47:34 -0400
In-Reply-To: <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
References: <20130715155202.GC29526@xanatos>
	 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos>
	 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	 <20130715195316.GF15531@xanatos>
	 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
	 <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 23:16 -0400, CAI Qian wrote:

> > So if you talk about abuse, then you need an abuser and a victim. So
> > your argumentation falls flat because there is no victim.
> Could victim be someone else in the future since it is an example that
> people may follow?
> http://en.wikipedia.org/wiki/Silvio_Berlusconi_underage_prostitution_charges
> It called "abuse of office" or abuse of the power.

Wow! You are now comparing Linus to a Prime Minister that has paid
underage prostitutes for sex?

That's pretty low.

What Linus does is not an abuse of power, it's a protection of his baby.
He created Linux, and although today he's not the one writing the code,
he is ultimately the front man responsible for the kernel.

Think about it. If Linux does something horrible, Linus is the one that
takes the most blame. That's a HUGE responsibility. Linus has the most
to lose if Linux becomes crap.

Not only does Linus have to check on code, he must also dictate policy.
Which means dealing with different people, and how they work. If someone
gets lazy and uses his trust to get something whacky in, Linus takes the
blame for it if that happens. Thus, to prevent people from taking
advantage of his trust, he has to be hard on them to make sure he can
keep their trust.

Linus takes his job seriously. He may joke and name his kernel after
90's operating systems, but that's just to make the job more fun. But to
keep the job, he needs to be a hard ass.

The few times he's yelled at me, he always did it with a bit of comedy
and wit. That makes the harsh yelling not so bad, and I actually got a
chuckle out of it. But I also took the harsh yelling in a way that I had
better not do that again.

This is the big leagues folks. You think major league baseball managers
are nice to their players?

"You just walked 4 players. That's not good. Keep this up I'll have to
take you out off the team".

  vs

"What the f*ck is wrong with you. Get you head out of your @ss and start
throwing the ball over the God damn plate before I throw your @ss out of
this field!"

They both relay basically the same thing. The first one is nice and
polite but states that bad things will happen if they keep it up. The
second is quite harsh (although never calling the person a name), and
will probably wake the person up and change his game. Which one of those
tones do you think successful baseball managers use?

Sometimes tone *does* matter. You want quality from the top maintainers,
and they start to slack, you can't just treat them like this is a grade
school sport. Results matter. You want them to understand that this is
serious and cursing someone out gives that person that feeling.

-- Steve


