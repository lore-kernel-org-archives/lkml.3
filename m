Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3BKR7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:59:06 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52940 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab3BKR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:59:04 -0500
Date: Mon, 11 Feb 2013 18:58:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130211175856.GC9716@gmail.com>
References: <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
 <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
 <20130211172807.GA9716@gmail.com>
 <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Feb 11, 2013 9:28 AM, "Ingo Molnar" <mingo@kernel.org> wrote:
>
> > How on earth can anyone, against all that evidence, still 
> > claim that it's a net minus?
> 
> Because I don't think there is any reason for mixing up the 
> projects. Why do you not just make it separate? Everything you 
> claim is such a big deal would still work perfectly well.
> 
> Every time you talk about "negative" it's as of the project 
> wouldn't exist if it was external. Which is total bull, since 
> it is effectively external already. [...]

That's not actually true. If you check the list of early 
tools/kvm/ contributors you will see an overlap with -tip 
contributors. I know tools/kvm/ developers who just use their 
existing -tip repo to pick up the latest. They are using the 
-tip commit notifications to see what went in and what not, etc.

Claiming that because the contribution model works to a certain 
degree integrated into a small Linux subsystem tree it does not 
ever have to go upstream is so wrong on so many levels ...

The most likely correct statement would be something like: "if 
it worked on a small scale it will probably work even better 
with more exposure on a larger scale." We'll never know that 
though.

( That is also why some of the focus was on lockdep - knowing 
  that it's close in terms of maintenance distance made it an 
  easier topic - socially. )

Since I'm using it on an almost daily basis to test out failed 
bzImages, and because I (mistakenly) thought it had some 
upstream chances, I found it good to help out (a bit) with 
maintenance and code review.

While it works it's obviously limited - there's just so many 
-tip developers and I thought everyone would benefit from this 
going the next natural step.

> [...] And it will stay that way. You are just in denial and 
> trying to say that integrating it would somehow help.
> 
> And I claim it wouldn't. It works fine outside already. Just 
> ADMIT it.

So tools/kvm/ works 'just fine' - in its current limited form - 
because for the developers involved it's already "upstream", for 
the first hop of upstream.

So basically Pekka optimistically thought it's an eventual 'tit 
for tat', a constant stream of benefits to the kernel, in the 
hope of finding a home in the upstream kernel which would 
further help both projects. The kernel wants to keep the 'tit' 
only though.

Thanks,

	Ingo
