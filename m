Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3J0HMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:12:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33309 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3J0HMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:12:43 -0400
Date: Sun, 27 Oct 2013 08:12:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux@arm.linux.org.uk
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131027071237.GA448@gmail.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-4-git-send-email-treding@nvidia.com>
 <20131025132553.GE9999@mudshark.cambridge.arm.com>
 <20131026084033.GA14237@gmail.com>
 <20131026140125.GA13424@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026140125.GA13424@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> Hi Ingo,
> 
> [adding rmk]
> 
> On Sat, Oct 26, 2013 at 09:40:33AM +0100, Ingo Molnar wrote:
> > * Will Deacon <will.deacon@arm.com> wrote:
> > > On Fri, Oct 25, 2013 at 02:03:42PM +0100, Thierry Reding wrote:
> > > > I fixed it up (see below). Please verify that the resolution looks good.
> > > > Also note that this isn't really a trivial resolution of a conflict, but
> > > > required modifying various other files. That causes rerere magic not to
> > > > work and needs part of conflict to be resolved manually. Perhaps a good
> > > > idea would be to rebase Jean's patch on top of the cleanups going on in
> > > > the tip tree? Perhaps even carry the patch in the tip tree?
> > > 
> > > These came via my tree (arm perf) after discussion here:
> > > 
> > >   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/203077.html
> > > 
> > > Now that they've been pulled by rmk, we can't back them out with 
> > > ugly reverts, so I'm not sure what we can do to resolve in the ARM 
> > > tree; it looks like the perf Makefile has changed significantly in 
> > > -tip.
> > 
> > I realize that it was acked by Arnaldo, but for workflow reasons I'd 
> > really prefer it if non-trivial perf tooling patches went to Arnaldo 
> > as a pull request so that he can resolve any such conflicts. perf is 
> > in constant development so it's less work for you that way.
> 
> Sure. I wasn't aware quite how much you guys had planned for the perf 
> Makefile and I (wrongly) assumed that Arnaldo's ack was enough of an 
> indication that conflicts would be unlikely and/or trivial.

That was a bit of unlucky timing.

> In future, I'll push back on any perf changes outside of arch/ in my 
> tree, but that doesn't help us get out of the current situation: the 
> patches are currently sitting in rmk's tree for 3.13, so that won't meet 
> with -tip (outside of next) until Linus pulls them both. What can we do 
> about that?

Unless you guys want to do a revert I guess there's not much to do but to 
warn Linus in the ARM pull request that a conflict is coming up.

Thanks,

	Ingo
