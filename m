Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbbAGV3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:29:43 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43358 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbAGV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:29:42 -0500
Date: Wed, 7 Jan 2015 16:29:38 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFwuO2g1S-bY96V28crMWj+dKXWANzbP28JQjBdTg0rV0w@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501071618300.1322@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr> <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <CA+55aFwuO2g1S-bY96V28crMWj+dKXWANzbP28JQjBdTg0rV0w@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Jan 7, 2015 12:34 PM, "Nicolas Pitre" <nicolas.pitre@linaro.org> wrote:
> >
> > I think you are missing something fundamental in this thread.
> 
> No I'm not.
> 
> Dammit, I understand. You guys are the ones who are confused. You have a
> clock, you use it, and you report *that* clock for bogomips.
> 
> It doesn't matter that it's just 10MHz rather than the CPU clock.
> 
> Lying about it is *not* fine, for all the reasons I've already wasted too
> much time trying to explain.

Lying to whom?  And for what purpose?

> Christ, stop with the idiocy already.

Come on.  You're the one coming up with idiotic reasoning for the user 
space visible bogomips number.  Give me at least one logical and 
rational reason why user space should get a timer clock value 
inconsequential to user space code through this interface and I'll shut 
up.  Otherwise I'll interpret your heating up as your inability to 
provide such a reason.


Nicolas
