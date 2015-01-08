Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbbAHRB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:01:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58042 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbAHRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:01:26 -0500
Date: Thu, 8 Jan 2015 17:01:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vince Weaver <vince@deater.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108170117.GC17290@e104818-lin.cambridge.arm.com>
References: <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
 <20150108103911.GQ12302@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
 <20150108161908.GA17290@e104818-lin.cambridge.arm.com>
 <20150108163450.GV12302@n2100.arm.linux.org.uk>
 <20150108164111.GB17290@e104818-lin.cambridge.arm.com>
 <20150108165705.GW12302@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108165705.GW12302@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 04:57:05PM +0000, Russell King - ARM Linux wrote:
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
> 
> At least that explains why people like me who really need to know this
> stuff were not aware of the issue.
> 
> One thing I still can't get my head around though is... Vince reported
> the breakage on 11 July 2013, but the patch is dated 30 August and I
> merged it 2 September.  So, how did Vince know about it to report the
> ABI breakage?  Had it been sitting somewhere else?

Well, the patch may have been on the list, acked, before July but it
only went to the patch system on the 30th of August. Vince probably
concluded that it will go in once acked on the list.

-- 
Catalin
