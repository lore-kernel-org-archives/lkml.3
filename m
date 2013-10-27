Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3J0KDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 06:03:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41699 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0KDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 06:03:46 -0400
Date: Sun, 27 Oct 2013 10:00:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131027100047.GY16735@n2100.arm.linux.org.uk>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com> <1382706224-8859-1-git-send-email-treding@nvidia.com> <1382706224-8859-4-git-send-email-treding@nvidia.com> <20131025132553.GE9999@mudshark.cambridge.arm.com> <20131026084033.GA14237@gmail.com> <20131026140125.GA13424@mudshark.cambridge.arm.com> <20131027071237.GA448@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027071237.GA448@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:12:37AM +0100, Ingo Molnar wrote:
> 
> * Will Deacon <will.deacon@arm.com> wrote:
> > In future, I'll push back on any perf changes outside of arch/ in my 
> > tree, but that doesn't help us get out of the current situation: the 
> > patches are currently sitting in rmk's tree for 3.13, so that won't meet 
> > with -tip (outside of next) until Linus pulls them both. What can we do 
> > about that?
> 
> Unless you guys want to do a revert I guess there's not much to do but to 
> warn Linus in the ARM pull request that a conflict is coming up.

>From Will's description, it sounded like this could be quite hairy to
fix up, so I'd like to include the conflict resolution in the pull
request so Linus has something to refer to if needed.  Could someone
please forward me that?

Thanks.
