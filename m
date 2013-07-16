Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3GPQ6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:58:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39822 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3GPQ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:58:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,678,1367971200"; 
   d="scan'208";a="35505335"
Date: Tue, 16 Jul 2013 17:58:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chris Ball <cjb@laptop.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        <ksummit-2013-discuss@lists.linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [ATTEND] How to act on LKML
In-Reply-To: <1373991399.6458.6.camel@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com>
References: <20130715174659.GC15531@xanatos>   <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>   <20130715180403.GD15531@xanatos>   <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>   <20130715184642.GE15531@xanatos>
   <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>   <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>   <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>   <1373926109.17876.221.camel@gandalf.local.home>
   <20130715223615.GI15531@xanatos> <1373932170.28142.24.camel@envy.home>   <864nbv9qcm.fsf@void.printf.net>  <1373944014.17876.255.camel@gandalf.local.home>  <51E4BFA9.1030600@zytor.com>  <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com>
 <1373991399.6458.6.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 16:49 +0100, Stefano Stabellini wrote:
> 
> > I have been hacking in several different Open Source communities during
> > the last few years, including qemu-devel, xen-devel, linux-arm and the
> > lkml of course.
> > 
> > The etiquette on the lkml is by far the roughest of them all. It's the
> 
> It's also the largest of them all.
> 
> > "bad neighborhood with guns" of the Open Source world. You never know
> > when you are going to get a bullet, but sooner or later you'll get one.
> 
> It just seems that way as it is so large. LKML has the most people and
> will also have the biggest conflict in personalities. It just goes with
> the territory.

Even though the LKML is probably the largest Open Source community,
there are other groups out there of similar size.
I don't believe that in order to scale up we need to be like this.


> > I think that it's hurting Linux and in particular it's hurting
> > attracting new talents.
> 
> Then why do we have the largest # of developers than any other Open
> Source project?

Because Linux is the most widely used kernel, it's everywhere from
embedded devices to supercomputers.
Many different companies make a business on Linux and pay people to work
on it (not FreeBSD or NetBSD). But that's different from what I was
saying below. Also not all the sub-groups within the kernel development
circles work this way.

Or maybe there are just enough brilliant kernel developers that don't
care.


> >   Not just devs for hire but people passionate
> > about what they do and eager to become more involved in the project.
> > I met more than one good ex-Linux hacker that decided to move to do
> > other things because of this.
> 
> Honestly, I think LKML over the years has become more tame. Yeah, back
> in 2005 it was rather harsh, but I don't really see that anymore. I
> don't see the nasty flame wars going on. Everything seems to be focused
> more on the technical side, and there's really very little personal
> attacks out there. Sure, with 15,000 emails a month, you get a few. And
> Linus will get fed up and burst. But they are really few and far
> between. And sometimes, a Linus burst gets things moving along much
> faster than being "professional". You think ARM would have gotten their
> act together as quick as they did if Linus didn't curse them out and
> threaten to stop pulling their crap?
 
I think there is a way to get the point across without cursing.
One can be clear and decisive without "bursting". It's easy to mistake
cursing on the quality of the code for a personal attack.

When HPA wrote "I find it utterly impossible to be offended by it", that
might be true for Linus' rants and I also find them humorous sometimes.
But unfortunately this kind of behavior is by no means limited to Linus
and it's easy to misunderstand, especially when you don't know the
person.
