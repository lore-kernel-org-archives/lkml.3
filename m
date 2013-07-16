Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3GPEMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:12:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:27696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3GPEMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,673,1367996400"; 
   d="scan'208";a="346242035"
Message-ID: <1373947920.12825.2.camel@envy.home>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
From: Darren Hart <dvhart@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: NeilBrown <neilb@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Mon, 15 Jul 2013 21:12:00 -0700
In-Reply-To: <1373945863.17876.264.camel@gandalf.local.home>
References: <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos>
	 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	 <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <1373926109.17876.221.camel@gandalf.local.home>
	 <20130715223615.GI15531@xanatos> <20130715231555.GA24650@roeck-us.net>
	 <1373933850.17876.224.camel@gandalf.local.home>
	 <20130716131446.373ec08b@notabene.brown>
	 <1373945681.17876.262.camel@gandalf.local.home>
	 <1373945863.17876.264.camel@gandalf.local.home>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:37 -0400, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 23:34 -0400, Steven Rostedt wrote:
> > On Tue, 2013-07-16 at 13:14 +1000, NeilBrown wrote:
> > 
> > > Surely there is an enormous difference between being required to defend your
> > > position against rational and forceful argument, and being required to defend
> > > it against irrelevant name calling.
> > 
> > Sure, but I don't think there's really much name calling in the kernel
> > community.
> > 
> > I just scanned a large number of LKML emails, and they all seemed rather
> > technical, and no personal attacks at all. And that included several
> > emails from Linus as well. Probably the strongest email came from Thomas
> > Gleixner, but even that didn't contain any personal name calling. Mostly
> > he called stuff "crap" but that was about the code and claims that the
> > code did, but not about the person.
> > 
> > There are a few times that Linus gets a bit colorful with his
> > criticisms, but that's really the minority of the email and not the
> > overall tone. I think Linus picks his battles. Sometimes he goes
> > overboard, but he's human. But I still think he's running this ship
> > well.
> > 
> 
> I just found this gem: https://lkml.org/lkml/2013/7/10/600
> 
> But it's just Linus ranting about having "make install" modify the
> source tree (which I totally agree with him, as I've stumbled over crap
> like this in other projects). But he's bitching about the code, not the
> person who asked him to pull it.

Excellent example Steve. This is the core of what I was trying to get
at. Linus vehemently and colorfully expressed his distate for *problem*
and told the developer what they needed to do differently. No personal
attack there.

Would I like to be on the receiving end of that email... No, I would
not. However, I can also understand being fed up with lots of little
things like this and not having the patience or the desire to treat each
one as a mentoring opportunity. The difference tends to be I rant to my
close friends and Linus does so in public.... he's the more honest of
the two of us I think :-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

