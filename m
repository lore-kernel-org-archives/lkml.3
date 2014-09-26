Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaIZJ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:26:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41708 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbaIZJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:25:59 -0400
Date: Fri, 26 Sep 2014 10:26:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nathan Lynch <nathan_lynch@mentor.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] clocksource: arm_arch_timer: change clocksource
 name if CP15 unavailable
Message-ID: <20140926092604.GC22293@arm.com>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
 <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com>
 <54250FFE.2050605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54250FFE.2050605@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 08:04:30AM +0100, Daniel Lezcano wrote:
> On 09/18/2014 04:59 PM, Nathan Lynch wrote:
> > The arm and arm64 VDSOs need CP15 access to the architected counter.
> > If this is unavailable (which is allowed by ARM v7), indicate this by
> > changing the clocksource name to "arch_mem_counter" before registering
> > the clocksource.
> >
> > Suggested by Stephen Boyd.
> >
> > Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
> > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Hi Nathan,
> 
> is it possible to have the acked-by of the different maintainers for the 
> other patches ?

FWIW: I acked the series:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/289143.html

There's ongoing debate about whether or not we should have a vdso, but this
series still makes sense in isolation.

Will
