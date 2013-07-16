Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab3GPARi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:17:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GPARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:17:36 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=yDfxGvREtdsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5Bi_wUEe0twA:10 a=Pn67Rk4ioemEYvVpBP4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373933850.17876.224.camel@gandalf.local.home>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
From: Steven Rostedt <rostedt@goodmis.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Mon, 15 Jul 2013 20:17:30 -0400
In-Reply-To: <20130715231555.GA24650@roeck-us.net>
References: <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos>
	 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	 <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <1373926109.17876.221.camel@gandalf.local.home>
	 <20130715223615.GI15531@xanatos> <20130715231555.GA24650@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 16:15 -0700, Guenter Roeck wrote:
>  
> One thing you should keep in mind in your discussion is what can happen
> if people get too polite with each other.
> 
> I have seen this happen at two large companies I worked for. Early on, flames
> are acceptable and expected as response to someone publishing bad code which
> breaks everything for everyone. Then, at some point, it is not acceptable
> anymore to flame, and one is expected to be polite and friendly at all times.
> "Your code breaks the build for every platform. Would you please kindly
> consider fixing it ?"
> Result is that code quality suffers, to the point where images don't even
> build anymore.
> 
> I hope the Linux kernel never gets into that stage. To avoid that,
> I am willing to be cursed at by Linus if I am the responsible party.

Didn't Jim Zemlin show some research where there were two groups:

 One that did a bunch of brain storming where no idea was a bad idea

 The other required you to defend your idea while the others bashed it.

The results always showed that the second group not only did a better
job, but also faster and more efficient.

I'm afraid if we worry too much about politeness, we will fall into that
first group.

-- Steve


