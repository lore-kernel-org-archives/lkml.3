Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3GPTb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:31:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58131 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933772Ab3GPTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:31:55 -0400
Message-ID: <51E59F79.1040903@zytor.com>
Date: Tue, 16 Jul 2013 12:31:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Chris Ball <cjb@laptop.org>,
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
Subject: Re: [ATTEND] How to act on LKML
References: <20130715174659.GC15531@xanatos>   <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>   <20130715180403.GD15531@xanatos>   <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>   <20130715184642.GE15531@xanatos>   <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>   <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>   <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>   <1373926109.17876.221.camel@gandalf.local.home>   <20130715223615.GI15531@xanatos> <1373932170.28142.24.camel@envy.home>   <864nbv9qcm.fsf@void.printf.net>  <1373944014.17876.255.camel@gandalf.local.home>  <51E4BFA9.1030600@zytor.com>  <alpine.DEB.2.02.1307161230080.4618@kaball.uk.xensource.com> <1373991399.6458.6.camel@gandalf.local.home> <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1307161731210.8258@kaball.uk.xensource.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 09:58 AM, Stefano Stabellini wrote:
> 
> Because Linux is the most widely used kernel, it's everywhere from
> embedded devices to supercomputers.
> Many different companies make a business on Linux and pay people to work
> on it (not FreeBSD or NetBSD). But that's different from what I was
> saying below. Also not all the sub-groups within the kernel development
> circles work this way.
> 

I think you have an inverse causal relationship here.

Linux took off in a way that the other OSS operating systems didn't, and
several of them had started earlier and with way more funding available.

You really have to think about why we are not running Hurd, or any of
the various *BSDs, and instead Linus' "not big and professional like
GNU" hack.  In my opinion it was because the Linux community was in fact
the most open and welcoming of the Open Source communities around.

> When HPA wrote "I find it utterly impossible to be offended by it", that
> might be true for Linus' rants and I also find them humorous sometimes.
> But unfortunately this kind of behavior is by no means limited to Linus
> and it's easy to misunderstand, especially when you don't know the
> person.

There seem to be a fair number of people who think they can imitate
Linus' style but do so without understanding the subtle aspects about
how to apply it.

	-hpa

