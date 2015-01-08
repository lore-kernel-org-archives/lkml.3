Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbAHFzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 00:55:05 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:39291 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbAHFzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 00:55:03 -0500
Date: Thu, 8 Jan 2015 00:54:59 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFyDQ4Mk8hHOvH-2nhpDgN+gBgiLf6=dLVcjKC5uetqzJw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501080013310.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk> <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com> <CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com> <alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr>
 <CA+55aFyKz2tZDq6ANjKVmuvipKtjr+UP4c7ypNXtbXBcapOpKg@mail.gmail.com> <alpine.LFD.2.11.1501072228440.1322@knanqh.ubzr> <CA+55aFyDQ4Mk8hHOvH-2nhpDgN+gBgiLf6=dLVcjKC5uetqzJw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Wed, Jan 7, 2015 at 8:56 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >>
> >> Yes, I actually would mind, unless you have a damn good reason for it.
> >
> > Consistency.
> 
> Fuck no.
> 
> "Completely made up number that you cannot explain" is not consistency.

Again this statement.  I'm not against it as this is a true statement.

I really wonder how you can describe my intent with that statement 
though. We must be living in different universes.  This is so wrong as 
not to be funny anymore.

If you don't want to see my reply that's fine.  It'll be there for the 
posterity at least. If That's because you're just too proud to concede 
I'm right then this is very sad.

All I'm trying to tell you is that 6 *is* a "Completely made up number 
that you cannot explain" for user space and that's what we have right 
now in mainline for some ARM machines.

What I'm advocating for is a number that is _not_ completely made up.  
I'm advocating for a bogomips which meaning is well known and dates back 
to early Linux releases: the number of loops performed by the CPU during 
a jiffy, scaled to a second worth of jiffies, divided by 2 because there 
are 2 instructions in that loop.  Incidentally this very definition is 
the one you provided yourself in this thread. That's what I want, yet 
you qualify this as a "Completely made up number that you cannot 
explain".

> So you want to make bogomips a totally random number, that has no
> meaning, no correlation to any clocksource, and no correlation to cpu
> frequency either?

Yeah right. I challenge you to quote anything I said in my previous 
email where I clearly explained everything in 6 points what I want. 
Anything you may quote to substantiate that statement of yours about 
what I want.  Everyone following this thread knows you can't.

But you probably didn't even read it. It might hurt too much.

Sheesh.


Nicolas
