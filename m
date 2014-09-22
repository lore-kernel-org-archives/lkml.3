Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaIVPjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:39:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62175 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbaIVPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:39:16 -0400
Date: Mon, 22 Sep 2014 16:39:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nathan Lynch <nathan_lynch@mentor.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
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
Subject: Re: [PATCH v2 0/3] arm_arch_timer: VDSO preparation, code
 consolidation
Message-ID: <20140922153919.GQ25809@arm.com>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:59:32PM +0100, Nathan Lynch wrote:
> This series contains the necessary changes to allow architected timer
> access from user-space on 32-bit ARM.  This allows the VDSO to support
> high resolution timestamps for clock_gettime and gettimeofday.  This
> also merges substantially similar code from arm and arm64 into the
> core arm_arch_timer driver.
> 
> The functional changes are:
> - When available, CNTVCT is made readable by user space on arm, as it
>   is on arm64.
> - The clocksource name becomes "arch_mem_counter" if CP15 access to
>   the counter is not available.
> 
> These changes have been carried as part of the ARM VDSO patch set over
> the last several months, but I am splitting them out here as I assume
> they should go through the clocksource maintainers.

For the series:

  Acked-by: Will Deacon <will.deacon@arm.com>

I'm not sure which tree the arch-timer stuff usually goes through, but
the arm/arm64 bits look fine so I'm happy for them to merged together.

Will
