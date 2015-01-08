Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbbAHRic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:38:32 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62888 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAHRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:38:30 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 8 Jan 2015 12:39:11 -0500 (EST)
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vince Weaver <vince@deater.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150108170117.GC17290@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.11.1501081234510.26338@vincent-weaver-1.umelst.maine.edu>
References: <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk> <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
 <20150108103911.GQ12302@n2100.arm.linux.org.uk> <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy> <20150108161908.GA17290@e104818-lin.cambridge.arm.com> <20150108163450.GV12302@n2100.arm.linux.org.uk> <20150108164111.GB17290@e104818-lin.cambridge.arm.com>
 <20150108165705.GW12302@n2100.arm.linux.org.uk> <20150108170117.GC17290@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Catalin Marinas wrote:

> On Thu, Jan 08, 2015 at 04:57:05PM +0000, Russell King - ARM Linux wrote:
> > On Thu, Jan 08, 2015 at 04:41:12PM +0000, Catalin Marinas wrote:
> > > On Thu, Jan 08, 2015 at 04:34:50PM +0000, Russell King - ARM Linux wrote:
> > > > On Thu, Jan 08, 2015 at 04:19:08PM +0000, Catalin Marinas wrote:
> > > > > I really think we should stop this thread. User ABI breakage fixed now.
> > > > 
> > > > No.  Vince's email shows a more serious problem.
> > > > 
> > > > The ABI breakage issue was reported before the patches were apparently
> > > > merged, but that information seems to have been lost.  We need to
> > > > understand how that happened so similar instances don't happen in the
> > > > future.
> > > 
> > > FYI, searching for "Vince Weaver" and "bogomips" found this:
> > > 
> > > https://lkml.org/lkml/2013/7/11/454
> > 
> > Gah.
> > 
> > It looks like the report was made by hanging it into a totally different
> > thread to the patches which caused the problem, and which went nowhere
> > near the ARM kernel mailing lists.
> > 
> > At least that explains why people like me who really need to know this
> > stuff were not aware of the issue.
> > 
> > One thing I still can't get my head around though is... Vince reported
> > the breakage on 11 July 2013, but the patch is dated 30 August and I
> > merged it 2 September.  So, how did Vince know about it to report the
> > ABI breakage?  Had it been sitting somewhere else?
> 
> Well, the patch may have been on the list, acked, before July but it
> only went to the patch system on the 30th of August. Vince probably
> concluded that it will go in once acked on the list.

Yes, it looks like it went out on the linux-arm-kernel list on 
3 May 2013.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166728.html

I don't follow that list though, so someone must have pointed me to the 
posting.

Though there must have been something else too, I definitely recall 
reading a long rant about how annoying it was that everyone was reporting 
bogomips value errors and this was the best way to handle things.  
All of the postings of the patch I can find are much more laid back.

Mostly why I didn't push the issue though was all the pushback I've gotten 
over the years for trying to get perf_event ABI breaks reverted (I've 
never successfully managed to get that to happen).

Vince
