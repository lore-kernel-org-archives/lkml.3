Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3GPQQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:16:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab3GPQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:16:42 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BvhdhFe28WsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LhvmM_GddXoA:10 a=4xMmcEmcisl-wHsFKvUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373991399.6458.6.camel@gandalf.local.home>
Subject: Re: [ATTEND] How to act on LKML
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chris Ball <cjb@laptop.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Tue, 16 Jul 2013 12:16:39 -0400
In-Reply-To: <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com>
References: <20130715174659.GC15531@xanatos>
	  <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	  <20130715180403.GD15531@xanatos>
	  <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	  <20130715184642.GE15531@xanatos>
	  <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	  <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	  <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	  <1373926109.17876.221.camel@gandalf.local.home>
	  <20130715223615.GI15531@xanatos> <1373932170.28142.24.camel@envy.home>
	  <864nbv9qcm.fsf@void.printf.net>
	 <1373944014.17876.255.camel@gandalf.local.home>
	 <51E4BFA9.1030600@zytor.com>
	 <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 16:49 +0100, Stefano Stabellini wrote:

> I have been hacking in several different Open Source communities during
> the last few years, including qemu-devel, xen-devel, linux-arm and the
> lkml of course.
> 
> The etiquette on the lkml is by far the roughest of them all. It's the

It's also the largest of them all.

> "bad neighborhood with guns" of the Open Source world. You never know
> when you are going to get a bullet, but sooner or later you'll get one.

It just seems that way as it is so large. LKML has the most people and
will also have the biggest conflict in personalities. It just goes with
the territory.

> 
> I think that it's hurting Linux and in particular it's hurting
> attracting new talents.

Then why do we have the largest # of developers than any other Open
Source project?


>   Not just devs for hire but people passionate
> about what they do and eager to become more involved in the project.
> I met more than one good ex-Linux hacker that decided to move to do
> other things because of this.

Honestly, I think LKML over the years has become more tame. Yeah, back
in 2005 it was rather harsh, but I don't really see that anymore. I
don't see the nasty flame wars going on. Everything seems to be focused
more on the technical side, and there's really very little personal
attacks out there. Sure, with 15,000 emails a month, you get a few. And
Linus will get fed up and burst. But they are really few and far
between. And sometimes, a Linus burst gets things moving along much
faster than being "professional". You think ARM would have gotten their
act together as quick as they did if Linus didn't curse them out and
threaten to stop pulling their crap?

-- Steve


