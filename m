Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3J1Iqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:46:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41772 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3J1Iqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:46:43 -0400
Date: Mon, 28 Oct 2013 08:45:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131028084537.GH16735@n2100.arm.linux.org.uk>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com> <1382706224-8859-1-git-send-email-treding@nvidia.com> <1382706224-8859-4-git-send-email-treding@nvidia.com> <20131025132553.GE9999@mudshark.cambridge.arm.com> <20131026084033.GA14237@gmail.com> <20131026140125.GA13424@mudshark.cambridge.arm.com> <20131027071237.GA448@gmail.com> <20131027100047.GY16735@n2100.arm.linux.org.uk> <20131028074716.GC6629@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028074716.GC6629@ulmo.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 08:47:22AM +0100, Thierry Reding wrote:
> On Sun, Oct 27, 2013 at 10:00:48AM +0000, Russell King - ARM Linux wrote:
> > On Sun, Oct 27, 2013 at 08:12:37AM +0100, Ingo Molnar wrote:
> > > 
> > > * Will Deacon <will.deacon@arm.com> wrote:
> > > > In future, I'll push back on any perf changes outside of arch/ in my 
> > > > tree, but that doesn't help us get out of the current situation: the 
> > > > patches are currently sitting in rmk's tree for 3.13, so that won't meet 
> > > > with -tip (outside of next) until Linus pulls them both. What can we do 
> > > > about that?
> > > 
> > > Unless you guys want to do a revert I guess there's not much to do but to 
> > > warn Linus in the ARM pull request that a conflict is coming up.
> > 
> > From Will's description, it sounded like this could be quite hairy to
> > fix up, so I'd like to include the conflict resolution in the pull
> > request so Linus has something to refer to if needed.  Could someone
> > please forward me that?
> 
> Hi Russell,
> 
> I've attached the relevant parts of the resolution, although I'm not
> sure if anybody's actually confirmed that it's correct.

I'm not sure whether that can happen any time before -final - Will is
(storm dependent) flying out to Linaro Connect today, and I've no idea
who to turn to for this to be tested for ARM.

I guess we have some time given that Linus has released -rc7 and his
comments during the Kernel Summit/in the rc7 announcement.
