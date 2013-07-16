Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3GPHdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:33:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:34696 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3GPHde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:33:34 -0400
Date: Tue, 16 Jul 2013 00:32:53 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable
 review)
In-Reply-To: <20130715223615.GI15531@xanatos>
Message-ID: <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
References: <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com> <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos> <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com> <1373926109.17876.221.camel@gandalf.local.home>
 <20130715223615.GI15531@xanatos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Sarah Sharp wrote:

> The people who want to work together in a civil manner should get
> together and create a "Kernel maintainer's code of conduct" that
> outlines what they expect from fellow kernel developers.  The people who
> want to continue acting "unprofessionally" should document what
> behaviors set off their cursing streaks, so that others can avoid that
> behavior.  Somewhere in the middle is the community behavior all
> developers can thrive in.

By defining your viewpoint as being "professional" and the other viewpoint as 
being "unprofessional" you have already started using very loaded terms and 
greatly reduces the probability of actually getting the other group to agree and 
participate.

As has been said elsewhere, almost all the attacks are against code, not people. 
There are occasional outbursts at the more experienced/trusted people along the 
lines of "you should know better than to do that", and while there is heat 
there, there is also a lot of truth. If those people can't be trusted not to do 
the wrong things, then we are back to the time when Linus had to review every 
patch himself and we hit that wall quite hard.

People do need to be called out on their mistakes. In companies, if you don't 
fire managers who do the wrong thing soon enough, it can ruin the company. In 
kernel development, you have a very large number of observers and if they don't 
see people being corrected for doing the wrong thing, they will emulate it.

I find that frequently the most educational discussions to read are the 'heated' 
ones, they are the ones where the 'right' and 'wrong' processes are most clearly 
explained, not just in terms of what the processes are, but also the WHY of the 
process being 'right' or 'wrong'.

If Linus just snaps at someone and they say 'oops, missed that', it's no big 
deal for anyone. But when a full argument/discussion takes place, a lot more 
people learn and apply the lessons to their own work.

David Lang
