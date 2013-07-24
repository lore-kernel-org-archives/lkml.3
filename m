Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3GXUc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:32:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51083 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3GXUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:32:55 -0400
Date: Wed, 24 Jul 2013 13:32:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/5] Memory mapped architected timers
Message-ID: <20130724203253.GE27761@codeaurora.org>
References: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
 <20130722170817.GB4833@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722170817.GB4833@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Mark Rutland wrote:
> Hi Stephen,
> 
> On Fri, Jul 19, 2013 at 12:59:27AM +0100, Stephen Boyd wrote:
> > This patchset adds support for memory mapped architected timers. We
> > don't have any other global broadcast timer in our system, so we use the
> > mmio timer during low power modes. The first patch changes the register
> > accessor to an enum per Thomas' request. The second patch is the binding.
> > The next two patches lay some groundwork so that the last patch is simpler.
> > The final patch adds support for mmio timers.
> > 
> > Patches are based on v3.11-rc1.
> 
> Be aware that as of v3.11-rc2 this doesn't cleanly apply, as the
> __cpuinit removal broke the final patch's context in a couple of places.
> It would be nice to get rid of the new cpuinit additions too...
> 
> With that cleaned up locally, I've gave this a spin on tc2 and a
> Foundation model to test the cp15/system timers, hotplugging CPUs and
> running a basic test (`time sleep 5`). That all seems to work.
> 
> Unfortunately I have no way of testing the memory-mapped timer support,
> but I trust you've tested that locally.
> 
> For the series:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 

Thanks Mark.

Daniel, can you pick up these patches please?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
