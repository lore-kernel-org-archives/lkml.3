Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GPDG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:06:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20500 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GPDG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:06:57 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BvhdhFe28WsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LhvmM_GddXoA:10 a=1CfuknWKxvDg9HzUsZYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373944014.17876.255.camel@gandalf.local.home>
Subject: Re: [ATTEND] How to act on LKML
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Ball <cjb@laptop.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
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
Date: Mon, 15 Jul 2013 23:06:54 -0400
In-Reply-To: <864nbv9qcm.fsf@void.printf.net>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 03:43 +0100, Chris Ball wrote:
> Hi,

> I'd like other developers to treat me this way too, but perhaps a good
> way to get started is to first come up with a statement of how we'd
> like to treat others, and then start collecting signatories to it.
> Does that sound like a good idea?

"collecting signatories"? Like getting signatures from kids that say
they will remain virgins till they marry? In the end, they all end up
getting screwed.

No, we don't need any pact to sign. I'm not sure this is really that
much of an issue. Yes, Linus likes to rant, but that's basically his
trademark. There's a few other grumpy kernel developers that can be a
bit heavy handed too. But really, if you don't want to be cursed at,
here's some pretty easy instructions to follow.


1) Read what a maintainer tells you twice. If you are pointed to a
document, read that twice.

2) If you don't understand what the maintainer says, ask what he/she
meant.

3) Be honest! Don't try to pull that you know something that you really
don't.

4) If you change existing infrastructure. Prove that your change is
better. And not just on your box, on many other boxes. Post RFCs asking
others to test, and give feedback. Don't claim its better till the
numbers are in.

5) Don't be afraid to admit you don't know something. I find people that
tell you what they don't know have much more integrity than people that
keep telling you what they do know.

I don't see any kernel developer cursing at someone because they just
feel like cursing at someone. It's usually caused by someone not being
honest with themselves or the developers they are dealing with. Or
simply not listening to what they are being told.

Linus's point is that he wants to be honest, and cursing is his way of
giving you the most direct way to understand how he honestly feels.

-- Steve


