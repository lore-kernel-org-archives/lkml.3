Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab3GPXL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:11:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32374 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630Ab3GPXLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:11:55 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BvhdhFe28WsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LhvmM_GddXoA:10 a=iTYV8ourjBvtIbWMZu4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374016313.6458.84.camel@gandalf.local.home>
Subject: Re: [ATTEND] How to act on LKML
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chris Ball <cjb@laptop.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Tue, 16 Jul 2013 19:11:53 -0400
In-Reply-To: <alpine.LRH.2.00.1307170038390.20418@twin.jikos.cz>
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
	 <1373991399.6458.6.camel@gandalf.local.home>
	 <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com>
	 <alpine.LRH.2.00.1307170038390.20418@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 00:54 +0200, Jiri Kosina wrote:

> I am not cursing in my e-mails, you are probably neither. Linus is. Others 
> are.

I've been told several times that I'm one of the nicest on LKML. I like
to stick strictly to technical arguments, and will try to help people
out when I can.

The major difference between myself and Linus, is that I only have to
worry about code submissions, and to a much lesser degree than Linus.
But not only does Linus have to manage code, he also dictates policy.
And I'm not sure you can do that easily with cursing people out here and
there.

I have kids, and have run classes full of adults, and in both cases I
found that I had to yell "WHAT THE HELL IS THE MATTER WITH YOU" more
than once. Adults don't always act adult. Sometimes adults can be worse
than kids, as adults have a bit more feeling of power and can become
more argumentative. Although, my kids are now in their teenage years,
and there's a lot more yelling then there use to be.

Point is, I manage code, and don't really need to scold people to get
code right. Linus manages code and policy, and to get people to do
things correctly, and also to lay down his rule, he needs to whack us
from time to time.

-- Steve


