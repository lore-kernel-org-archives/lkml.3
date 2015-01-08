Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbbAHRVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:21:18 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:37012 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbAHRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:21:17 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 8 Jan 2015 12:22:02 -0500 (EST)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Catalin Marinas <catalin.marinas@arm.com>, Vince Weaver <vince@deater.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150108165705.GW12302@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.11.1501081217390.25399@vincent-weaver-1.umelst.maine.edu>
References: <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com> <20150108103911.GQ12302@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy> <20150108161908.GA17290@e104818-lin.cambridge.arm.com> <20150108163450.GV12302@n2100.arm.linux.org.uk>
 <20150108164111.GB17290@e104818-lin.cambridge.arm.com> <20150108165705.GW12302@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Russell King - ARM Linux wrote:

> On Thu, Jan 08, 2015 at 04:41:12PM +0000, Catalin Marinas wrote:
> > On Thu, Jan 08, 2015 at 04:34:50PM +0000, Russell King - ARM Linux wrote:
> > > On Thu, Jan 08, 2015 at 04:19:08PM +0000, Catalin Marinas wrote:
> > > > I really think we should stop this thread. User ABI breakage fixed now.
> > > 
> > > No.  Vince's email shows a more serious problem.
> > > 
> > > The ABI breakage issue was reported before the patches were apparently
> > > merged, but that information seems to have been lost.  We need to
> > > understand how that happened so similar instances don't happen in the
> > > future.
> > 
> > FYI, searching for "Vince Weaver" and "bogomips" found this:
> > 
> > https://lkml.org/lkml/2013/7/11/454
> 
> Gah.
> 
> It looks like the report was made by hanging it into a totally different
> thread to the patches which caused the problem, and which went nowhere
> near the ARM kernel mailing lists.

yes, though by that point I had thought it was a done deal and so was 
mostly complaining about it with regard to another issue.

I usually don't hang out on the ARM lists, but perf-event related ones, 
which was why I was primarily discussing the issue with Will Deacon
in that case.

> One thing I still can't get my head around though is... Vince reported
> the breakage on 11 July 2013, but the patch is dated 30 August and I
> merged it 2 September.  So, how did Vince know about it to report the
> ABI breakage?  Had it been sitting somewhere else?

That's a good question.  Someone definitely had told me that is was going 
to happen earlier, but I can't remember where now.  Definitely someone 
with enough authority that I thought it wasn't worth the trouble 
complaining (I already seemingly have half the perf_event people annoyed 
with me on any given day, the last thing I wanted to do was get all of 
the ARM devs mad at me too).

Vince



