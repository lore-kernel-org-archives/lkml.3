Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3GVQXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:23:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32950 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab3GVQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:23:43 -0400
Date: Mon, 22 Jul 2013 09:23:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 10/17] clocksource: mxs_timer: Switch to
 sched_clock_register()
Message-ID: <20130722162337.GA19639@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <1374189690-10810-11-git-send-email-sboyd@codeaurora.org>
 <20130722081025.GE20271@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722081025.GE20271@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Shawn Guo wrote:
> On Thu, Jul 18, 2013 at 04:21:23PM -0700, Stephen Boyd wrote:
> > The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> > the 64 bit function to allow us to remove the 32 bit registration
> > interface.
> > 
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
> BTW, will the series break setup_sched_clock() users that are not
> converted, like arch/arm/mach-imx/time.c?  I can understand that's the
> consequence of not moving things into drivers/ folder :)

Thanks.

I will convert all arch/arm users when this series is pulled into
the tip tree. The arm patches will have to go through the arm-soc
branch and so we'll need some stable branch in tip for that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
