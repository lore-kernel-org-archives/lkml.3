Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3GQJjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:39:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39432 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3GQJjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:39:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,683,1367971200"; 
   d="scan'208";a="37459821"
Date: Wed, 17 Jul 2013 10:38:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jiri Kosina <jkosina@suse.cz>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Ball <cjb@laptop.org>, Darren Hart <dvhart@linux.intel.com>,
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
In-Reply-To: <alpine.LRH.2.00.1307170038390.20418@twin.jikos.cz>
Message-ID: <alpine.DEB.2.02.1307171017580.8258@kaball.uk.xensource.com>
References: <20130715174659.GC15531@xanatos>   <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>   <20130715180403.GD15531@xanatos>   <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>   <20130715184642.GE15531@xanatos>
   <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>   <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>   <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>   <1373926109.17876.221.camel@gandalf.local.home>
   <20130715223615.GI15531@xanatos> <1373932170.28142.24.camel@envy.home>   <864nbv9qcm.fsf@void.printf.net>  <1373944014.17876.255.camel@gandalf.local.home>  <51E4BFA9.1030600@zytor.com>  <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com>
 <1373991399.6458.6.camel@gandalf.local.home> <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com> <alpine.LRH.2.00.1307170038390.20418@twin.jikos.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Jiri Kosina wrote:
> On Tue, 16 Jul 2013, Stefano Stabellini wrote:
> 
> > > > I think that it's hurting Linux and in particular it's hurting
> > > > attracting new talents.
> > > 
> > > Then why do we have the largest # of developers than any other Open
> > > Source project?
> > 
> > Because Linux is the most widely used kernel, it's everywhere from
> > embedded devices to supercomputers.
> 
> And that's because ... ?
> 
> Yes, because the community has been very open since its very beginning 
> (and this is not "being open about why I hate you personally", but this is 
> "being open about what I think about your code").

Being open about what I think about your code doesn't mean that I can
feel free to verbally attack you.


> Plus there is a *LOT* of humor and sarcasm in all that. Which just 
> contributes to working on linux kernel being fun. I'd absolutely like to 
> keep that spirit.
> 
> If you guys now start telling others what is allowed and what is forbidden 
> to say, you are going to destroy this completely.
> 
> I don't want to be a part of a community where you have to read a legal 
> code before you can speak without fear of being accused of verbal 
> violence.
> 
> This just doesn't fit into how people of my culture see the world; hence, 
> I may even feel offended by Sarah's proposal (i.e. being very restrictive 
> about what I am allowed to say), actually. I like openness, I like 
> sarcasm, I like fun. Anyone who is trying to forbid this just doesn't fit 
> into my culture.

We should be able to prevent verbal abuses without involving legal,
right?
Would a NETIQUETTE file be enough, or would you consider that "legal
code"?


> > > Honestly, I think LKML over the years has become more tame. Yeah, back
> > > in 2005 it was rather harsh, but I don't really see that anymore. I
> > > don't see the nasty flame wars going on. Everything seems to be focused
> > > more on the technical side, and there's really very little personal
> > > attacks out there. Sure, with 15,000 emails a month, you get a few. And
> > > Linus will get fed up and burst. But they are really few and far
> > > between. And sometimes, a Linus burst gets things moving along much
> > > faster than being "professional". You think ARM would have gotten their
> > > act together as quick as they did if Linus didn't curse them out and
> > > threaten to stop pulling their crap?
> >  
> > I think there is a way to get the point across without cursing.
> 
> Maybe there is, maybe there is not.
> 
> I am not cursing in my e-mails, you are probably neither. Linus is. Others 
> are.
> 
> So what? He/they believe they achieves their goal through that mode of 
> operation (and very often they indeed do), as so do we, through different 
> means of communication.
> 
> No need to change anything anywhere. Please let everyone express their 
> feelings the way the believe it's best for achieving their goals, and do 
> the same.

There is a very fine line between cursing and what people might perceive
as a personal attack.
