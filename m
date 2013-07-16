Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab3GPDhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:37:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab3GPDhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:37:46 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=yDfxGvREtdsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5Bi_wUEe0twA:10 a=D19gQVrFAAAA:8 a=xU9RLNg_nzVdmFSpTo8A:9 a=QEXdDO2ut3YA:10 a=hMgbWMpCMgYgYTS5:21 a=Ah78zc4SEQ7QbUQ0:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373945863.17876.264.camel@gandalf.local.home>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
From: Steven Rostedt <rostedt@goodmis.org>
To: NeilBrown <neilb@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Mon, 15 Jul 2013 23:37:43 -0400
In-Reply-To: <1373945681.17876.262.camel@gandalf.local.home>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:34 -0400, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 13:14 +1000, NeilBrown wrote:
> 
> > Surely there is an enormous difference between being required to defend your
> > position against rational and forceful argument, and being required to defend
> > it against irrelevant name calling.
> 
> Sure, but I don't think there's really much name calling in the kernel
> community.
> 
> I just scanned a large number of LKML emails, and they all seemed rather
> technical, and no personal attacks at all. And that included several
> emails from Linus as well. Probably the strongest email came from Thomas
> Gleixner, but even that didn't contain any personal name calling. Mostly
> he called stuff "crap" but that was about the code and claims that the
> code did, but not about the person.
> 
> There are a few times that Linus gets a bit colorful with his
> criticisms, but that's really the minority of the email and not the
> overall tone. I think Linus picks his battles. Sometimes he goes
> overboard, but he's human. But I still think he's running this ship
> well.
> 

I just found this gem: https://lkml.org/lkml/2013/7/10/600

But it's just Linus ranting about having "make install" modify the
source tree (which I totally agree with him, as I've stumbled over crap
like this in other projects). But he's bitching about the code, not the
person who asked him to pull it.

-- Steve


